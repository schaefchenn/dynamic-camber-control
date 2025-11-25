clc; clear;

addpath(fullfile("include"))
addpath(fullfile("carmaker"))
addpath(fullfile("carmaker/skc"))

outputfile = fullfile("config","bmw_5series.json");

filename = 'BMW_5';
data = read_cm_file(filename);
disp(extractAfter(data.SuspF_Kin_0_FName,"/"))

make.value = 'BMW';
make.data_type = 'string';

model.value = '5 Series';
model.data_type = 'string';

wheelbase.value = (data.Wheel_fl_pos(1) - data.Wheel_rl_pos(1));
wheelbase.unit = 'm';
wheelbase.data_type = 'double';

track_width_front.value = data.Wheel_fl_pos(2) + (-1)*data.Wheel_fr_pos(2);
track_width_front.unit = 'm';
track_width_front.data_type = 'double';

track_width_rear.value = data.Wheel_rl_pos(2) + (-1)*data.Wheel_rr_pos(2);
track_width_rear.unit = 'm';
track_width_rear.data_type = 'double';

suspFile = extractAfter(data.SuspF_Kin_0_FName, "/");
suspData = read_cm_file(suspFile);
compressionFL = suspData.SuspF_Kin_0_L_Arg0_Fac2SI * suspData.SuspF_Kin_0_L_Arg0;
steerFL = suspData.SuspF_Kin_0_L_Arg1;
suspFL = suspData.SuspF_Kin_0_L_Data_Fac2SI .* suspData.SuspF_Kin_0_L_Data;
[~, idx] = ismember(suspFL(:,1), 0:(numel(compressionFL)-1));
suspFL(:,1) = compressionFL(idx);
[~, idx] = ismember(suspFL(:,2), 0:(numel(steerFL)-1));
suspFL(:,2) = steerFL(idx);
camberFL = suspFL(:,6);
camberMapFL = reshape(camberFL, size(steerFL, 2), size(compressionFL, 2));

compression_FL.value = compressionFL;
compression_FL.unit = 'm';
compression_FL.data_type = 'double';

steering_rack_displacement_FL.value = steerFL;
steering_rack_displacement_FL.unit = 'm';
steering_rack_displacement_FL.data_type = 'double';

camber_map_FL.value = camberMapFL;
camber_map_FL.unit = ' ';
camber_map_FL.data_type = 'double';

compressionFR = suspData.SuspF_Kin_0_R_Arg0_Fac2SI * suspData.SuspF_Kin_0_R_Arg0;
steerFR = suspData.SuspF_Kin_0_R_Arg1;
suspFR = suspData.SuspF_Kin_0_R_Data_Fac2SI .* suspData.SuspF_Kin_0_R_Data;
[~, idx] = ismember(suspFR(:,1), 0:(numel(compressionFR)-1));
suspFR(:,1) = compressionFR(idx);
[~, idx] = ismember(suspFR(:,2), 0:(numel(steerFR)-1));
suspFR(:,2) = steerFR(idx);
camberFR = suspFR(:,6);
camberMapFR = reshape(camberFR, size(steerFR, 2), size(compressionFR , 2));

compression_FR.value = compressionFR;
compression_FR.unit = 'm';
compression_FR.data_type = 'double';

steering_rack_displacement_FR.value = steerFR;
steering_rack_displacement_FR.unit = 'm';
steering_rack_displacement_FR.data_type = 'double';

camber_map_FR.value = camberMapFR;
camber_map_FR.unit = ' ';
camber_map_FR.data_type = 'double';

distance_to_pitch_center_rear.unit = ' ';
distance_to_pitch_center_front.data_type = 'array';

% still hardcoded !!!
distance_to_pitch_center_front.value = 1.487;
distance_to_pitch_center_front.unit = 'm';
distance_to_pitch_center_front.data_type = 'double';

distance_to_pitch_center_rear.value = 1.488;
distance_to_pitch_center_rear.unit = 'm';
distance_to_pitch_center_rear.data_type = 'double';

camber_control_bus.is_bus = true;
camber_control_bus.bus_name = 'camberControlBus';

json = struct();
json.make = make;
json.model = model;
json.wheelbase = wheelbase;
json.track_width_front = track_width_front;
json.track_width_rear = track_width_rear;
json.distance_to_pitch_center_front = distance_to_pitch_center_front;
json.distance_to_pitch_center_rear = distance_to_pitch_center_rear;
json.compression_FL = compression_FL;
json.steering_rack_displacement_FL = steering_rack_displacement_FL;
json.camber_map_FL = camber_map_FL;
json.compression_FR = compression_FR;
json.steering_rack_displacement_FR = steering_rack_displacement_FR;
json.camber_map_FR = camber_map_FR;
json.camber_control_bus = camber_control_bus;

jsonStr = jsonencode(json, 'PrettyPrint',true);
fid = fopen(outputfile, "w");
fprintf(fid,'%s', jsonStr);
fclose(fid);