function V = input_voltage(t, params)
    % Ensure t is a scalar
    t = t(1);  % Just take the first element if it's a vector
    
    % Choose different voltage functions based on params.inputType
    switch params.inputType
        case 'step'
            V = params.amplitude * (t >= params.stepTime);
        case 'sine'
            if isfield(params, 'frequency')
                V = params.amplitude * sin(2*pi*params.frequency*t);
            else
                error('Frequency parameter is missing for sine input type');
            end
        case 'pulse'
            V = params.amplitude * (mod(t, params.period) < params.pulseWidth);
        otherwise
            V = 0;
    end
end