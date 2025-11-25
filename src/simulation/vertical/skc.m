clc; clear;

addpath(fullfile("include"))
addpath(fullfile("carmaker"))
addpath(fullfile("carmaker/skc"))

% ====== front ============================================================
filename = 'McPherson_FrontAxle.skc';
data = read_cm_file(filename);

% left
compressionFL = data.SuspF_Kin_0_L_Arg0_Fac2SI * data.SuspF_Kin_0_L_Arg0;
steerFL = data.SuspF_Kin_0_L_Arg1;

suspFL = data.SuspF_Kin_0_L_Data_Fac2SI .* data.SuspF_Kin_0_L_Data;

[~, idx] = ismember(suspFL(:,1), 0:(numel(compressionFL)-1));
suspFL(:,1) = compressionFL(idx);

[~, idx] = ismember(suspFL(:,2), 0:(numel(steerFL)-1));
suspFL(:,2) = steerFL(idx);

camberFL = suspFL(:,6);
camberMapFL = reshape(camberFL, size(steerFL, 2), size(compressionFL, 2));

% right
compressionFR = data.SuspF_Kin_0_R_Arg0_Fac2SI * data.SuspF_Kin_0_R_Arg0;
steerFR = data.SuspF_Kin_0_R_Arg1;

suspFR = data.SuspF_Kin_0_R_Data_Fac2SI .* data.SuspF_Kin_0_R_Data;

[~, idx] = ismember(suspFR(:,1), 0:(numel(compressionFR)-1));
suspFR(:,1) = compressionFR(idx);

[~, idx] = ismember(suspFR(:,2), 0:(numel(steerFR)-1));
suspFR(:,2) = steerFR(idx);

camberFR = suspFR(:,6);
camberMapFR = reshape(camberFR, size(steerFR, 2), size(compressionFR , 2));

clear idx;

f = figure('Name','kinematics');
tg = uitabgroup(f,'Position',[0.05 0.05 0.9 0.9]);    % Tab-Gruppe
t1 = uitab(tg,'Title','front left');                        % Tab 1
t2 = uitab(tg,'Title','front right');

axes(t1);
plot_camber(suspFL)

axes(t2);
plot_camber(suspFR)

function plot_camber(susp)
    x = susp(:,1)*10^3;
    y = susp(:,2)*10^3;
    z = susp(:,6);

    [X, Y] = meshgrid(unique(x), unique(y));
    Z = griddata(x, y, z, X, Y); 

    surf(X, Y, Z)
    xlabel('compression [mm]')
    ylabel('steering rack [mm]')
    zlabel('camber')
    shading interp
    colorbar
end