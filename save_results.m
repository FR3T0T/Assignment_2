function save_results(filename, t, y, energy, power)
    % Save simulation results to a file
    
    % Create a table for data
    T = table(t, y(:,1), y(:,2), energy.capacitor, energy.inductor, ...
              energy.total, power.dissipated, ...
              'VariableNames', {'Time', 'Charge', 'Current', ...
                                'CapacitorEnergy', 'InductorEnergy', ...
                                'TotalEnergy', 'DissipatedPower'});
    
    % Check file extension
    [~, ~, ext] = fileparts(filename);
    
    % Write data in appropriate format
    if strcmp(ext, '.dat') || strcmp(ext, '.txt')
        % Write as plain text
        writetable(T, filename, 'Delimiter', '\t');
    elseif strcmp(ext, '.csv')
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