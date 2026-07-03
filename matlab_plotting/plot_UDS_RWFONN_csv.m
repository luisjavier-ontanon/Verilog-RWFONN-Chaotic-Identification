% plot_UDS_RWFONN_csv.m
% Plot UDS-RWFONN pre-silicon simulation results from CSV data.
%
% Repository structure expected:
%   matlab_plotting/plot_UDS_RWFONN_csv.m
%   csv_signal/UDS_RWFONN_9signals.csv
%   figures/matlab_identification_results.png

clear; clc; close all;

%% Locate CSV file relative to this script

scriptDir = fileparts(mfilename('fullpath'));

% Fallback only in case the script is executed interactively without a file path
if isempty(scriptDir)
    scriptDir = pwd;
end

repoRoot = fullfile(scriptDir, '..');
csvFile = fullfile(repoRoot, 'csv_signal', 'UDS_RWFONN_9signals.csv');

if ~isfile(csvFile)
    error("CSV file not found. Expected location: %s", csvFile);
end

%% Read CSV data

T = readtable(csvFile);

requiredVars = { ...
    'time_ns', ...
    'xm_real', 'ym_real', 'zm_real', ...
    'xs_real', 'ys_real', 'zs_real'};

missingVars = setdiff(requiredVars, T.Properties.VariableNames);

if ~isempty(missingVars)
    error("Missing expected CSV columns: %s", strjoin(missingVars, ", "));
end

%% Extract signals

t_ns = T.time_ns;
t_us = t_ns / 1000;   % Convert ns to microseconds

% Master system signals
xm = T.xm_real;
ym = T.ym_real;
zm = T.zm_real;

% RWFONN identifier signals
xs = T.xs_real;
ys = T.ys_real;
zs = T.zs_real;

%% Pointwise identification errors

errorx = abs(xm - xs);
errory = abs(ym - ys);
errorz = abs(zm - zs);

error_total = sqrt(errorx.^2 + errory.^2 + errorz.^2);

fprintf("Loaded CSV file: %s\n", csvFile);
fprintf("Number of samples: %d\n", height(T));
fprintf("Maximum |xm - xs|: %.6g\n", max(errorx));
fprintf("Maximum |ym - ys|: %.6g\n", max(errory));
fprintf("Maximum |zm - zs|: %.6g\n", max(errorz));
fprintf("Maximum 3D Euclidean error: %.6g\n", max(error_total));

%% Main figure: master vs identifier signals

fMain = figure( ...
    'Name', 'UDS-RWFONN identification results', ...
    'Color', 'w');

layout = tiledlayout(fMain, 3, 1, ...
    'TileSpacing', 'compact', ...
    'Padding', 'compact');

% x-state comparison
ax1 = nexttile(layout, 1);
plot(ax1, t_us, xm, 'LineWidth', 1.0); hold(ax1, 'on');
plot(ax1, t_us, xs, '--', 'LineWidth', 1.0);
grid(ax1, 'on');
ylabel(ax1, 'x');
title(ax1, 'Comparison between x_m and x_s');
legend(ax1, 'x_m', 'x_s', 'Location', 'best');

% y-state comparison
ax2 = nexttile(layout, 2);
plot(ax2, t_us, ym, 'LineWidth', 1.0); hold(ax2, 'on');
plot(ax2, t_us, ys, '--', 'LineWidth', 1.0);
grid(ax2, 'on');
ylabel(ax2, 'y');
title(ax2, 'Comparison between y_m and y_s');
legend(ax2, 'y_m', 'y_s', 'Location', 'best');

% z-state comparison
ax3 = nexttile(layout, 3);
plot(ax3, t_us, zm, 'LineWidth', 1.0); hold(ax3, 'on');
plot(ax3, t_us, zs, '--', 'LineWidth', 1.0);
grid(ax3, 'on');
xlabel(ax3, 'Time (\mus)');
ylabel(ax3, 'z');
title(ax3, 'Comparison between z_m and z_s');
legend(ax3, 'z_m', 'z_s', 'Location', 'best');

title(layout, 'UDS-RWFONN identification: master system vs identifier');

drawnow;

%% Error insets

addErrorInset(fMain, ax1, t_us, errorx, '|x_m - x_s|');
addErrorInset(fMain, ax2, t_us, errory, '|y_m - y_s|');
addErrorInset(fMain, ax3, t_us, errorz, '|z_m - z_s|');

%% Save figure to repository figures folder

figDir = fullfile(repoRoot, 'figures');

if isfolder(figDir)
    outputFile = fullfile(figDir, 'matlab_identification_results.png');
    exportgraphics(fMain, outputFile, 'Resolution', 300);
    fprintf("Figure saved to: %s\n", outputFile);
else
    warning("Figures folder not found. Figure was not exported.");
end

%% Local function

function addErrorInset(parentFigure, parentAxes, t, err, titleText)
    parentPos = parentAxes.Position;

    insetPos = [ ...
        parentPos(1) + 0.62 * parentPos(3), ...
        parentPos(2) + 0.45 * parentPos(4), ...
        0.32 * parentPos(3), ...
        0.40 * parentPos(4)];

    axInset = axes('Parent', parentFigure, 'Position', insetPos);
    plot(axInset, t, err, 'LineWidth', 0.8);
    grid(axInset, 'on');
    title(axInset, titleText, 'FontSize', 8);
    set(axInset, 'FontSize', 7);
end
