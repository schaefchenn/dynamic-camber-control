clc; clear;

addpath(fullfile("cache\"))
addpath(fullfile("model\"))
addpath(fullfile("include\"))
addpath(fullfile("config\"))

Simulink.fileGenControl('set', ...
    'CacheFolder', 'cache', ...
    'CodeGenFolder', 'cache');

simConfig = struct( ...
    'model', 'vertical_dynamics', ...
    'vehicleConfigFile', 'config/bmw_5series_param.json', ...
    'openSystem', true);

if simConfig.openSystem, open_system(simConfig.model); end