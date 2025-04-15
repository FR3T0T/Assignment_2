%% RLC Circuit Simulation - Main Script

%% Part 1: Load and analyze parameters for the primary simulation
params = load_parameters('circuit_params.txt');

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

%% Part 2: Compare underdamped, critically damped, and overdamped responses

% Create parameter sets for three damping conditions
disp('Creating parameter sets for damping comparison...');

% Underdamped parameters (ζ = 0.1)
params_underdamped = params;
params_underdamped.resistance = 2;       % Ohms
params_underdamped.inductance = 1;       % Henry
params_underdamped.capacitance = 0.01;   % Farad
params_underdamped.inputType = 'step';
params_underdamped.amplitude = 10;       % Volts

% Calculate damping coefficient
zeta_under = params_underdamped.resistance/(2*sqrt(params_underdamped.inductance/params_underdamped.capacitance));
disp(['Underdamped: ζ = ' num2str(zeta_under)]);

% Critically damped parameters (ζ = 1)
params_critical = params;
params_critical.resistance = 20;         % Ohms
params_critical.inductance = 1;          % Henry
params_critical.capacitance = 0.01;      % Farad
params_critical.inputType = 'step';
params_critical.amplitude = 10;          % Volts

% Calculate damping coefficient
zeta_critical = params_critical.resistance/(2*sqrt(params_critical.inductance/params_critical.capacitance));
disp(['Critical: ζ = ' num2str(zeta_critical)]);

% Overdamped parameters (ζ = 2)
params_overdamped = params;
params_overdamped.resistance = 40;       % Ohms
params_overdamped.inductance = 1;        % Henry
params_overdamped.capacitance = 0.01;    % Farad
params_overdamped.inputType = 'step';
params_overdamped.amplitude = 10;        % Volts

% Calculate damping coefficient
zeta_over = params_overdamped.resistance/(2*sqrt(params_overdamped.inductance/params_overdamped.capacitance));
disp(['Overdamped: ζ = ' num2str(zeta_over)]);

% Run simulations for each case
disp('Running simulations for different damping conditions...');

% Time span - extended for lower frequency
tspan = [0 2];

% Underdamped simulation
[t_under, y_under] = ode45(@(t,y) rlc_equations(t,y,params_underdamped), tspan, initial_conditions);
[energy_under, power_under, metrics_under] = analyze_results(t_under, y_under, params_underdamped);

% Critically damped simulation
[t_crit, y_crit] = ode45(@(t,y) rlc_equations(t,y,params_critical), tspan, initial_conditions);
[energy_crit, power_crit, metrics_crit] = analyze_results(t_crit, y_crit, params_critical);

% Overdamped simulation
[t_over, y_over] = ode45(@(t,y) rlc_equations(t,y,params_overdamped), tspan, initial_conditions);
[energy_over, power_over, metrics_over] = analyze_results(t_over, y_over, params_overdamped);

% Create journal-style figure for time domain response (Figure 1)
figure('Name', 'Journal Figure: RLC Damping Comparison', 'Position', [150, 150, 800, 500]);
plot(t_under, y_under(:,2), 'b-', t_crit, y_crit(:,2), 'r--', t_over, y_over(:,2), 'g-.', 'LineWidth', 2);
grid on;
xlabel('Time (s)', 'FontSize', 12);
ylabel('Current (A)', 'FontSize', 12);
title('Transient Responses for Different Damping Conditions', 'FontSize', 14);
legend(['Underdamped (ζ = ' num2str(zeta_under, '%.2f') ')'], ...
       ['Critically Damped (ζ = ' num2str(zeta_critical, '%.2f') ')'], ...
       ['Overdamped (ζ = ' num2str(zeta_over, '%.2f') ')'], ...
       'Location', 'best', 'FontSize', 10);
set(gca, 'FontSize', 11);
box on;

% Save the journal figure
saveas(gcf, 'rlc_journal_figure.png');
saveas(gcf, 'rlc_journal_figure.fig');

%% Part 3: Frequency Response Analysis (Figure 2)

% Create frequency response comparison figure for journal
figure('Name', 'Frequency Response Comparison', 'Position', [200, 200, 800, 600]);

