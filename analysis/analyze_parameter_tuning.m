%% RLC Circuit Simulation - Parameter Tuning Example
% This script demonstrates how to tune circuit parameters for specific responses

disp('Performing parameter tuning example...');

% Example 1: Find parameters for critical damping
disp('Example 1: Finding parameters for critical damping');
target_response.type = 'critical_damping';
target_response.inductance = 0.1;  % Fix inductance to 0.1 H
target_response.capacitance = 0.001; % Fix capacitance to 0.001 F
disp('Parameters for critical damping:');
critical_params = tune_parameters(target_response);

% Example 2: Find parameters for a specific resonant frequency
disp(' ');
disp('Example 2: Finding parameters for a specific resonant frequency');
target_response.type = 'resonant_frequency';
target_response.frequency = 50; % Target 50 Hz
target_response.inductance = 0.1; % Fix inductance
target_response.damping_ratio = 0.2; % Slightly underdamped
disp('Parameters for 50 Hz resonant frequency:');
resonant_params = tune_parameters(target_response);

% Verify the results by simulating both tuned circuits
% For critical damping
params_crit = struct('resistance', critical_params.resistance, ...
                     'inductance', critical_params.inductance, ...
                     'capacitance', critical_params.capacitance, ...
                     'initialCharge', 0, ...
                     'initialCurrent', 0, ...
                     'inputType', 'step', ...
                     'amplitude', 10, ...
                     'stepTime', 0);
                 
% For resonant frequency
params_res = struct('resistance', resonant_params.resistance, ...
                    'inductance', resonant_params.inductance, ...
                    'capacitance', resonant_params.capacitance, ...
                    'initialCharge', 0, ...
                    'initialCurrent', 0, ...
                    'inputType', 'sine', ...
                    'amplitude', 5, ...
                    'frequency', target_response.frequency);
                
% Simulate both circuits
tspan = [0 0.5];
initial_conditions = [0; 0];

% Critical damping simulation
[t_crit, y_crit] = ode45(@(t,y) rlc_equations(t,y,params_crit), tspan, initial_conditions);
[energy_crit, power_crit, metrics_crit] = analyze_results(t_crit, y_crit, params_crit);

% Resonant frequency simulation
[t_res, y_res] = ode45(@(t,y) rlc_equations(t,y,params_res), tspan, initial_conditions);
[energy_res, power_res, metrics_res] = analyze_results(t_res, y_res, params_res);

% Create visualization of the results
figure('Name', 'Parameter Tuning Results', 'Position', [400, 400, 900, 400]);

% Plot critically damped response
subplot(1,2,1);
plot(t_crit, y_crit(:,2), 'b-', 'LineWidth', 2);
grid on;
xlabel('Time (s)', 'FontSize', 11);
ylabel('Current (A)', 'FontSize', 11);
title(['Critically Damped Response (ζ = ' num2str(metrics_crit.damping_coefficient, '%.2f') ')'], 'FontSize', 12);
text(0.1, max(y_crit(:,2))*0.8, ['R = ' num2str(params_crit.resistance) ' Ω'], 'FontSize', 10);
text(0.1, max(y_crit(:,2))*0.7, ['L = ' num2str(params_crit.inductance) ' H'], 'FontSize', 10);
text(0.1, max(y_crit(:,2))*0.6, ['C = ' num2str(params_crit.capacitance) ' F'], 'FontSize', 10);

% Plot resonant frequency response
subplot(1,2,2);
plot(t_res, y_res(:,2), 'r-', 'LineWidth', 2);
grid on;
xlabel('Time (s)', 'FontSize', 11);
ylabel('Current (A)', 'FontSize', 11);
title(['Resonant Response at ' num2str(target_response.frequency) ' Hz'], 'FontSize', 12);
text(0.1, max(y_res(:,2))*0.8, ['R = ' num2str(params_res.resistance) ' Ω'], 'FontSize', 10);
text(0.1, max(y_res(:,2))*0.7, ['L = ' num2str(params_res.inductance) ' H'], 'FontSize', 10);
text(0.1, max(y_res(:,2))*0.6, ['C = ' num2str(params_res.capacitance) ' F'], 'FontSize', 10);
text(0.1, max(y_res(:,2))*0.5, ['f₀ = ' num2str(metrics_res.natural_frequency_hz) ' Hz'], 'FontSize', 10);

% Add title for the entire figure
sgtitle('Parameter Tuning Results', 'FontSize', 14);

% Save the figure
saveas(gcf, 'output/parameter_tuning.fig');
saveas(gcf, 'output/parameter_tuning.png');