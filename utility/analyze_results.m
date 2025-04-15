function [energy, power, metrics] = analyze_results(t, y, params)
    % Extract parameters
    L = params.inductance;
    C = params.capacitance;
    R = params.resistance;
    
    % Calculate derived quantities
    charge = y(:,1);
    current = y(:,2);
    
    % Calculate voltage across components
    voltage.resistor = R * current;
    voltage.inductor = L * gradient(current, t);
    voltage.capacitor = charge / C;
    
    % Energy calculations
    energy.capacitor = (1/(2*C)) * charge.^2;
    energy.inductor = (L/2) * current.^2;
    energy.total = energy.capacitor + energy.inductor;
    
    % Power calculations
    power.dissipated = R * current.^2;
    power.capacitor = voltage.capacitor .* current;
    power.inductor = voltage.inductor .* current;
    
    % Circuit performance metrics
    % Damping coefficient
    zeta = R/(2*sqrt(L/C));
    
    % Natural frequency (rad/s)
    omega_n = 1/sqrt(L*C);
    
    % Resonant frequency (rad/s) - only if underdamped
    if zeta < 1
        omega_d = omega_n * sqrt(1 - zeta^2);
    else
        omega_d = 0; % No oscillation for critically damped or overdamped
    end
    
    % Store metrics in a structure
    metrics.damping_coefficient = zeta;
    metrics.natural_frequency = omega_n;
    metrics.natural_frequency_hz = omega_n/(2*pi);
    metrics.resonant_frequency = omega_d;
    metrics.resonant_frequency_hz = omega_d/(2*pi);
    
    % Classify the system response
    if abs(zeta - 1) < 1e-6
        metrics.response_type = 'Critically Damped';
    elseif zeta > 1
        metrics.response_type = 'Overdamped';
    elseif zeta < 1
        metrics.response_type = 'Underdamped';
    end
end