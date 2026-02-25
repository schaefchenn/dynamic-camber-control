%% MF5.2 Combined Slip Tyre Model (Pure Lateral shown in 3D)

clc;
clear;
close all;

%% Inputs

Fz = 6500;
kappa = 0; %#ok<NASGU> % aktuell nicht verwendet

alpha = -0.3:0.001:1;        % Slip angle
gamma = -0.3:0.001:0.3;      % Camber angle

%% Parameter

% general
Fz0 = 6500;

% pure slip
p_Cy1 = 2.1322;

p_Dy1 = 1.0283;
p_Dy2 = -0.16758;
p_Dy3 = -1.5821;

p_Ey1 = 0.33443;
p_Ey2 = -1.8733;
p_Ey3 = -0.13136;
p_Ey4 = -11.677;

p_Ky1 = -20.505;
p_Ky2 = 2.0284;
p_Ky3 = 0.89994;

p_Hy1 = 0.0031377;
p_Hy2 = 0.00051596;
p_Hy3 = 0.039251;

p_Vy1 = 0.026365;
p_Vy2 = -0.0062119;
p_Vy3 = -0.41389;
p_Vy4 = -0.048038;

% combined slip (aktuell nicht verwendet)
r_Hy1 = -9.1492e-11; %#ok<NASGU>
r_Hy2 = 0; %#ok<NASGU>

r_By1 = 22.003; %#ok<NASGU>
r_By2 = -13.623; %#ok<NASGU>
r_By3 = -0.0093616; %#ok<NASGU>

r_Cy1 = 0.98294; %#ok<NASGU>

r_Ey1 = 0; %#ok<NASGU>
r_Ey2 = 0; %#ok<NASGU>

%% ===== 2D Gitter erzeugen (wichtig!) =====
% Für jedes Gamma werden alle Alpha-Werte berechnet

[ALPHA, GAMMA] = meshgrid(alpha, gamma);

%% Berechnungen

% general
dfz = (Fz - Fz0) / Fz0;

% lateral (pure slip)
Cy = p_Cy1;

mu_y = (p_Dy1 + p_Dy2 .* dfz) .* (1 - p_Dy3 .* GAMMA.^2);
Dy = mu_y .* Fz;

Ey = (p_Ey1 + p_Ey2 .* dfz) .* ...
     (1 - (p_Ey3 + p_Ey4 .* GAMMA) .* sign(ALPHA));

Ky = p_Ky1 .* Fz0 .* sin(2 .* atan(Fz / (p_Ky2 .* Fz0))) .* ...
     (1 - p_Ky3 .* abs(GAMMA));

By = Ky ./ (Cy .* Dy);

S_Hy = p_Hy1 + p_Hy2 + p_Hy3 .* GAMMA;

S_Vy = Fz .* (p_Vy1 + p_Vy2 .* dfz + ...
       (p_Vy3 + p_Vy4 .* dfz) .* GAMMA);

alpha_y = ALPHA + S_Hy;

Fy0 = Dy .* sin(Cy .* atan(By .* alpha_y ...
      - Ey .* (By .* alpha_y - atan(By .* alpha_y)))) ...
      + S_Vy;

%% ===== 3D Plot =====

figure
surf(ALPHA, GAMMA, Fy0)

xlabel('\alpha [rad]')
ylabel('\gamma [rad]')
zlabel('F_y [N]')
title('MF5.2 Pure Lateral Force')

shading interp
colorbar
view(135,30)
grid on