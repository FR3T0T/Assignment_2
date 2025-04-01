% RLC Circuit Simulation - Main Script

% Load parameters from file or set defaults
params = load_parameters('circuit_params.txt');

% Time span for simulation
tspan = [0 params.simTime];

% Initial conditions [q(0), dq/dt(0)]
initial_conditions = [params.initialCharge; params.initialCurrent];

% Solve the ODE system
[t, y] = ode45(@(t,y) rlc_equations(t,y,params), tspan, initial_conditions);

% Analyze the results
[energy, power, metrics] = analyze_results(t, y, params);

% Display key metrics
disp('RLC Circuit Analysis Results:');
disp(['Response type: ' metrics.response_type]);
disp(['Damping coefficient: ' num2str(metrics.damping_coefficient)]);
disp(['Natural frequency: ' num2str(metrics.natural_frequency_hz) ' Hz']);
if metrics.resonant_frequency > 0
    disp(['Resonant frequency: ' num2str(metrics.resonant_frequency_hz) ' Hz']);
end

% Create visualizations
plot_results(t, y, energy, power);

% Optional: Parameter tuning demonstration
disp('Performing parameter tuning example...');

% Example 1: Find parameters for critical damping
target_response.type = 'critical_damping';
target_response.inductance = params.inductance;
target_response.capacitance = params.capacitance;
disp('Parameters for critical damping:');
optimal_params = tune_parameters(target_response);

% Save results to file
save_results('rlc_output.dat', t, y, energy, power);


% Add circuit diagram
plot_circuit_diagram(params);

% Analyze frequency response
disp('Analyzing frequency response...');
% Set frequency range from 1/10 of resonant to 10x resonant frequency
resonant_f = 1/(2*pi*sqrt(params.inductance*params.capacitance));
freq_range = [resonant_f/10, resonant_f*10];
analyze_frequency_response(params, freq_range);

% Run parameter sweep on resistance (add this if you have time)
% disp('Performing parameter sweep on resistance...');
% R_values = logspace(0, 2, 5);  % 1, 3.16, 10, 31.6, 100 ohms
% parameter_sweep(params, 'resistance', R_values);

disp('Simulation completed successfully.');