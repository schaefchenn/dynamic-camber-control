clc; clear; close;

baseDir = fileparts(matlab.desktop.editor.getActiveFilename);
addpath(baseDir);
addpath(genpath(fullfile(baseDir, "ref_vehicle")));

load("pitch_torque_to_front.mat")

vehicleParameter = struct( ...
    "wheelbase", struct( ...
        "value", 2.975, ...
        "unit", "m", ...
        "datatype", "double" ...
    )...
);

poi = 7;
time = data.Time.data;
[~, idx] = min(abs(time - poi));
time_poi = time(idx);

pitchAngle = data.Car_Pitch.data;

FzFL = data.Car_FzFL.data;
FzFR = data.Car_FzFR.data;
FzRL = data.Car_FzRL.data;
FzRR = data.Car_FzRR.data;

dFzL = (FzFL-FzRL)/2;
dFzR = (FzFR-FzRR)/2;

pitchStiffnesL = dFzL .* vehicleParameter.wheelbase.value ./ pitchAngle;
pitchStiffnesR = dFzR .* vehicleParameter.wheelbase.value ./ pitchAngle;
My = data.Car_Virtual_Trq_1_y.data;

totalPitchStiffness = [diff(My) ./ diff(pitchAngle) NaN];

totalPitchStiffness_poi = totalPitchStiffness(idx);
pitchStiffnesL_poi = pitchStiffnesL(idx);
rollingStiffnesR_poi = pitchStiffnesR(idx);

idx = time > 3 & time < 34;
theta = pitchAngle(idx);
pitchStiffness = totalPitchStiffness(idx);

x = theta;
y = pitchStiffness;

% neue reduzierte Stützstellen (z.B. 200 statt 3099)
x_new = linspace(min(x), max(x), 200);

% Interpolation
y_new = interp1(x, y, x_new, 'pchip'); % formtreu
pitchStiffnessMap = [x_new; y_new];

p = polyfit(theta, pitchStiffness, 4);
k_fit = polyval(p, theta);

% command window
fprintf('pitchStiffness = %.6e * pitchAngle^3 + %.6e * pitchAngle^2 + %.6e * pitchAngle + %.6e;\n\n', ...
        p(1), p(2), p(3), p(4));

fprintf( ...
    "pitch stiffnes at point of interest time = %.4fs: " + ...
    "total pitch stiffness: %.4f Nm/rad\n" + ...
    "pitch stiffness left:  %.4f Nm/rad\n" + ...
    "pitch stiffness right: %.4f Nm/rad\n", ...
    totalPitchStiffness_poi, ...
    pitchStiffnesL_poi, ...
    rollingStiffnesR_poi, ...
    time_poi ...
);

% plotting
linewidth = 1.8;
fontSizeLabel = 11;
fontSizeLegend = 10;
figWidth  = 1600;
figHeight = 800;
f = figure( ...
    'Name','pitch behavior', ...
    'NumberTitle','off', ...
    'Units','pixels', ...
    'Position',[100 100 figWidth figHeight] ...
);

tg = uitabgroup(f);
tab1 = uitab(tg, 'Title', 'pitch torque / pitch angle');
ax1 = axes('Parent', tab1);
yyaxis left
plot(time, My,'LineWidth',linewidth); hold on; grid on;
xlabel('time $[s]$','Interpreter','latex','FontSize',fontSizeLabel)
ylabel('pitch torque $[Nm]$','Interpreter','latex','FontSize',fontSizeLabel)
xlim([min(time) max(time)])
ylim([min(My) max(My)])

yyaxis right
plot(time, pitchAngle .* 180/pi,'LineWidth',linewidth); hold on; grid on;
xlabel('time $[s]$','Interpreter','latex','FontSize',fontSizeLabel)
ylabel('pitch angle $[deg]$','Interpreter','latex','FontSize',fontSizeLabel)
xlim([min(time) max(time)])
ylim([min(pitchAngle .* 180/pi) max(pitchAngle .* 180/pi)])

legend({ ...
        '$M_{y}$', ...
        '$\theta$', ...
        }, ...
        'Interpreter','latex', ...
        'Location','northwest','FontSize',fontSizeLegend, ...
        'Box','off');

tab2 = uitab(tg, 'Title', 'lateral wheel loads');
ax2 = axes('Parent', tab2);
plot(time, FzFL, 'LineWidth',linewidth); hold on
plot(time, FzFR, 'LineWidth',linewidth);
plot(time, FzRL, 'LineWidth',linewidth);
plot(time, FzRR, 'LineWidth',linewidth); grid on
xlabel('time $[s]$','Interpreter','latex','FontSize',fontSizeLabel)
ylabel('lateral wheel load $[N]$','Interpreter','latex','FontSize',fontSizeLabel)
xlim([min(time) max(time)])

legend({ ...
        '$F_{zFL}$', ...
        '$F_{zFR}$', ...
        '$F_{zRL}$', ...
        '$F_{zRR}$', ...
        }, ...
        'Interpreter','latex', ...
        'Location','northwest','FontSize',fontSizeLegend, ...
        'Box','off');

tab3 = uitab(tg, 'Title', 'lateral wheel loads');
ax3 = axes('Parent', tab3);
plot(time, abs(dFzL), 'LineWidth',linewidth); hold on
plot(time, abs(dFzR), 'LineWidth',linewidth); grid on
xlabel('time $[s]$','Interpreter','latex','FontSize',fontSizeLabel)
xlim([min(time) max(time)])

legend({ ...
        '$\Delta{F_{zL}}$', ...
        '$\Delta{F_{zR}}$', ...
        }, ...
        'Interpreter','latex', ...
        'Location','northwest','FontSize',fontSizeLegend, ...
        'Box','off');

tab4 = uitab(tg, 'Title', 'pitch stiffness');
ax4 = axes('Parent', tab4);
plot(time, pitchStiffnesL, 'LineWidth',linewidth); hold on
plot(time, pitchStiffnesR, 'LineWidth',linewidth); grid on
plot(time, totalPitchStiffness, 'LineWidth',linewidth);
ylabel('pitch stiffness $[Nm/rad]$','Interpreter','latex','FontSize',fontSizeLabel)
xlabel('time $[s]$','Interpreter','latex','FontSize',fontSizeLabel)
xlim([min(time)+1.5 max(time)-0.1])
ylim([min(130000) max(650000)])

legend({ ...
        '$c_{nL}$', ...
        '$c_{nR}$', ...
        '$c_{n}$', ...
        }, ...
        'Interpreter','latex', ...
        'Location','southeast','FontSize',fontSizeLegend, ...
        'Box','off');

tab5 = uitab(tg, 'Title', 'pitch stiffness');
ax5 = axes('Parent', tab5);
scatter(theta, pitchStiffness, 5, '.','LineWidth', linewidth); hold on
plot(theta, k_fit, 'r', 'LineWidth', linewidth+1); grid on
plot(x_new, y_new,'--g', 'LineWidth', linewidth)
