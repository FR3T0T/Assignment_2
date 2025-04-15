%% RLC Circuit Simulation - Frequency Response Analysis
% This script analyzes the frequency response of the RLC circuit under different damping conditions

% Load parameter sets
params_underdamped = load_parameters('parameters/underdamped_params.txt');
params_critical = load_parameters('parameters/critical_params.txt');
params_overdamped = load_parameters('parameters/overdamped_params.txt');

% Calculate damping coefficients for labels
zeta_under = params_underdamped.resistance/(2*sqrt(params_underdamped.inductance/params_underdamped.capacitance));
zeta_critical = params_critical.resistance/(2*sqrt(params_critical.inductance/params_critical.capacitance));
zeta_over = params_overdamped.resistance/(2*sqrt(params_overdamped.inductance/params_overdamped.capacitance));

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

% Save the figure
saveas(gcf, 'output/frequency_response.fig');
saveas(gcf, 'output/frequency_response.png');