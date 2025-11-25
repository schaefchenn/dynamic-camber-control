clc; clear;

addpath(fullfile("skc"))
addpath(fullfile("include"))

filename = 'McPherson_FrontAxle.skc';
data = read_suspension_file(filename);

% left side
compression = data.SuspF_Kin_0_L_Arg0_Fac2SI * data.SuspF_Kin_0_L_Arg0;
steer = data.SuspF_Kin_0_L_Arg1;

suspFL = data.SuspF_Kin_0_L_Data_Fac2SI .* data.SuspF_Kin_0_L_Data;

[~, idx] = ismember(suspFL(:,1), 0:(numel(compression)-1));
suspFL(:,1) = compression(idx);

[~, idx] = ismember(suspFL(:,2), 0:(numel(steer)-1));
suspFL(:,2) = steer(idx);

x = suspFL(:,1)*10^3;
y = suspFL(:,2)*10^3;
z = suspFL(:,6);

zg = reshape(z, size(steer, 2), size(compression, 2));
camberMapFL = zg;

[X, Y] = meshgrid(unique(x), unique(y));
Z = griddata(x, y, z, X, Y); 

figure
surf(X, Y, Z)
xlabel('compression [mm]')
ylabel('steering rack [mm]')
zlabel('camber')
shading interp
colorbar


disp(data);
