function V = input_voltage(t, params)
    % Choose different voltage functions based on params.inputType
    switch params.inputType
        case 'step'
            V = params.amplitude * (t >= params.stepTime);
        case 'sine'
            V = params.amplitude * sin(2*pi*params.frequency*t);
        case 'pulse'
            V = params.amplitude * (mod(t, params.period) < params.pulseWidth);
        otherwise
            V = 0;
    end
end