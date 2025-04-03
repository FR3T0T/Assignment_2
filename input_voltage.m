function V = input_voltage(t, params)
    % Handle case where t is a vector
    if numel(t) > 1
        t = t(1);
    end
    
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