function analyze_frequency_response(params, freq_range)
    % Calculate and plot impedance vs. frequency
    frequencies = logspace(log10(freq_range(1)), log10(freq_range(2)), 1000);
    impedance = zeros(size(frequencies));
    phase = zeros(size(frequencies));
    
    for i = 1:length(frequencies)
        f = frequencies(i);
        omega = 2*pi*f;
        
        % Calculate complex impedance
        Z_R = params.resistance;
        Z_L = 1j * omega * params.inductance;
        Z_C = 1 / (1j * omega * params.capacitance);
        
        Z = Z_R + Z_L + Z_C;
        impedance(i) = abs(Z);
        phase(i) = angle(Z) * 180/pi;
    end
    
    % Plot results
    figure('Name', 'Frequency Response');
    subplot(2,1,1);
    semilogx(frequencies, impedance, 'LineWidth', 1.5);
    grid on;
    xlabel('Frequency (Hz)');
    ylabel('Impedance (Ohms)');
    title('Impedance vs. Frequency');
    
    subplot(2,1,2);
    semilogx(frequencies, phase, 'LineWidth', 1.5);
    grid on;
    xlabel('Frequency (Hz)');
    ylabel('Phase (degrees)');
    title('Phase vs. Frequency');
    
    % Mark resonant frequency
    resonant_f = 1/(2*pi*sqrt(params.inductance*params.capacitance));
    
    subplot(2,1,1);
    hold on;
    plot([resonant_f, resonant_f], ylim, 'r--');
    text(resonant_f*1.1, max(impedance)*0.8, ['f_0 = ' num2str(resonant_f,'%.2f') ' Hz']);
    
    % Calculate and display quality factor
    Q = (1/params.resistance)*sqrt(params.inductance/params.capacitance);
    bandwidth = resonant_f/Q;
    
    annotation('textbox', [0.15, 0.02, 0.3, 0.05], 'String', ...
        ['Quality Factor (Q): ' num2str(Q,'%.2f') ', Bandwidth: ' num2str(bandwidth,'%.2f') ' Hz'], ...
        'EdgeColor', 'none');
end