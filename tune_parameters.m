function optimal_params = tune_parameters(target_response)
    % Use fsolve to find parameters that meet target criteria
    
    switch target_response.type
        case 'critical_damping'
            % For critical damping, we need R^2 = 4L/C
            L = target_response.inductance;
            C = target_response.capacitance;
            
            % Critical damping value
            R_critical = sqrt(4 * L / C);
            
            optimal_params.resistance = R_critical;
            optimal_params.inductance = L;
            optimal_params.capacitance = C;
            
        case 'resonant_frequency'
            % Target resonant frequency: w_0 = 1/sqrt(LC)
            target_freq = target_response.frequency; % in Hz
            target_omega = 2 * pi * target_freq;  % in rad/s
            
            % If we fix L, solve for C
            L = target_response.inductance;
            C = 1 / (target_omega^2 * L);
            
            % For a specific damping ratio zeta
            if isfield(target_response, 'damping_ratio')
                zeta = target_response.damping_ratio;
                R = 2 * zeta * sqrt(L/C);
            else
                % Default to slightly underdamped
                R = 0.8 * sqrt(4 * L / C);
            end
            
            optimal_params.resistance = R;
            optimal_params.inductance = L;
            optimal_params.capacitance = C;
            
        case 'settling_time'
            % Initial guess for parameters
            x0 = [10, 0.1, 1e-3]; % [R, L, C]
            
            % Use fsolve to optimize parameters
            options = optimoptions('fsolve', 'Display', 'iter');
            x = fsolve(@(x) settling_time_objective(x, target_response), x0, options);
            
            % Extract results
            optimal_params.resistance = x(1);
            optimal_params.inductance = x(2);
            optimal_params.capacitance = x(3);
    end
    
    % Display results
    disp('Optimal Parameters:');
    disp(['  Resistance: ' num2str(optimal_params.resistance) ' Ohms']);
    disp(['  Inductance: ' num2str(optimal_params.inductance) ' H']);
    disp(['  Capacitance: ' num2str(optimal_params.capacitance) ' F']);
end

function error = settling_time_objective(x, target_response)
    % Objective function for settling time optimization
    R = x(1);
    L = x(2);
    C = x(3);
    
    % Calculate settling time based on circuit parameters
    % For second-order system, settling time ≈ 4/(zeta*omega_n)
    zeta = R/(2*sqrt(L/C));
    omega_n = 1/sqrt(L*C);
    
    settling_time = 4/(zeta*omega_n);
    
    % Error is difference between calculated and target settling time
    error = settling_time - target_response.settling_time;
end