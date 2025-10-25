% Auslenkung Aufbaufedern
% k Wankwinkel
% sV Spurweite vorne
% sH Spurweite hinten
% phi Nickwinkel
% lNZV abstand Nickwinkelzentrum zur Vorderachse
% z1 = z - sin(k) * (sV/2) - sin(phi) * lNZV;
% z2 = z + sin(k) * (sV/2) - sin(phi) * lNZV;
% z3 = z - sin(k) * (sH/2) - sin(phi) * (l-lNZV);
% z4 = z + sin(k) * (sH/2) - sin(phi) * (l-lNZV);

% cA1 =
Ff1 = cA1 * z1;
Ff2 = cA2 * z2;
Ff3 = cA3 * z3;
Ff4 = cA1 * z4;

Fd1 = dA1 * zp1;
Fd2 = dA2 * zp2;
Fd3 = dA3 * zp3;
Fd4 = dA4 * zp4;