%% clean up (house keeping)
clc; clear; restoredefaultpath;

%% pid params && settings
parameter = struct();

% pid parameter
parameter.pid = struct( ...
    'kp', 0.6, ...
    'ki', 0, ...
    'kd', 0.03 ...
);

% actuator pt1 parameter
parameter.actuator = struct( ...
    'k', 80, ...
    'T1', 0.05, ...
    'ic', 1 ... % ratio for actuator angle into camber angle
);

settings.close_system = false;

%% add paths (house keeping)
config.base.dir = fileparts(matlab.desktop.editor.getActiveFilename);
cd(config.base.dir)

addpath(config.base.dir);
addpath(genpath(fullfile(config.base.dir, "model")));
addpath(genpath(fullfile(config.base.dir, "cache")));
addpath(genpath(fullfile(config.base.dir, "configs")));
addpath(genpath(fullfile(config.base.dir, "include")));
addpath(genpath(fullfile(config.base.dir, "inputs")));

%% user selections
% vehicle selection
filter = fullfile(config.base.dir, "configs", "*.m");
[file, path] = uigetfile(filter, 'select a vehicle.m function');
if isequal(file, 0); disp('No file selected.'); return; end

[~, temp.func_name, ~] = fileparts(file);
temp.data = feval(temp.func_name);

% measurement selection
filter = fullfile(config.base.dir, "inputs", "*.mat");
[file, path] = uigetfile(filter, 'select a measurement.mat');
if isequal(file, 0); disp('No file selected.'); return; end
config.meta.measurement_file = file;

% simulink model selection
filter = fullfile(config.base.dir, "model", "*.slx");
[file, path] = uigetfile(filter, 'select a simulink.slx');
if isequal(file, 0); disp('No file selected.'); return; end
config.model = file;

%% set cache folder && load data && create bus
Simulink.fileGenControl('set', ...
    'CacheFolder', fullfile(config.base.dir, "cache"));

%% write paramter into structs
simin = load(config.meta.measurement_file); simin = simin.data;

config.carmaker = temp.data.config.carmaker;
config.meta = temp.data.config.meta;

parameter.vehicle = temp.data.parameters;
parameter.tire = read_tir(config.meta.tire_file);

clear filter; clear file; clear path; clear temp;

%% fmi and carMaker dont like paramter structs for tunable params
kp = parameter.pid.kp;
ki = parameter.pid.ki;
kd = parameter.pid.kd;
k = parameter.actuator.k;
T1 = parameter.actuator.T1;
ic = parameter.actuator.ic;

%% create busses (needed for carMaker)
create_bus_vehicle_states();
create_bus_controls();

%% load simulink && add params to simulink && open simulink
if bdIsLoaded(extractBefore(config.model,'.')) && settings.close_system
    close_system(extractBefore(config.model,'.'))
end

load_system(extractBefore(config.model,'.'))
get_sim_parameter(extractBefore(config.model,'.'), parameter.vehicle)

mdlWks = get_param(extractBefore(config.model,'.'),"ModelWorkspace");
param = Simulink.Parameter;
param.Value = parameter.tire;
param.CoderInfo.StorageClass = 'Auto';
assignin(mdlWks,"tire",param);

open_system(extractBefore(config.model,'.'))
