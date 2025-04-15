%% RLC Circuit Simulation - Energy Distribution Analysis
% This script analyzes the energy distribution in an RLC circuit with initial charge

disp('Simulating energy distribution with initial charge...');

% Configure parameters for underdamped circuit with initial charge
energy_params = load_parameters('parameters/underdamped_params.txt');
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
saveas(gcf, 'output/energy_distribution.fig');
saveas(gcf, 'output/energy_distribution.png');