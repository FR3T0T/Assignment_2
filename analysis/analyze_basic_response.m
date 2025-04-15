%% RLC Circuit Simulation - Basic Response Analysis
% This script performs a basic simulation of the RLC circuit and analyzes the results

%% Load and analyze parameters for the primary simulation
params = load_parameters('parameters/circuit_params.txt');

% Time span for simulation
tspan = [0 2]; % Extended to 2 seconds for lower frequency

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

% Saves it as a data file
save_results('output/rlc_output.dat', t, y, energy, power);