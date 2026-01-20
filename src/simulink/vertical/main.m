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

startDir = fullfile(baseDir, "ref_vehicle");
[file, path] = uigetfile( ...
    fullfile(startDir, '*.mat'), ...
    'Choose your .mat file');

if isequal(file, 0)
    disp('No file selected.');
    return;
end

simin = load(file); simin = simin.data;

model = "sys";
closeSystem = false;

Simulink.fileGenControl('set', ...
    'CacheFolder', fullfile(baseDir, "cache"));


if bdIsLoaded(model) && closeSystem, close_system(model); end
load_system(model)
get_sim_parameter(model, vehicle)
open_system(model)
