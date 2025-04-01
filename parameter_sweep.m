function parameter_sweep(base_params, param_name, values)
    % Analyze circuit behavior across a range of parameter values
    figure('Name', ['Parameter Sweep: ' param_name], 'Position', [100, 100, 1000, 800]);
    
    % Plot setup
    subplot(2,2,1); hold on; grid on;
    title(['Current Response vs ' param_name]);
    xlabel('Time (s)');
    ylabel('Current (A)');
    
    subplot(2,2,2); hold on; grid on;
    title(['Charge Response vs ' param_name]);
    xlabel('Time (s)');
    ylabel('Charge (C)');
    
    subplot(2,2,3); hold on; grid on;
    title(['Energy Distribution vs ' param_name]);
    xlabel('Time (s)');
    ylabel('Energy (J)');
    
    subplot(2,2,4); hold on; grid on;
    title('System Metrics');
    xlabel([param_name ' value']);
    ylabel('Metric Value');
    
    % Create arrays to store metrics
    metrics_values = zeros(length(values), 4);
    
    % Run simulation for each parameter value
    for i = 1:length(values)
        % Update parameter
        params = base_params;
        params.(param_name) = values(i);
        
        % Run simulation
        tspan = [0 params.simTime];
        initial_conditions = [params.initialCharge; params.initialCurrent];
        [t, y] = ode45(@(t,y) rlc_equations(t,y,params), tspan, initial_conditions);
        
        % Analyze results
        [energy, power, metrics] = analyze_results(t, y, params);
        
        % Store metrics
        metrics_values(i, 1) = metrics.damping_coefficient;
        metrics_values(i, 2) = metrics.natural_frequency_hz;
        metrics_values(i, 3) = metrics.resonant_frequency_hz;
        
        % Plot results
        subplot(2,2,1);
        plot(t, y(:,2), 'LineWidth', 1.5);
        
        subplot(2,2,2);
        plot(t, y(:,1), 'LineWidth', 1.5);
        
        subplot(2,2,3);
        plot(t, energy.total, 'LineWidth', 1.5);
    end
    
    % Add legends
    subplot(2,2,1);
    legend(cellstr(num2str(values(:), [param_name ' = %.2f'])));
    
    % Plot metrics
    subplot(2,2,4);
    plot(values, metrics_values(:,1), 'o-', 'LineWidth', 1.5);
    hold on;
    plot(values, metrics_values(:,2), 's-', 'LineWidth', 1.5);
    if any(metrics_values(:,3))
        plot(values, metrics_values(:,3), 'd-', 'LineWidth', 1.5);
        legend('Damping Coeff.', 'Natural Freq. (Hz)', 'Resonant Freq. (Hz)');
    else
        legend('Damping Coeff.', 'Natural Freq. (Hz)');
    end
    grid on;
    
    % Save results to file
    result_file = ['sweep_' param_name '.txt'];
    T = table(values', metrics_values(:,1), metrics_values(:,2), metrics_values(:,3), ...
              'VariableNames', {param_name, 'DampingCoeff', 'NaturalFreq', 'ResonantFreq'});
    writetable(T, result_file);
    fprintf('Parameter sweep results saved to %s\n', result_file);
end