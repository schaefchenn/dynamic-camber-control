% start controller with carMaker as co simulation
clc; clear;

% pid parameter
kp = 10;
ki = 0;
kd = 0;

% actuator pt1 parameter
k = 0.6;
T1 = 0.01;

% ratio for actuator angle into camber angle
ic = 1;

config.base.dir = fileparts(matlab.desktop.editor.getActiveFilename);
cd(config.base.dir)

addpath(config.base.dir);
addpath(genpath(fullfile(config.base.dir, "model")));
addpath(genpath(fullfile(config.base.dir, "cache")));
addpath(genpath(fullfile(config.base.dir, "configs")));
addpath(genpath(fullfile(config.base.dir, "include")));

config.carmaker.dir = fullfile(extractBefore(config.base.dir,'\simulink'),"carmaker");
addpath(genpath(fullfile(config.base.dir, "bmw/src_cm4sl")))

if ~isappdata(0, 'cmenv_initialized'); run('cmenv.m'); end

start_dir = fullfile(config.base.dir, "configs");
[config.file, config.path] = uigetfile( ...
    fullfile(start_dir, '*.json'), ...
    'Choose your .mat file');

clear start_dir

if isequal(config.file, 0)
    disp('No file selected.');
    return;
end

temp = jsondecode(fileread(strcat(config.path, config.file)));
config.base.vehicle_parameter_file = temp.vehicle_parameter_file;
config.base.tire_parameter_file = temp.tire_parameter_file;
config.carmaker.vehicle_file = temp.carmaker_vehicle_file;
config.carmaker.tire_file = temp.carMaker_tire_file;
clear temp

vehicle = jsondecode(fileread(config.base.vehicle_parameter_file)); 
tire = read_tir(config.base.tire_parameter_file);

create_bus_vehicle_states;
create_bus_controls;

load_system('sys')
get_sim_parameter('controller', vehicle)

mdlWks = get_param('controller',"ModelWorkspace");
param = Simulink.Parameter;
param.Value = tire;
param.CoderInfo.StorageClass = 'Auto';
assignin(mdlWks,"tire",param);
open_system('sys')

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