% Set frequency range
freq_range = [0.1, 100];  % Hz
frequencies = logspace(log10(freq_range(1)), log10(freq_range(2)), 1000);

% Calculate impedance for each case
subplot(2,1,1);
hold on;
grid on;

% Process each parameter set
param_sets = {params_underdamped, params_critical, params_overdamped};
labels = {['Underdamped (ζ = ' num2str(zeta_under, '%.2f') ')'], ...
          ['Critically Damped (ζ = ' num2str(zeta_critical, '%.2f') ')'], ...
          ['Overdamped (ζ = ' num2str(zeta_over, '%.2f') ')']};
styles = {'b-', 'r--', 'g-.'};

for i = 1:3
    p = param_sets{i};
    impedance = zeros(size(frequencies));
    phase = zeros(size(frequencies));
    
    for j = 1:length(frequencies)
        f = frequencies(j);
        omega = 2*pi*f;
        
        % Calculate complex impedance
        Z_R = p.resistance;
        Z_L = 1j * omega * p.inductance;
        Z_C = 1 / (1j * omega * p.capacitance);
        
        Z = Z_R + Z_L + Z_C;
        impedance(j) = abs(Z);
        phase(j) = angle(Z) * 180/pi;
    end
    
    % Plot impedance magnitude
    subplot(2,1,1);
    semilogx(frequencies, impedance, styles{i}, 'LineWidth', 1.5);
    
    % Plot phase
    subplot(2,1,2);
    semilogx(frequencies, phase, styles{i}, 'LineWidth', 1.5);
end

% Mark resonant frequency
resonant_f = 1/(2*pi*sqrt(params_underdamped.inductance*params_underdamped.capacitance));
subplot(2,1,1);
plot([resonant_f, resonant_f], [0, 100], 'k:', 'LineWidth', 1);
text(resonant_f*1.1, 30, ['f_0 = ' num2str(resonant_f,'%.2f') ' Hz'], 'FontSize', 10);

% Calculate quality factor for underdamped case
Q = (1/params_underdamped.resistance)*sqrt(params_underdamped.inductance/params_underdamped.capacitance);
bandwidth = resonant_f/Q;
subplot(2,1,1);
text(freq_range(1)*3, 80, ['Q = ' num2str(Q,'%.1f') ', Bandwidth = ' num2str(bandwidth,'%.2f') ' Hz'], 'FontSize', 10);

% Add labels and legends
subplot(2,1,1);
xlabel('Frequency (Hz)', 'FontSize', 11);
ylabel('Impedance |Z| (Ohms)', 'FontSize', 11);
title('Impedance Magnitude vs. Frequency', 'FontSize', 12);
legend(labels, 'Location', 'best', 'FontSize', 10);
ylim([0, 100]);

subplot(2,1,2);
xlabel('Frequency (Hz)', 'FontSize', 11);
ylabel('Phase Angle (degrees)', 'FontSize', 11);
title('Phase Angle vs. Frequency', 'FontSize', 12);
grid on;
ylim([-90, 90]);

% Add title to overall figure
sgtitle('Frequency Response for Different Damping Ratios', 'FontSize', 14);

% Save frequency response figure
saveas(gcf, 'frequency_response_comparison.png');
saveas(gcf, 'frequency_response_comparison.fig');

%% Part 4: Energy Distribution with Initial Charge (Figure 3)
disp('Simulating energy distribution with initial charge...');

% Configure parameters for underdamped circuit
energy_params = params_underdamped;
energy_params.initialCharge = 10;  % 10 Coulombs initial charge
energy_params.initialCurrent = 0;  % Zero initial current
energy_params.inputType = 'step';
energy_params.amplitude = 0;       % No external voltage source, just initial conditions

% Initial conditions [q(0), dq/dt(0)]
energy_initial = [energy_params.initialCharge; energy_params.initialCurrent];

% Solve the ODE system
[t_energy, y_energy] = ode45(@(t,y) rlc_equations(t,y,energy_params), [0 5], energy_initial);

% Calculate energies
[energy_dist, power_dist, metrics_energy] = analyze_results(t_energy, y_energy, energy_params);

% Calculate initial energy
initial_energy = 0.5 * energy_params.initialCharge^2 / energy_params.capacitance;
disp(['Initial energy: ' num2str(initial_energy) ' Joules']);

