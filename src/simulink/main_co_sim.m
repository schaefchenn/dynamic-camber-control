% start controller with carMaker as co simulation
clc; clear; restoredefaultpath;

%% params && settings
parameter = struct();

% pid parameter
parameter.pid = struct( ...
    'kp', 10, ...
    'ki', 0, ...
    'kd', 0 ...
);

% actuator pt1 parameter
parameter.actuator = struct( ...
    'k', 0.6, ...
    'T1', 0.01, ...
    'ic', 1 ... % ratio for actuator angle into camber angle
);

settings = struct();

%% add paths (house keeping)
config.base.dir = fileparts(matlab.desktop.editor.getActiveFilename);
cd(config.base.dir)

addpath(config.base.dir);
addpath(genpath(fullfile(config.base.dir, "model")));
addpath(genpath(fullfile(config.base.dir, "cache")));
addpath(genpath(fullfile(config.base.dir, "configs")));
addpath(genpath(fullfile(config.base.dir, "include")));

config.carmaker.dir = fullfile(extractBefore(config.base.dir,'/simulink'),"carmaker");
addpath(genpath(fullfile(config.carmaker.dir, "bmw/src_cm4sl")))

%% initialise carMaker environment
if ~isappdata(0, 'cmenv_initialized')
    try 
        run('cmenv.m')
    catch me
        warning(me.message)
        return
    end

end

%% user selection
filter = fullfile(config.base.dir, "configs", "*.json");
[file, path] = uigetfile(filter, 'select a vehicle.json');
if isequal(file, 0); disp('No file selected.'); return; end
config.meta.file = file;
config.meta.path = path;

temp = jsondecode(fileread(strcat(config.meta.path, config.meta.file)));
config.meta.vehicle_parameter_file = temp.vehicle_parameter_file;
config.meta.tire_parameter_file = temp.tire_parameter_file;
config.carmaker.vehicle_file = temp.carmaker_vehicle_file;
config.carmaker.tire_file = temp.carMaker_tire_file;
clear temp

%% set cache folder && load data && create bus
Simulink.fileGenControl('set', ...
    'CacheFolder', fullfile(config.base.dir, "cache"));

parameter.vehicle = jsondecode(fileread(config.meta.vehicle_parameter_file)); 
parameter.tire = read_tir(config.meta.tire_parameter_file);

% fmi and carMaker dont like paramter structs
kp = parameter.pid.kp;
ki = parameter.pid.ki;
kd = parameter.pid.kd;
k = parameter.actuator.k;
T1 = parameter.actuator.T1;
ic = parameter.actuator.ic;

create_bus_vehicle_states;
create_bus_controls;

%% load simulink && add params to simulink && open simulink
load_system('sys')
get_sim_parameter('controller', parameter.vehicle)

mdlWks = get_param('controller',"ModelWorkspace");
param = Simulink.Parameter;
param.Value = parameter.tire;
param.CoderInfo.StorageClass = 'Auto';
assignin(mdlWks,"tire",param);

open_system('sys')

%% open carMaker GUI && setup testrun
cd(fullfile(config.carmaker.dir, "bmw"));
CM_Simulink;

cmguicmd('LoadTestRun "init"');

cmguicmd(strcat(['IFileModify TestRun "Vehicle" "', config.carmaker.vehicle_file,'"']));
cmguicmd(strcat(['IFileModify TestRun "Tire.0" "', config.carmaker.tire_file,'"']));
cmguicmd(strcat(['IFileModify TestRun "Tire.1" "', config.carmaker.tire_file,'"']));
cmguicmd(strcat(['IFileModify TestRun "Tire.2" "', config.carmaker.tire_file,'"']));
cmguicmd(strcat(['IFileModify TestRun "Tire.3" "', config.carmaker.tire_file,'"']));
cmguicmd('IFileFlush TestRun');

cmguicmd(strcat(['IFileModify Vehicle "Tire.0" "', config.carmaker.tire_file,'"']));
cmguicmd(strcat(['IFileModify Vehicle "Tire.1" "', config.carmaker.tire_file,'"']));
cmguicmd(strcat(['IFileModify Vehicle "Tire.2" "', config.carmaker.tire_file,'"']));
cmguicmd(strcat(['IFileModify Vehicle "Tire.3" "', config.carmaker.tire_file,'"']));
cmguicmd('IFileFlush Vehicle');
