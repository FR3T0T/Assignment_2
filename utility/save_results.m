function save_results(filename, t, y, energy, power)
    % Save simulation results to a file
    %
    % Inputs:
    %   filename - Path and name of the output file (with extension)
    %   t - Time vector from simulation
    %   y - Solution matrix from ODE45 (typically columns are charge and current)
    %   energy - Structure containing energy data (capacitor, inductor, total)
    %   power - Structure containing power data (dissipated, capacitor, inductor)
    %
    % File formats supported:
    %   .dat, .txt - Tab-delimited text file
    %   .csv - Comma-separated values file
    %   others - MATLAB .mat file (binary)
    
    % Handle case where energy or power might be empty
    if isempty(energy) || ~isstruct(energy)
        % Create empty energy structure if not provided
        energy.capacitor = zeros(size(t));
        energy.inductor = zeros(size(t));
        energy.total = zeros(size(t));
    end
    
    if isempty(power) || ~isstruct(power)
        % Create empty power structure if not provided
        power.dissipated = zeros(size(t));
    end
    
    % Ensure y has two columns (charge and current)
    if size(y, 2) < 2
        error('Solution matrix y must have at least 2 columns (charge and current)');
    end
    
    % Create a table for data
    T = table(t, y(:,1), y(:,2), energy.capacitor, energy.inductor, ...
              energy.total, power.dissipated, ...
              'VariableNames', {'Time', 'Charge', 'Current', ...
                                'CapacitorEnergy', 'InductorEnergy', ...
                                'TotalEnergy', 'DissipatedPower'});
    
    % Check file extension
    [filepath, name, ext] = fileparts(filename);
    
    % Ensure the directory exists
    if ~isempty(filepath) && ~exist(filepath, 'dir')
        mkdir(filepath);
    end
    
    % Write data in appropriate format
    if strcmpi(ext, '.dat') || strcmpi(ext, '.txt')
        % Write as plain text (tab-delimited)
        writetable(T, filename, 'Delimiter', '\t');
    elseif strcmpi(ext, '.csv')
        % Write as CSV
        writetable(T, filename);
    else
        % Default to MAT file
        data.time = t;
        data.charge = y(:,1);
        data.current = y(:,2);
        data.energy = energy;
        data.power = power;
        save(filename, '-struct', 'data');
    end
    
    fprintf('Results saved to %s\n', filename);
end