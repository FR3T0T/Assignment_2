%% RLC Circuit Simulation - Damping Comparison Analysis
% This script compares underdamped, critically damped, and overdamped responses

% Load parameter sets for three damping conditions
disp('Loading parameter sets for damping comparison...');

% Load from parameter files
params_underdamped = load_parameters('parameters/underdamped_params.txt');
params_critical = load_parameters('parameters/critical_params.txt');
params_overdamped = load_parameters('parameters/overdamped_params.txt');

% Calculate damping coefficients
zeta_under = params_underdamped.resistance/(2*sqrt(params_underdamped.inductance/params_underdamped.capacitance));
disp(['Underdamped: ζ = ' num2str(zeta_under)]);

zeta_critical = params_critical.resistance/(2*sqrt(params_critical.inductance/params_critical.capacitance));
disp(['Critical: ζ = ' num2str(zeta_critical)]);

zeta_over = params_overdamped.resistance/(2*sqrt(params_overdamped.inductance/params_overdamped.capacitance));
disp(['Overdamped: ζ = ' num2str(zeta_over)]);

% Run simulations for each case
disp('Running simulations for different damping conditions...');

% Time span - extended for lower frequency
tspan = [0 2];

% Initial conditions for all simulations
initial_conditions_under = [params_underdamped.initialCharge; params_underdamped.initialCurrent];
initial_conditions_crit = [params_critical.initialCharge; params_critical.initialCurrent];
initial_conditions_over = [params_overdamped.initialCharge; params_overdamped.initialCurrent];

% Underdamped simulation
[t_under, y_under] = ode45(@(t,y) rlc_equations(t,y,params_underdamped), tspan, initial_conditions_under);
[energy_under, power_under, metrics_under] = analyze_results(t_under, y_under, params_underdamped);

% Critically damped simulation
[t_crit, y_crit] = ode45(@(t,y) rlc_equations(t,y,params_critical), tspan, initial_conditions_crit);
[energy_crit, power_crit, metrics_crit] = analyze_results(t_crit, y_crit, params_critical);

% Overdamped simulation
[t_over, y_over] = ode45(@(t,y) rlc_equations(t,y,params_overdamped), tspan, initial_conditions_over);
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

% Save the figure
saveas(gcf, 'output/damping_comparison.fig');
saveas(gcf, 'output/damping_comparison.png');