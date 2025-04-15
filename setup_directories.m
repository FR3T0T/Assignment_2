%% Setup Directory Structure for RLC Circuit Simulation
% This script creates the necessary directory structure for the project

% Create main directories
directories = {
    'analysis',
    'core_functions',
    'parameters',
    'utility',
    'output'
};

% Create each directory if it doesn't exist
for i = 1:length(directories)
    dir_name = directories{i};
    if ~exist(dir_name, 'dir')
        mkdir(dir_name);
        disp(['Created directory: ' dir_name]);
    else
        disp(['Directory already exists: ' dir_name]);
    end
end

% Move files to appropriate directories
% Core functions
core_files = {
    'rlc_equations.m',
    'input_voltage.m',
    'load_parameters.m'
};

% Utility functions
utility_files = {
    'plot_results.m',
    'save_results.m',
    'tune_parameters.m',
    'analyze_results.m',
    'analyze_frequency_response.m'
};

% Parameter files
param_files = {
    'circuit_params.txt',
    'critical_params.txt',
    'overdamped_params.txt',
    'underdamped_params.txt'
};

% Move core files
for i = 1:length(core_files)
    src_file = core_files{i};
    if exist(src_file, 'file')
        dest_file = fullfile('core_functions', src_file);
        copyfile(src_file, dest_file);
        disp(['Moved ' src_file ' to core_functions directory']);
    else
        disp(['Warning: ' src_file ' not found']);
    end
end

% Move utility files
for i = 1:length(utility_files)
    src_file = utility_files{i};
    if exist(src_file, 'file')
        dest_file = fullfile('utility', src_file);
        copyfile(src_file, dest_file);
        disp(['Moved ' src_file ' to utility directory']);
    else
        disp(['Warning: ' src_file ' not found']);
    end
end

% Move parameter files
for i = 1:length(param_files)
    src_file = param_files{i};
    if exist(src_file, 'file')
        dest_file = fullfile('parameters', src_file);
        copyfile(src_file, dest_file);
        disp(['Moved ' src_file ' to parameters directory']);
    else
        disp(['Warning: ' src_file ' not found']);
    end
end

disp('Directory setup complete. Now run main_rlc.m to start the simulation.');