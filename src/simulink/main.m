clc; clear; close;
%% params
% pid parameter
kp = 10;
ki = 0;
kd = 0;

% actuator pt1 parameter
k = 0.6;
T1 = 0.01;

% ratio for actuator angle into camber angle
ic = 1;

%% house keeping
baseDir = fileparts(matlab.desktop.editor.getActiveFilename);
cd(baseDir)

addpath(baseDir);
addpath(genpath(fullfile(baseDir, "model")));
addpath(genpath(fullfile(baseDir, "cache")));
addpath(genpath(fullfile(baseDir, "configs")));
addpath(genpath(fullfile(baseDir, "include")));
addpath(genpath(fullfile(baseDir, "inputs")));

%% user selections
% vehicle selection
startDir = fullfile(baseDir, "configs");
[config_file, config_path] = uigetfile( ...
    fullfile(startDir, '*.json'), ...
    'Choose your .mat file');

if isequal(config_file, 0)
    disp('No file selected.');
    return;
end


config_meta = jsondecode(fileread(strcat(config_path, config_file)));
vehicle = jsondecode(fileread(config_meta.vehicle_parameter_file)); 
tire = read_tir(config_meta.tire_parameter_file);

startDir = fullfile(baseDir, "inputs/");
[file, path] = uigetfile( ...
    fullfile(startDir, '*.mat'), ...
    'Choose your .mat file');

if isequal(file, 0)
    disp('No file selected.');
    return;
end

simin = load(file); simin = simin.data;
clear startDir; clear file; clear path;

closeSystem = false;

Simulink.fileGenControl('set', ...
    'CacheFolder', fullfile(baseDir, "cache"));

startDir = fullfile(baseDir, "model");
[model, path] = uigetfile( ...
    fullfile(startDir, '*.slx'), ...
    'Choose your simulink model');

if isequal(extractBefore(model,'.'), 0)
    disp('No file selected.');
    return;
end

if bdIsLoaded(extractBefore(model,'.')) && closeSystem, close_system(extractBefore(model,'.')); end
load_system(extractBefore(model,'.'))
get_sim_parameter(extractBefore(model,'.'), vehicle)

mdlWks = get_param(extractBefore(model,'.'),"ModelWorkspace");
param = Simulink.Parameter;
param.Value = tire;
param.CoderInfo.StorageClass = 'Auto';
assignin(mdlWks,"tire",param);

create_vehicle_states_bus();
open_system(extractBefore(model,'.'))
