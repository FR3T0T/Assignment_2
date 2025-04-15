# RLC Circuit Simulation Project

A comprehensive MATLAB simulation environment for analyzing RLC (Resistor-Inductor-Capacitor) circuits under various conditions. This tool provides detailed analysis of circuit behavior, including transient response, frequency characteristics, energy distribution, and parameter sensitivity.

## Table of Contents

- [Overview](#overview)
- [Requirements](#requirements)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Available Analyses](#available-analyses)
- [Parameter Configuration](#parameter-configuration)
- [Output Files](#output-files)
- [Theory](#theory)

## Overview

This project provides a flexible framework for simulating RLC circuits with different damping conditions, input types, and initial states. The simulation is based on solving the second-order differential equations that govern RLC circuit behavior using MATLAB's ODE45 solver. 

Key features:
- Multiple analysis types for comprehensive circuit characterization
- Configurable circuit parameters via text files
- Detailed visualization of circuit behavior
- Energy and power analysis
- Flexible input voltage types (step, sine, pulse)

## Requirements

- MATLAB (R2016b or newer recommended)
- MATLAB ODE solver (part of standard MATLAB installation)

## Installation

1. Clone or download the repository to your local machine
2. Add the project directory to your MATLAB path by running:

```matlab
addpath(genpath('/path/to/rlc_simulation'));
```

**Important:** You must maintain the exact folder structure shown below. The simulation depends on this specific organization to locate parameter files and save outputs correctly.

## Project Structure

```
rlc_simulation/
│
├── main_rlc.m                  # Main controller script
│
├── analysis/                   # Analysis scripts
│   ├── analyze_basic_response.m       # Basic circuit response
│   ├── analyze_damping.m              # Damping comparison
│   ├── analyze_energy_distribution.m  # Energy distribution
│   ├── analyze_frequency_response.m   # Frequency domain analysis
│   └── analyze_parameter_sweep.m      # Parameter sensitivity
│
├── core_functions/             # Core simulation functions
│   ├── input_voltage.m         # Input voltage generator
│   ├── load_parameters.m       # Parameter file parser
│   └── rlc_equations.m         # RLC differential equations
│
├── parameters/                 # Circuit parameter files
│   ├── circuit_params.txt      # Default parameters
│   ├── critical_params.txt     # Critically damped case
│   ├── overdamped_params.txt   # Overdamped case
│   └── underdamped_params.txt  # Underdamped case
│
├── utility/                    # Utility functions
│   ├── analyze_results.m       # Results processing
│   ├── plot_results.m          # Visualization
│   └── save_results.m          # Data export
│
└── output/                     # Output files (created at runtime)
    ├── rlc_output.dat          # Simulation data
    ├── damping_comparison.png  # Generated figures
    └── ...
```

## Usage

1. **Basic Usage**: Run the main script to execute all analyses:

```matlab
main_rlc
```

2. **Selective Analysis**: Edit `main_rlc.m` to select specific analyses by setting the appropriate flags to `true` or `false`:

```matlab
run_basic_simulation = true;
run_damping_comparison = true;
run_frequency_analysis = true;
run_energy_distribution = true;
run_parameter_sweep = true;
```

3. **Custom Parameters**: Edit the text files in the `parameters/` directory to customize circuit behavior.

## Available Analyses

### 1. Basic Response Analysis (`analyze_basic_response.m`)
Performs a standard time-domain simulation of the RLC circuit with parameters specified in `circuit_params.txt`. Outputs charge, current, energy, and power plots.

### 2. Damping Comparison (`analyze_damping.m`)
Compares underdamped, critically damped, and overdamped responses using different parameter sets. Creates a journal-style figure showing the current response for each damping condition.

### 3. Frequency Response Analysis (`analyze_frequency_response.m`)
Analyzes the frequency domain behavior of the circuit, plotting impedance magnitude versus frequency for different damping ratios. Identifies resonant frequency and bandwidth.

### 4. Energy Distribution Analysis (`analyze_energy_distribution.m`)
Studies how energy is exchanged between the capacitor and inductor over time in an underdamped circuit with initial charge. Includes theoretical decay envelope.

### 5. Parameter Sweep Analysis (`analyze_parameter_sweep.m`)
Performs sensitivity analysis by varying resistance values and observing the effect on damping coefficient, natural frequency, and resonant frequency.

## Parameter Configuration

Parameters are specified in plain text files in the `parameters/` directory. Each parameter is defined on a separate line with the format:

```
parameter_name = value  # Optional comment
```

Example parameters:
- `resistance`: Resistance in Ohms
- `inductance`: Inductance in Henry
- `capacitance`: Capacitance in Farad
- `initialCharge`: Initial charge on capacitor in Coulombs
- `initialCurrent`: Initial current through inductor in Amperes
- `inputType`: Type of input voltage ('step', 'sine', 'pulse')
- `amplitude`: Amplitude of input voltage in Volts
- `frequency`: Frequency of sine wave input in Hz
- `stepTime`: Time when step input is applied in seconds

## Output Files

The simulation generates two types of output:
1. **Data files**: Saved in the `output/` directory with `.dat` extension
2. **Figures**: Saved as both `.fig` (MATLAB figure) and `.png` (image) files

The data files contain:
- Time values
- Charge
- Current
- Energy components (capacitor, inductor, total)
- Power dissipation

## Theory

The RLC circuit behavior is characterized by its damping coefficient (ζ):
ζ = R/(2*sqrt(L/C))

Where:
- R is resistance in Ohms
- L is inductance in Henry
- C is capacitance in Farad

Based on the damping coefficient, the circuit response is classified as:
- Underdamped (ζ < 1): Oscillatory response
- Critically damped (ζ = 1): Fastest non-oscillatory response
- Overdamped (ζ > 1): Non-oscillatory response

The natural frequency of the circuit is:
ω_n = 1/sqrt(L*C) rad/s

For underdamped circuits, the damped resonant frequency is:
ω_d = ω_n * sqrt(1 - ζ²) rad/s

The resonant frequency, where impedance is minimized, is important for frequency response analysis. Quality factor (Q) relates to bandwidth:
Q = (1/R)*sqrt(L/C)
Bandwidth = resonant_frequency/Q

Energy in the circuit oscillates between the capacitor and inductor while gradually dissipating in the resistor. The total energy decay follows an exponential envelope with time constant:
τ = 2*L/R seconds