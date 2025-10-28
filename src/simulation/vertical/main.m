clc; clear;

addpath(fullfile("cache"))
addpath(fullfile("model"))
addpath(fullfile("include"))
addpath(fullfile("config"))
addpath(fullfile("dictionary"))

Simulink.fileGenControl('set', ...
    'CacheFolder', 'cache', ...
    'CodeGenFolder', 'cache');

simConfig = struct( ...
    'model', 'vertical_dynamics', ...
    'openSystem', true);

if simConfig.openSystem, open_system(simConfig.model); end


% vehicleData = read_json(simConfig.vehicleConfigFile);
% assign_vehicle_params(simConfig.model, vehicleData);
% set_springDeflection_bus();