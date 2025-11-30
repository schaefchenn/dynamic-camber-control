clc; clear;

addpath(fullfile("cache"))
addpath(fullfile("inputs"))
addpath(fullfile("model"))
addpath(fullfile("include"))
addpath(fullfile("config"))
addpath(fullfile("dictionary"))

simin = load('deccel_from80.mat');
simin = simin.data;

Simulink.fileGenControl('set', ...
    'CacheFolder', 'cache', ...
    'CodeGenFolder', 'cache');

simConfig = struct( ...
    'model', 'camber_control', ...
    'openSystem', true);

if simConfig.openSystem, open_system(simConfig.model); end