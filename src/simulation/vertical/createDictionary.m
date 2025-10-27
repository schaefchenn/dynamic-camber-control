clc; clear; close;

addpath(fullfile("include"))
addpath(fullfile("dictionary"))
addpath(fullfile("config"))

vehicleConfigFile = fullfile('config/bmw_5series_param.json');
vehicleData = read_json(vehicleConfigFile); % dein JSON einlesen

dictFileName = fullfile('dictionary','vehicleData.sldd');
if exist(dictFileName, 'file')
    dd = Simulink.data.dictionary.open(dictFileName);
else
    dd = Simulink.data.dictionary.create(dictFileName);
end

add_data_to_dictionary(dd, vehicleData);
saveChanges(dd);