% Calculate time constant
tau = 2*energy_params.inductance/energy_params.resistance;
disp(['Energy decay time constant: ' num2str(tau) ' seconds']);

% Create Figure 3 for journal
figure('Name', 'Energy Distribution', 'Position', [250, 250, 800, 500]);
plot(t_energy, energy_dist.capacitor, 'b-', ...
     t_energy, energy_dist.inductor, 'r--', ...
     t_energy, energy_dist.total, 'k-', 'LineWidth', 2);

% Add exponential decay envelope
hold on;
env = initial_energy * exp(-t_energy/tau);
plot(t_energy, env, 'g:', 'LineWidth', 1.5);

grid on;
xlabel('Time (s)', 'FontSize', 12);
ylabel('Energy (J)', 'FontSize', 12);
title('Energy Distribution in Underdamped RLC Circuit with Initial Charge', 'FontSize', 14);
legend('Capacitor Energy', 'Inductor Energy', 'Total Energy', 'Theoretical Decay Envelope', ...
       'Location', 'northeast', 'FontSize', 10);

% Calculate percentages for annotations
energy_after_tau = energy_dist.total(find(t_energy >= tau, 1));
percent_remaining = 100 * energy_after_tau / initial_energy;

% Mark time constant on plot
plot([tau, tau], [0, initial_energy], 'k:', 'LineWidth', 1.5);
text(tau+0.2, initial_energy/2, ['\tau = ' num2str(tau) 's'], 'FontSize', 10);
text(tau+0.2, initial_energy/3, [num2str(round(percent_remaining)) '% energy remains'], 'FontSize', 10);

% Add annotation about oscillatory energy exchange
text(0.5, initial_energy*0.7, 'Energy transfers between capacitor and inductor', 'FontSize', 10);
text(0.5, initial_energy*0.65, 'while gradually dissipating in the resistor', 'FontSize', 10);

% Set axis limits for better visualization
ylim([0, initial_energy*1.1]);
xlim([0, 5*tau]);

% Save the figure
saveas(gcf, 'energy_distribution.png');
saveas(gcf, 'energy_distribution.fig');

%% Part 5: Energy Distribution vs Resistance
disp('Analyzing energy distribution vs resistance...');

% Configure base parameters (underdamped circuit with step input)
base_params = params_underdamped;
base_params.initialCharge = 0;  
base_params.initialCurrent = 0;
base_params.inputType = 'step';
base_params.amplitude = 10;     % 10V step input
base_params.simTime = 0.5;      % Match the 0.5s shown in your plot

% Define resistance values to test
% These values will create the different curves shown in your image
R_values = [1, 2, 5, 15, 40];  % Try these resistance values

% Create figure
figure('Name', 'Energy Distribution vs Resistance', 'Position', [300, 300, 800, 500]);
hold on;
grid on;

% Color map for different resistance values
colors = [0, 0.4470, 0.7410;    % Blue
          0.8500, 0.3250, 0.0980; % Orange/red
          0.9290, 0.6940, 0.1250; % Yellow
          0.4940, 0.1840, 0.5560; % Purple
          0.4660, 0.6740, 0.1880]; % Green

% Time vector for simulation
tspan = [0 0.5];  % 0 to 0.5 seconds to match your image

% Simulate for each resistance value
legend_entries = cell(length(R_values), 1);
for i = 1:length(R_values)
    % Set the resistance for this simulation
    sim_params = base_params;
    sim_params.resistance = R_values(i);
    
    % Calculate damping coefficient for legend
    zeta = sim_params.resistance/(2*sqrt(sim_params.inductance/sim_params.capacitance));
    legend_entries{i} = ['R = ' num2str(R_values(i)) ' \Omega (\zeta = ' num2str(zeta, '%.2f') ')'];
    
    % Run simulation
    [t, y] = ode45(@(t,y) rlc_equations(t,y,sim_params), tspan, [0; 0]);
    
    % Calculate energy
    [energy_data, ~, ~] = analyze_results(t, y, sim_params);
    
    % Plot total energy with color from color map
    plot(t, energy_data.total, 'Color', colors(i,:), 'LineWidth', 2);
end

