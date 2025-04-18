function params = load_parameters(filename)
    % Read parameters from file or use defaults if file doesn't exist
    if exist(filename, 'file')
        % Open the file
        fileID = fopen(filename, 'r');
        
        % Initialize parameters structure with defaults
        params = initialize_default_params();
        
        % Read file line by line
        while ~feof(fileID)
            line = fgetl(fileID);
            if ischar(line) && ~isempty(line) && line(1) ~= '%'  % Skip comments and empty lines
                % Split line by '=' to get parameter name and value
                parts = strsplit(line, '=');
                if length(parts) == 2
                    paramName = strtrim(parts{1});
                    valuePart = strtrim(parts{2});
                    
                    % Remove inline comments (both % and #)
                    percentIdx = strfind(valuePart, '%');
                    hashIdx = strfind(valuePart, '#');
                    
                    % Find the first comment character, if any
                    commentIdx = [];
                    if ~isempty(percentIdx)
                        commentIdx = [commentIdx, percentIdx(1)];
                    end
                    if ~isempty(hashIdx)
                        commentIdx = [commentIdx, hashIdx(1)];
                    end
                    
                    if ~isempty(commentIdx)
                        valuePart = strtrim(valuePart(1:min(commentIdx)-1));
                    end
                    
                    % Convert to number if possible
                    paramValue = str2double(valuePart);
                    
                    % Assign to params structure
                    if ~isnan(paramValue)
                        params.(paramName) = paramValue;
                    else
                        % String parameter
                        params.(paramName) = valuePart;
                    end
                end
            end
        end
        
        % Close the file
        fclose(fileID);
    else
        % Use default parameters
        params = initialize_default_params();
        
        % Inform user that defaults are being used
        warning('Parameter file %s not found. Using default parameters.', filename);
    end
end

function params = initialize_default_params()
    % Set default parameters
    params.resistance = 10;      % Ohms
    params.inductance = 0.1;     % Henry
    params.capacitance = 1e-3;   % Farad
    
    % Simulation parameters
    params.simTime = 1;          % Seconds
    params.initialCharge = 0;    % Coulombs
    params.initialCurrent = 0;   % Amperes
    
    % Input voltage parameters
    params.inputType = 'step';   % 'step', 'sine', or 'pulse'
    params.amplitude = 10;       % Volts
    params.stepTime = 0;         % Seconds (for step input)
    params.frequency = 50;       % Hz (for sine input)
    params.period = 0.02;        % Seconds (for pulse input)
    params.pulseWidth = 0.01;    % Seconds (for pulse input)
end