# Verilog-RWFONN-Chaotic-Identification

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=luisjavier-ontanon/Verilog-RWFONN-Chaotic-Identification&file=matlab_ploting/plot_UDS_RWFONN_csv.m)

## FPGA-Oriented Pre-Silicon Validation of an RWFONN for Chaotic Dynamical-System Identification

This repository contains Verilog, simulation data, MATLAB plotting scripts, scientific figures, and documentation for a **Verilog-based pre-silicon validation** of a **Recurrent Wavelet First-Order Neural Network (RWFONN)** applied to chaotic dynamical-system identification.

The project focuses on the digital implementation of a neural identifier for an **Unstable Dissipative System of type I (UDS-I)** using:

- 32-bit fixed-point two's-complement arithmetic,
- Q1.11.20 numerical representation,
- Forward Euler integration,
- Morlet wavelet activation functions,
- filtered-error dynamics,
- sequential datapath scheduling in Verilog.

The repository is intended for academic reproducibility, scientific dissemination, and future FPGA deployment.

---

## Project Status

Current status:

- **Pre-silicon Verilog validation**
- HDL simulation performed with standard Verilog source files and testbenches
- CSV signal export for post-processing
- MATLAB scripts for visualization of identification performance
- Physical FPGA validation: **pending**
- Hardware target: **to be confirmed**

This repository does not currently claim a complete physical FPGA implementation. It provides the Verilog architecture, simulation workflow, generated signals, and plotting scripts required to reproduce the pre-silicon validation stage.

---

## Authors

**O. Guillen-Fernández**<sup>1</sup>,  
**D. A. Magallon-Garcia**<sup>2,3</sup>,  
**I. Diaz-Allen**<sup>4</sup>,  
**E. Campos-Cantón**<sup>4</sup>,  
**J. H. García-López**<sup>5</sup>,  
**L. J. Ontanon-Garcia**<sup>*2</sup>

<sup>1</sup> Department of Electronics, INAOE, Tonantzintla, Puebla 72840, México.  
<sup>2</sup> Coordinación Académica Región Altiplano Oeste, UASLP, Salinas 78600, San Luis Potosí, México.  
<sup>3</sup> Preparatoria Regional de Lagos de Moreno, Universidad de Guadalajara, Lagos de Moreno 47476, México.  
<sup>4</sup> División de Control y Sistemas Dinámicos, Instituto Potosino de Investigación Científica y Tecnológica A.C. (IPICyT), San Luis Potosí, México.  
<sup>5</sup> Optics, Complex Systems and Innovation Laboratory, Centro Universitario de los Lagos, Universidad de Guadalajara, Enrique Díaz de León 1144, Colonia Paseos de la Montaña, Lagos de Moreno 47463, México.  

<sup>*</sup> Corresponding author: luis.ontanon@uaslp.mx

---

## Scientific Motivation

Chaotic dynamical systems are highly sensitive to initial conditions and parameter variations. Their identification is challenging because small state errors can grow rapidly and because their trajectories contain nonlinear, transient, and frequency-rich components.

Recurrent Wavelet First-Order Neural Networks are attractive for this problem because they combine:

- recurrent dynamics,
- filtered-error adaptation,
- compact first-order structure,
- Morlet wavelet activation functions,
- real-time-oriented neural identification.

The goal of this repository is to make available a Verilog-based digital architecture that moves the RWFONN methodology from numerical simulation toward FPGA-oriented electronic realization.

---

## Architecture Overview

The top-level Verilog module is:

```text
UDS_RWFONN.v
```

The architecture contains:

1. **UDS-I master dynamics**
   - Computes the reference chaotic system.
   - Includes the piecewise-linear nonlinearity `PWL(xm)`.

2. **RWFONN identifier**
   - Computes the neural approximation states `xs`, `ys`, and `zs`.
   - Uses Morlet wavelet activation functions.

3. **Filtered-error dynamics**
   - Computes `w1`, `w2`, and `w3`.
   - Uses the state errors and Morlet activations.

4. **Forward Euler integrators**
   - Nine integration channels:
     - `xm`, `ym`, `zm`
     - `xs`, `ys`, `zs`
     - `w1`, `w2`, `w3`

5. **PIPO parallel registers**
   - Nine state registers.
   - Updated by a counter-generated enable signal.

6. **Counter / Enable block**
   - Generates the `en` signal.
   - Current setting: `max_count = 20`.

---

## Fixed-Point Format

All main signals are represented using a 32-bit fixed-point two's-complement format:

```text
Q1.11.20
```

That is:

