function plot_circuit_diagram(params)
    % Create a professional circuit diagram for RLC circuit
    figure('Name', 'RLC Circuit Diagram', 'Position', [100, 100, 900, 400]);
    
    % Set up axes with better proportions
    axis([0 100 0 50]);
    axis off;
    hold on;
    
    % Use better colors
    wire_color = [0.2 0.2 0.2];
    
    % Draw background grid (subtle)
    for i = 5:5:95
        plot([i i], [5 45], 'Color', [0.9 0.9 0.9], 'LineWidth', 0.5);
    end
    for i = 5:5:45
        plot([5 95], [i i], 'Color', [0.9 0.9 0.9], 'LineWidth', 0.5);
    end
    
    % Draw circuit frame
    rectangle('Position', [5, 5, 90, 40], 'EdgeColor', [0.7 0.7 0.7], 'LineWidth', 0.5, 'LineStyle', ':');
    
    % Draw main circuit wire
    line([10, 30], [25, 25], 'Color', wire_color, 'LineWidth', 2.5);
    line([50, 60], [25, 25], 'Color', wire_color, 'LineWidth', 2.5);
    line([80, 95], [25, 25], 'Color', wire_color, 'LineWidth', 2.5);
    line([95, 95], [25, 40], 'Color', wire_color, 'LineWidth', 2.5);
    line([95, 10], [40, 40], 'Color', wire_color, 'LineWidth', 2.5);
    line([10, 10], [40, 35], 'Color', wire_color, 'LineWidth', 2.5);
    line([10, 10], [15, 10], 'Color', wire_color, 'LineWidth', 2.5);
    line([10, 95], [10, 10], 'Color', wire_color, 'LineWidth', 2.5);
    line([95, 95], [10, 25], 'Color', wire_color, 'LineWidth', 2.5);
    
    % Draw Voltage source (improved circle with +/- terminals)
    rectangle('Position', [5, 15, 10, 20], 'Curvature', [1, 1], 'FaceColor', [1 1 0.8], 'EdgeColor', [0.6 0.6 0.6], 'LineWidth', 1.5);
    line([10, 10], [23, 27], 'Color', 'k', 'LineWidth', 1.5);  % "-" terminal
    line([8, 12], [31, 31], 'Color', 'k', 'LineWidth', 1.5);   % "+" horizontal
    line([10, 10], [29, 33], 'Color', 'k', 'LineWidth', 1.5);   % "+" vertical
    text(10, 20, 'V', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    
    % Current direction arrow
    annotation('arrow', [0.3 0.35], [0.5 0.5], 'Color', 'r', 'LineWidth', 1.5);
    text(32, 30, 'I', 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 12);
    
    % Resistor (zigzag style)
    x_start = 30; x_end = 50; y_mid = 25; height = 4;
    px = linspace(x_start, x_end, 10);
    py = [y_mid, y_mid+height, y_mid-height, y_mid+height, y_mid-height, y_mid+height, y_mid-height, y_mid+height, y_mid-height, y_mid];
    plot(px, py, 'k-', 'LineWidth', 2);
    text(40, 18, ['R = ', num2str(params.resistance), ' \Omega'], 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    
    % Inductor (improved coil)
    x_start = 60; x_end = 80; y_mid = 25; coil_height = 5; turns = 8;
    t = linspace(0, turns*pi, 100);
    px = linspace(x_start, x_end, 100);
    py = y_mid + coil_height*sin(t);
    plot(px, py, 'Color', [0.6 0.3 0], 'LineWidth', 2.5);
    text(70, 18, ['L = ', num2str(params.inductance), ' H'], 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    
    % Capacitor (improved with curved plates)
    x_mid = 90; y_mid = 25; plate_width = 1.5; plate_height = 8; gap = 1;
    % Left plate
    rectangle('Position', [x_mid-gap/2-plate_width, y_mid-plate_height/2, plate_width, plate_height], ...
              'FaceColor', [0.8 0.8 1], 'EdgeColor', 'k', 'LineWidth', 1.5, 'Curvature', [0.1, 0.1]);
    % Right plate
    rectangle('Position', [x_mid+gap/2, y_mid-plate_height/2, plate_width, plate_height], ...
              'FaceColor', [0.8 0.8 1], 'EdgeColor', 'k', 'LineWidth', 1.5, 'Curvature', [0.1, 0.1]);
    text(90, 18, ['C = ', num2str(params.capacitance), ' F'], 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    
    % Circuit title and annotations
    title('Series RLC Circuit', 'FontSize', 16, 'FontWeight', 'bold');
    
    % Add simulation parameters box
    rectangle('Position', [60, 42, 35, 6], 'FaceColor', [0.95 0.95 1], 'EdgeColor', [0.7 0.7 0.8]);
    text(77.5, 45, 'Circuit Parameters', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
    
    % Add damping information
    zeta = params.resistance/(2*sqrt(params.inductance/params.capacitance));
    if abs(zeta - 1) < 1e-6
        damping_text = 'Critically Damped';
    elseif zeta > 1
        damping_text = 'Overdamped';
    else
        damping_text = 'Underdamped';
    end
    text(15, 45, ['Damping: ', damping_text], 'FontWeight', 'bold');
    
    % Add resonant frequency
    f0 = 1/(2*pi*sqrt(params.inductance*params.capacitance));
    text(40, 45, ['f₀ = ', num2str(f0, '%.2f'), ' Hz'], 'FontWeight', 'bold');
end