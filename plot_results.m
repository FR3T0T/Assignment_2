function plot_results(t, y, energy, power)
    % Create visualizations of RLC circuit simulation results
    
    % Create a figure with 4 subplots
    figure('Name', 'RLC Circuit Simulation Results', 'Position', [100, 100, 1000, 800]);
    
    % Plot 1: Charge vs Time
    subplot(2, 2, 1);
    plot(t, y(:,1), 'b-', 'LineWidth', 1.5);
    grid on;
    title('Charge vs Time');
    xlabel('Time (s)');
    ylabel('Charge (C)');
    
    % Plot 2: Current vs Time
    subplot(2, 2, 2);
    plot(t, y(:,2), 'r-', 'LineWidth', 1.5);
    grid on;
    title('Current vs Time');
    xlabel('Time (s)');
    ylabel('Current (A)');
    
    % Plot 3: Energy Distribution
    subplot(2, 2, 3);
    plot(t, energy.capacitor, 'g-', t, energy.inductor, 'm-', t, energy.total, 'k--', 'LineWidth', 1.5);
    grid on;
    title('Energy Distribution');
    xlabel('Time (s)');
    ylabel('Energy (J)');
    legend('Capacitor', 'Inductor', 'Total', 'Location', 'best');
    
    % Plot 4: Power Dissipation
    subplot(2, 2, 4);
    plot(t, power.dissipated, 'c-', 'LineWidth', 1.5);
    grid on;
    title('Power Dissipation');
    xlabel('Time (s)');
    ylabel('Power (W)');
    
    % Add a title for the entire figure
    sgtitle('RLC Circuit Analysis');
end