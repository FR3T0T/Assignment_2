%% RLC Circuit Simulation - Parameter Sweep Analysis
% This script performs a parameter sweep analysis for different resistance values

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
saveas(gcf, 'output/parameter_sweep.fig');
saveas(gcf, 'output/parameter_sweep.png');