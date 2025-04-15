%% RLC Circuit Simulation - Main Controller
% This script controls which analyses to run in the RLC circuit simulation

% Add all subdirectories to the path
addpath(genpath('.'));

% Choose which analyses to run
run_basic_simulation = true;
run_damping_comparison = true;
run_frequency_analysis = true;
run_energy_distribution = true;
run_parameter_sweep = true;
run_parameter_tuning = true;

% Display header
disp('=========================================');
disp('RLC Circuit Simulation - Master Controller');
disp('=========================================');

% Run selected analyses
if run_basic_simulation
    disp('Running basic RLC circuit simulation...');
    analyze_basic_response;
    disp('Basic simulation completed.');
    disp(' ');
end

if run_damping_comparison
    disp('Running damping comparison analysis...');
    analyze_damping;
    disp('Damping comparison completed.');
    disp(' ');
end

if run_frequency_analysis
    disp('Running frequency response analysis...');
    analyze_frequency_response;
    disp('Frequency response analysis completed.');
    disp(' ');
end

if run_energy_distribution
    disp('Running energy distribution analysis...');
    analyze_energy_distribution;
    disp('Energy distribution analysis completed.');
    disp(' ');
end

if run_parameter_sweep
    disp('Running parameter sweep analysis...');
    analyze_parameter_sweep;
    disp('Parameter sweep analysis completed.');
    disp(' ');
end

if run_parameter_tuning
    disp('Running parameter tuning example...');
    analyze_parameter_tuning;
    disp('Parameter tuning completed.');
    disp(' ');
end

disp('=========================================');
disp('All selected simulations completed successfully.');
disp('=========================================');