function V = input_voltage(t, params)
    % Make t a column vector if it isn't already
    t = t(:);
    
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