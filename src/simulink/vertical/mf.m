% mf52 combined slip tyre model
clc; clear;

%% inputs

Fz = 6500;
kappa = 0;
alpha = 0.4;
gamma = -0.30:0.001:0.3;%-0.34:0.001:0.34;

%% parameter

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

% combined slip
r_Hy1 = -9.1492e-11;
r_Hy2 = 0;

r_By1 = 22.003;
r_By2 = -13.623;
r_By3 = -0.0093616;

r_Cy1 = 0.98294;

r_Ey1 = 0;
r_Ey2 = 0;

%% calculations

% general
dfz = ((Fz-Fz0)/Fz0);

% lateral (pure slip)
Cy = p_Cy1;

mu_y = (p_Dy1 + p_Dy2 .* dfz) .* (1-p_Dy3 .* gamma.^2);
Dy = mu_y .* Fz;

Ey = (p_Ey1 + p_Ey2 .* dfz) .* (1 - (p_Ey3 + p_Ey4 .* gamma) .* sign(alpha));
Ky = p_Ky1 .* Fz0 .* sin(2 .* atan(Fz / (p_Ky2 .* Fz0))) .* (1 - p_Ky3 .* abs(gamma));
By = Ky / (Cy .* Dy);

S_Hy = p_Hy1 + p_Hy2 + p_Hy3 .* gamma;
S_Vy = Fz .* (p_Vy1 + p_Vy2 .* dfz + (p_Vy3 + p_Vy4 .* dfz) .* gamma);

alpha_y = alpha + S_Hy;
Fy0 = Dy .* sin(Cy .* atan(By .* alpha_y - Ey .* (By .* alpha_y - atan(By .* alpha_y)))) + S_Vy;

% % combined slip
% % lateral slip
% S_Hyk = r_Hy1 + r_Hy2 * dfz;
% kappa_s = kappa + S_Hyk;
% 
% % coefficients
% B_yk = r_By1 * cos(atan(r_By2 * (alpha-r_By3)));
% C_yk = r_Cy1;
% E_yk = r_Ey1 + r_Ey2 * dfz;

%D_Vyk = mu_y * 

figure(1)
plot(gamma, Fy0); hold on;