clc; clear; close;

baseDir = fileparts(matlab.desktop.editor.getActiveFilename);
cd(baseDir)

addpath(baseDir);
addpath(genpath(fullfile(baseDir, "model")));
addpath(genpath(fullfile(baseDir, "cache")));
addpath(genpath(fullfile(baseDir, "configs")));
addpath(genpath(fullfile(baseDir, "include")));
addpath(genpath(fullfile(baseDir, "ref_vehicle")));

vehicleConfigFile = "bmw_5series.json";
vehicle = jsondecode(fileread(fullfile(vehicleConfigFile))); 

tir_file = "MF_205_60R15_V91";
tire = read_tir(tir_file);

startDir = fullfile(baseDir, "ref_vehicle");
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

% pid parameter
kp = 10;
ki = 0;
kd = 0;

% actuator pt1 parameter
k = 0.6;
T1 = 0.01;

% ratio for actuator angle into camber angle
ic = 1;

create_vehicle_states_bus();
open_system(extractBefore(model,'.'))
