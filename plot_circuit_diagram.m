function plot_circuit_diagram(params)
    % Create a simple circuit diagram using MATLAB's plotting capabilities
    figure('Name', 'RLC Circuit Diagram', 'Position', [100, 100, 800, 300]);
    
    % Set up axes
    axis([0 100 0 40]);
    axis off;
    hold on;
    
    % Draw components
    % Voltage source
    rectangle('Position', [10, 15, 10, 10], 'Curvature', [1, 1]);
    text(15, 20, 'V', 'HorizontalAlignment', 'center');
    
    % Resistor
    line([30, 40], [20, 20], 'LineWidth', 2);
    rectangle('Position', [40, 18, 10, 4]);
    text(45, 15, ['R = ' num2str(params.resistance) ' Ω'], 'HorizontalAlignment', 'center');
    
    % Inductor
    line([60, 65], [20, 20], 'LineWidth', 2);
    coil_x = 65:0.5:75;
    coil_y = 20 + 2*sin(linspace(0, 4*pi, length(coil_x)));
    plot(coil_x, coil_y, 'LineWidth', 2);
    line([75, 80], [20, 20], 'LineWidth', 2);
    text(70, 15, ['L = ' num2str(params.inductance) ' H'], 'HorizontalAlignment', 'center');
    
    % Capacitor
    line([80, 85], [20, 20], 'LineWidth', 2);
    line([85, 85], [16, 24], 'LineWidth', 2);
    line([87, 87], [16, 24], 'LineWidth', 2);
    line([87, 90], [20, 20], 'LineWidth', 2);
    text(86, 15, ['C = ' num2str(params.capacitance) ' F'], 'HorizontalAlignment', 'center');
    
    % Complete the circuit
    line([90, 95], [20, 20], 'LineWidth', 2);
    line([95, 95], [20, 30], 'LineWidth', 2);
    line([95, 10], [30, 30], 'LineWidth', 2);
    line([10, 10], [30, 25], 'LineWidth', 2);
    line([10, 10], [15, 10], 'LineWidth', 2);
    line([10, 95], [10, 10], 'LineWidth', 2);
    line([95, 95], [10, 20], 'LineWidth', 2);
    
    title('Series RLC Circuit');
end