% start controller with carMaker as co simulation

baseDir = fileparts(matlab.desktop.editor.getActiveFilename);
cd(baseDir)

addpath(baseDir);
addpath(genpath(fullfile(baseDir, "model")));
addpath(genpath(fullfile(baseDir, "cache")));
addpath(genpath(fullfile(baseDir, "configs")));
addpath(genpath(fullfile(baseDir, "include")));
addpath(genpath(fullfile(extractBefore(baseDir,'\simulink'),"carMaker")))

if ~isappdata(0, 'cmenv_initialized'); run('cmenv.m'); end