% Add labels and title
xlabel('Time (s)', 'FontSize', 12);
ylabel('Energy (J)', 'FontSize', 12);
title('Energy Distribution vs Resistance', 'FontSize', 14);
legend(legend_entries, 'Location', 'northeast', 'FontSize', 10);

% Save the figure
saveas(gcf, 'energy_vs_resistance.png');
saveas(gcf, 'energy_vs_resistance.fig');

%% Part 6: Parameter Sweep Analysis (Figure 4)
disp('Performing parameter sweep analysis...');

% Set the inductance and capacitance (fixed)
L = 1;      % Henry
C = 0.01;   % Farad

% Create logarithmically spaced resistance values from 1 to 100 ohms
R_sweep = logspace(0, 2, 100); % 100 points from 10^0 to 10^2

% Calculate natural frequency (constant for all R values)
omega_n = 1/sqrt(L*C); % rad/s

% Initialize arrays for calculated metrics
damping_coeff = zeros(size(R_sweep));
damped_freq = zeros(size(R_sweep));

% Calculate metrics for each resistance value
for i = 1:length(R_sweep)
    R = R_sweep(i);
    
    % Damping coefficient
    damping_coeff(i) = R/(2*sqrt(L/C));
    
    % Damped frequency (only exists for underdamped case)
    if damping_coeff(i) < 1
        damped_freq(i) = omega_n * sqrt(1 - damping_coeff(i)^2);
    else
        damped_freq(i) = 0; % No oscillation for critically damped or overdamped
    end
end

% Calculate critical damping resistance
R_critical = 2*sqrt(L/C);

% Create Figure 4 for journal
figure('Name', 'Parameter Sweep Analysis', 'Position', [350, 350, 800, 400]);

% Create a 1x3 subplot layout
subplot(1,3,1);
semilogx(R_sweep, damping_coeff, 'b-', 'LineWidth', 2);
grid on;
xlabel('Resistance (Ω)', 'FontSize', 11);
ylabel('Damping Coefficient (ζ)', 'FontSize', 11);
title('Damping Coefficient', 'FontSize', 12);

% Add horizontal line at ζ = 1 (critical damping)
hold on;
plot([1, 100], [1, 1], 'r--', 'LineWidth', 1.5);
plot([R_critical, R_critical], [0, 5], 'r--', 'LineWidth', 1.5);
ylim([0, 5]);

subplot(1,3,2);
semilogx(R_sweep, ones(size(R_sweep))*omega_n, 'g-', 'LineWidth', 2);
grid on;
xlabel('Resistance (Ω)', 'FontSize', 11);
ylabel('Natural Frequency (rad/s)', 'FontSize', 11);
title('Natural Frequency', 'FontSize', 12);
ylim([0, 15]);
text(2, 12, 'ω_n = 10 rad/s (constant)', 'FontSize', 9);

subplot(1,3,3);
semilogx(R_sweep, damped_freq, 'r-', 'LineWidth', 2);
grid on;
xlabel('Resistance (Ω)', 'FontSize', 11);
ylabel('Resonant Frequency (rad/s)', 'FontSize', 11);
title('Damped Resonant Frequency', 'FontSize', 12);
ylim([0, 15]);

% Add vertical line at critical damping
hold on;
plot([R_critical, R_critical], [0, 15], 'r--', 'LineWidth', 1.5);
text(R_critical*1.1, 5, 'ω_d = 0 at ζ = 1', 'FontSize', 9);

% Add title for the entire figure
sgtitle('Effect of Resistance on RLC Circuit Metrics (L = 1H, C = 0.01F)', 'FontSize', 14);

% Save the figure
saveas(gcf, 'parameter_sweep.png');
saveas(gcf, 'parameter_sweep.fig');

%% Part 7: Optional analyses

% Optional: Parameter tuning demonstration
disp('Performing parameter tuning example...');

% Example: Find parameters for critical damping
target_response.type = 'critical_damping';
target_response.inductance = params.inductance;
target_response.capacitance = params.capacitance;
disp('Parameters for critical damping:');
optimal_params = tune_parameters(target_response);

% Optional: Add circuit diagram for visualization
plot_circuit_diagram(params_underdamped);

disp('Simulation completed successfully.');