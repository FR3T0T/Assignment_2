function dydt = rlc_equations(t, y, params)
    % Extract state variables
    q = y(1);     % Charge
    dqdt = y(2);  % Current
    
    % Extract parameters
    R = params.resistance;
    L = params.inductance;
    C = params.capacitance;
    
    % Apply input voltage - ensure scalar time value
    % ODE45 can sometimes pass arrays - handle both cases
    if length(t) > 1
        t_scalar = t(1);
    else
        t_scalar = t;
    end
    
    V = input_voltage(t_scalar, params);
    
    % Define the system of ODEs
    dydt = zeros(size(y));  % Match output size to input size
    dydt(1) = dqdt;
    dydt(2) = (V - R*dqdt - (1/C)*q)/L;
end