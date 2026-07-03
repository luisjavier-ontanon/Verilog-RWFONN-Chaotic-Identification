clear; clc; close all;

% Leer archivo CSV
T = readtable("C:/My_Designs/UDS_RWFONN_9signals.csv");

% Tiempo
t = T.time_ns;

% Señales del sistema maestro
xm = T.xm_real;
ym = T.ym_real;
zm = T.zm_real;

% Señales del sistema esclavo / red
xs = T.xs_real;
ys = T.ys_real;
zs = T.zs_real;

% Errores punto a punto
errorx = abs(xm - xs);
errory = abs(ym - ys);
errorz = abs(zm - zs);

% Error euclidiano total 3D, opcional
error_total = sqrt(errorx.^2 + errory.^2 + errorz.^2);

figure
plot(t, error_total)
% Figura principal
figure('Name','Comparación maestro-esclavo UDS','Color','w');

% =========================
% Gráfica 1: xm y xs
% =========================
ax1 = subplot(3,1,1);
plot(t, xm, 'LineWidth', 1.0); hold on;
plot(t, xs, '--', 'LineWidth', 1.0);
grid on;
ylabel('x');
title('Comparación x_m y x_s');
legend('x_m','x_s','Location','best');

% Inset errorx
pos1 = get(ax1, 'Position');
ax1_in = axes('Position', [pos1(1)+0.62*pos1(3), pos1(2)+0.48*pos1(4), 0.32*pos1(3), 0.38*pos1(4)]);
plot(t, errorx, 'LineWidth', 0.8);
grid on;
title('|x_m - x_s|', 'FontSize', 8);
set(gca, 'FontSize', 7);

% =========================
% Gráfica 2: ym y ys
% =========================
ax2 = subplot(3,1,2);
plot(t, ym, 'LineWidth', 1.0); hold on;
plot(t, ys, '--', 'LineWidth', 1.0);
grid on;
ylabel('y');
title('Comparación y_m y y_s');
legend('y_m','y_s','Location','best');

% Inset errory
pos2 = get(ax2, 'Position');
ax2_in = axes('Position', [pos2(1)+0.62*pos2(3), pos2(2)+0.48*pos2(4), 0.32*pos2(3), 0.38*pos2(4)]);
plot(t, errory, 'LineWidth', 0.8);
grid on;
title('|y_m - y_s|', 'FontSize', 8);
set(gca, 'FontSize', 7);

% =========================
% Gráfica 3: zm y zs
% =========================
ax3 = subplot(3,1,3);
plot(t, zm, 'LineWidth', 1.0); hold on;
plot(t, zs, '--', 'LineWidth', 1.0);
grid on;
xlabel('t');
ylabel('z');
title('Comparación z_m y z_s');
legend('z_m','z_s','Location','best');

% Inset errorz
pos3 = get(ax3, 'Position');
ax3_in = axes('Position', [pos3(1)+0.62*pos3(3), pos3(2)+0.48*pos3(4), 0.32*pos3(3), 0.38*pos3(4)]);
plot(t, errorz, 'LineWidth', 0.8);
grid on;
title('|z_m - z_s|', 'FontSize', 8);
set(gca, 'FontSize', 7);

% Título general
sgtitle('Sincronización UDS-RWFONN: maestro vs esclavo con errores');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================
% Figura 1: xm y xs
% =========================
f1 = figure('Name','xm vs xs','Color','w');

ax1 = axes('Parent', f1);
plot(ax1, t, xm, 'LineWidth', 1.0); 
hold(ax1, 'on');
plot(ax1, t, xs, '--', 'LineWidth', 1.0);

grid(ax1, 'on');
xlabel(ax1, 't');
ylabel(ax1, 'x');
title(ax1, 'Comparison between x_m and x_s');
legend(ax1, 'x_m','x_s','Location','best');

% Inset errorx
ax1_in = axes('Parent', f1, ...
              'Position', [0.58 0.58 0.30 0.28]);

plot(ax1_in, t, errorx, 'LineWidth', 0.8);
grid(ax1_in, 'on');
title(ax1_in, '|x_m - x_s|', 'FontSize', 8);
set(ax1_in, 'FontSize', 7);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================
% Figura 2: ym y ys
% =========================
f2 = figure('Name','ym vs ys','Color','w');

ax2 = axes('Parent', f2);
plot(ax2, t, ym, 'LineWidth', 1.0); 
hold(ax2, 'on');
plot(ax2, t, ys, '--', 'LineWidth', 1.0);

grid(ax2, 'on');
xlabel(ax2, 't');
ylabel(ax2, 'y');
title(ax2, 'Comparison between y_m and y_s');
legend(ax2, 'y_m','y_s','Location','best');

% Inset errory
ax2_in = axes('Parent', f2, ...
              'Position', [0.58 0.58 0.30 0.28]);

plot(ax2_in, t, errory, 'LineWidth', 0.8);
grid(ax2_in, 'on');
title(ax2_in, '|y_m - y_s|', 'FontSize', 8);
set(ax2_in, 'FontSize', 7);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================
% Figura 3: zm y zs
% =========================
f3 = figure('Name','zm vs zs','Color','w');

ax3 = axes('Parent', f3);
plot(ax3, t, zm, 'LineWidth', 1.0); 
hold(ax3, 'on');
plot(ax3, t, zs, '--', 'LineWidth', 1.0);

grid(ax3, 'on');
xlabel(ax3, 't');
ylabel(ax3, 'z');
title(ax3, 'Comparison between z_m and z_s');
legend(ax3, 'z_m','z_s','Location','best');

% Inset errorz
ax3_in = axes('Parent', f3, ...
              'Position', [0.58 0.58 0.30 0.28]);

plot(ax3_in, t, errorz, 'LineWidth', 0.8);
grid(ax3_in, 'on');
title(ax3_in, '|z_m - z_s|', 'FontSize', 8);
set(ax3_in, 'FontSize', 7);

% T = readtable("C:/My_Designs/UDS_RWFONN_9signals.csv");
% 
% xm = T.xm_real;
% ym = T.ym_real;
% zm = T.zm_real;
% 
% 
% xs = T.xs_real;
% ys = T.ys_real;
% zs = T.zs_real;
% 
% t = T.time_ns;
% 
% 
% figure;
% plot(t, xm);
% hold on
% plot(t, xs);
% grid on;
% xlabel('t (ns)');
% ylabel('x');
% title('Trayectoria del estado x UDS desde Active-HDL');
% 
% %%%%
% 
% figure;
% plot(t, ym);
% hold on
% plot(t, ys);
% grid on;
% xlabel('t (ns)');
% ylabel('x');
% title('Trayectoria del estado y UDS desde Active-HDL');
% 
% 
% figure;
% plot(t, xm);
% hold on
% plot(t, xs);
% grid on;
% xlabel('t (ns)');
% ylabel('x');
% title('Trayectoria del estado z UDS desde Active-HDL');