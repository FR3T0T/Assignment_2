function dydt = rlc_equations(t, y, params)
    % Extract state variables
    q = y(1);     % Charge
    dqdt = y(2);  % Current
    
    % Extract parameters
    R = params.resistance;
    L = params.inductance;
    C = params.capacitance;
    
    % Apply input voltage (can be time-varying)
    V = input_voltage(t, params);
    
    % Define the system of ODEs
    dydt = zeros(2,1);
    dydt(1) = dqdt;
    dydt(2) = (V - R*dqdt - (1/C)*q)/L;
end