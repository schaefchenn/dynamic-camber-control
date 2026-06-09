% start controller with carMaker as co simulation
clc; clear

%% params && settings
parameter = struct();

% pid parameter
parameter.pid = struct( ...
    'kp', 0.1, ...
    'ki', 0.005, ...
    'kd', 0 ...
);

% actuator pt1 parameter
parameter.actuator = struct( ...
    'k', 80, ...
    'T1', 0.05, ...
    'ic', 1 ... % ratio for actuator angle into camber angle
);

settings.is_testmode = false;

%% add paths (house keeping)
config.base.dir = fileparts(matlab.desktop.editor.getActiveFilename);
cd(config.base.dir)

addpath(config.base.dir);
addpath(genpath(fullfile(config.base.dir, "model")));
addpath(genpath(fullfile(config.base.dir, "cache")));
addpath(genpath(fullfile(config.base.dir, "configs")));
addpath(genpath(fullfile(config.base.dir, "include")));

config.base.root = fileparts(config.base.dir);
config.carmaker.dir = fullfile(config.base.root, "carmaker");
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
filter = fullfile(config.base.dir, "configs", "*.m");
[file, path] = uigetfile(filter, 'select a vehicle.m function');
if isequal(file, 0); disp('No file selected.'); return; end

[~, temp.func_name, ~] = fileparts(file);
temp.data = feval(temp.func_name);

config.carmaker.vehicle_file = temp.data.config.carmaker.vehicle_file;
config.carmaker.tire_file = temp.data.config.carmaker.tire_file;
config.meta = temp.data.config.meta;

parameter.vehicle = temp.data.parameters;
parameter.tire = read_tir(config.meta.tire_file);

clear filter; clear file; clear path; clear temp;

%% set cache folder && load data && create bus
Simulink.fileGenControl('set', ...
    'CacheFolder', fullfile(config.base.dir, "cache"));

%% fmi and carMaker dont like paramter structs for tunable params
kp = parameter.pid.kp;
ki = parameter.pid.ki;
kd = parameter.pid.kd;
k = parameter.actuator.k;
T1 = parameter.actuator.T1;
ic = parameter.actuator.ic;

%% create busses (needed for carMaker)
create_bus_vehicle_states;
create_bus_controls;

%% load simulink && add params to simulink && open simulink
load_system('sys'); load_system('controller');
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