- 1 sign bit
- 11 integer bits
- 20 fractional bits

The scaling factor is:

```text
2^20 = 1,048,576
```

Examples:

```text
1.0  -> 32'h0010_0000
0.5  -> 32'h0008_0000
0.2  -> 32'h0003_3333
pi/2 -> approximately 32'h0019_21F8
```

---

## Morlet Wavelet Activation

The implemented activation function is:

```text
psi(x) = exp(-x^2 / 64) cos(0.001 x)
```

The nonlinear terms are implemented with truncated Taylor-series approximations:

```text
e^u ≈ 1 + u + u^2/2! + u^3/3!
```

and

```text
cos(v) ≈ 1 - v^2/2! + v^4/4! - v^6/6!
```

The Verilog datapath for the activation is implemented in:

```text
fun_act_morlet.v
e_x.v
cos_x.v
```

---

## Repository Structure

```text
Verilog-RWFONN-Chaotic-Identification/
│
├── src/
│   ├── UDS_RWFONN.v
│   ├── eval_UDS_RWFONN.v
│   ├── fun_act_morlet.v
│   ├── e_x.v
│   ├── cos_x.v
│   ├── fe_integrator.v
│   ├── pipo_register.v
│   ├── counter.v
│   ├── multiplier2_sec.v
│   ├── adder2_sec.v
│   ├── adder3_sec.v
│   ├── adder4_sec.v
│   ├── substractor2_sec.v
│   ├── pwl_signed_func.v
│   └── scm_*.v
│
├── verilog_simulation/
│   ├── tb_UDS_RWFONN.v
│   └── simulation_notes.md
│
├── matlab_ploting/
│   ├── plot_UDS_RWFONN_csv.m
│   └── README_matlab_ploting.md
│
├── csv_signal/
│   └── UDS_RWFONN_9signals.csv
│
├── figures/
│   ├── matlab_identification_results.png
│   ├── top_level_verilog_architecture_diagram.png
│   ├── internal_datapath_of_eval_uds_rwfonn_module.png
│   └── fixed_point_datapath_of_morlet_wavelet.png
│
├── docs/
│   ├── related_publications.md
│   └── architecture_description.md
│
├── README.md
└── LICENSE
```

---

## Included Figures

### 1. MATLAB identification results

This figure compares the master UDS-I states and the RWFONN-identified states. Insets show the synchronization error magnitude for each state pair.

![MATLAB identification results](figures/matlab_identification_results.png)

### 2. Top-level Verilog architecture

This figure summarizes the full top-level datapath: `eval_UDS_RWFONN`, Forward Euler integrators, PIPO registers, counter/enable logic, and feedback loop.

![Top-level Verilog architecture](figures/top_level_verilog_architecture_diagram.png)

### 3. Internal datapath of `eval_UDS_RWFONN`

This figure shows the internal structure of the master system, Morlet activation bank, RWFONN identifier dynamics, error computation, and filtered-error dynamics.

![Internal datapath of eval_UDS_RWFONN](figures/internal_datapath_of_eval_uds_rwfonn_module.png)

### 4. Fixed-point datapath of the Morlet activation function

This figure illustrates the fixed-point implementation of the Morlet wavelet activation function using truncated Taylor-series approximations of the exponential and cosine terms.

![Fixed-point datapath of the Morlet wavelet](figures/fixed_point_datapath_of_morlet_wavelet.png)

---

## MATLAB Plotting

The CSV signals generated by the Verilog simulation can be plotted using MATLAB.

The MATLAB scripts are located in:

```text
matlab_ploting/
```

The signal files are located in:

```text
csv_signal/
```

The MATLAB workflow includes:

- reading exported CSV signals;
- reconstructing fixed-point values as real numbers;
- comparing the master system states and the RWFONN identifier states;
- plotting:
  - `xm` vs. `xs`
  - `ym` vs. `ys`
  - `zm` vs. `zs`
- plotting the pointwise synchronization errors:
  - `|xm - xs|`
  - `|ym - ys|`
  - `|zm - zs|`

---


## Verilog Simulation

The Verilog code is simulator-oriented and was designed as a pre-silicon validation workflow.

The repository includes a testbench:

```text
verilog_simulation/tb_UDS_RWFONN.v
```

The testbench exports the simulation results to CSV format for MATLAB post-processing.

### Recommended simulation approach

Use any Verilog simulator compatible with the RTL and testbench.

Possible options include:

- an academic HDL simulator,
- Icarus Verilog,
- EDA Playground for smaller module-level tests,
- vendor FPGA simulation tools.

### Experimental open-source simulation command

The following command can be used as a starting point for local testing with Icarus Verilog:

```bash
iverilog -g2012 -o verilog_simulation/uds_rwfonn.vvp src/*.v verilog_simulation/tb_UDS_RWFONN.v
vvp verilog_simulation/uds_rwfonn.vvp
```

Depending on the simulator and directory structure, file paths in the testbench may need to be adjusted before running.

---

## HDL Tool Note

This repository distributes the authors' Verilog source code, MATLAB plotting scripts, figures, and generated CSV signal data.

It does **not** redistribute proprietary HDL simulation software, vendor libraries, installation files, license files, or proprietary simulator binaries.

If results are generated with a specific proprietary or student-edition simulator, users should verify that their own license permits their intended use. The repository is intended to remain reproducible with standard HDL source files and, when possible, open-source or generally available simulation workflows.

---

## Related Publications

### Core RWFONN and neural-identification works

1. Magallón-García, D. A., et al.  
   **RWFONN-based identification of chaotic dynamical systems.**  
   Full bibliographic details to be completed according to the final manuscript.

2. Magallón-García, D. A., et al.  
   **Real-time RWFONN validation on field-programmable analog arrays.**  
   Full bibliographic details to be completed according to the final manuscript.

3. Echenausía-Monroy, J. L., et al.  
   **A recurrent neural network for identifying multiple chaotic systems.**  
   Full bibliographic details to be completed according to the final manuscript.

4. O. Guillen-Fernández, et al.  
   **Related work on neural, dynamical, and electronic implementations.**  
   Additional publications listed below.

### FPGA and numerical-method references relevant to this repository

5. Guillen-Fernandez, O., Moreno-Lopez, M. F., & Tlelo-Cuautle, E. (2021).  
   **Issues on applying one- and multi-step numerical methods to chaotic oscillators for FPGA implementation.**  
   *Mathematics, 9*(2), 151.

6. Sambas, A., Vaidyanathan, S., Tlelo-Cuautle, E., Abd-El-Atty, B., Abd El-Latif, A. A., Guillén-Fernández, O., ... & Gundara, G. (2020).  
   **A 3-D multi-stable system with a peanut-shaped equilibrium curve: Circuit design, FPGA realization, and an application to image encryption.**  
   *IEEE Access, 8*, 137116-137132.

7. Vaidyanathan, S., Tlelo-Cuautle, E., Guillén-Fernández, O., Benkouider, K., & Sambas, A. (2022).  
   **A New 4-D Hyperchaotic System with No Balance Point, Its Bifurcation Analysis, Multi-Stability, Circuit Simulation, and FPGA Realization.**  
   In G. Huerta Cuéllar, E. Campos Cantón, & E. Tlelo-Cuautle (Eds.), *Complex Systems and Their Applications*. Springer, Cham.  
   https://doi.org/10.1007/978-3-031-02472-6_9

### Pending publications

Please update this section with:
- the final journal papers by D. A. Magallon-Garcia and collaborators,
- the corresponding publications by O. Guillen-Fernández and collaborators,
- DOI, journal, volume, issue, year, and page numbers once available.

---

## Citation

If you use this repository for academic or research purposes, please cite it as:

```text
O. Guillen-Fernández, D. A. Magallon-Garcia, I. Diaz-Allen,
E. Campos-Cantón, J. H. García-López, and L. J. Ontanon-Garcia,
"Verilog-RWFONN-Chaotic-Identification,"
GitHub repository, 2026.
[Online]. Available: https://github.com/YOUR-GITHUB-USERNAME/Verilog-RWFONN-Chaotic-Identification
```

After publication of the associated paper, please cite the paper as the primary reference.

---

## License

Recommended licensing scheme:

- Verilog source code and MATLAB scripts: **BSD-3-Clause License**
- Documentation, explanatory figures, and educational material: **CC BY-NC 4.0**, if a non-commercial educational restriction is desired

If a single license is preferred for the entire repository, **BSD-3-Clause** is recommended for simplicity and software compatibility.

See the `LICENSE` file for details.

---

## Acknowledgments

L.J.O.G. thanks the Potosino Council of Science and Technology (COPOCYT) for the support in Trust project 23871 of the 2023-01 Call.

The authors acknowledge the academic and research institutions involved in the development of this project.

---

## Contact

For questions related to this repository, please contact:

**L. J. Ontanon-Garcia**  
Coordinación Académica Región Altiplano Oeste, UASLP  
Email: luis.ontanon@uaslp.mx
