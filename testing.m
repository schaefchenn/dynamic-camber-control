% Trajectory of the wheel centerpoint
clc; clear;

yA0 = 0;
zA0 = 0;
yB0 = -5;
zB0 = -5;

length1 = 20;
length2 = 25;
alpha = 0:0.1:360;
alpha2 = (alpha + atan((1/length2)*(length1 - yB0)))*pi/180;


zA1 = zA0 + length1 * sin(alpha);
yA1 = yA0 + length1 * cos(alpha);

zB1 = zB0 + length2 * sin(alpha2);
yB1 = yB0 + length2 * cos(alpha2);

camber = [];
distance = [];
for n = 1:length(zA1)
    camber = [camber, atan((yA1(n)-yB1(n))/(zA1(n)-zB1(n)))];
    distance = [distance, sqrt((yA1(n)-yB1(n))^2 + (zA1(n)-yB1(n))^2)];
end

figure();
plot(yA1, zA1);
hold on
plot(yB1, zB1);
%plot([yA1(100), yB1], [zA1, zB1]);

figure();
plot(alpha.*180/pi, camber.*180/pi);
plot(alpha.*180/pi, distance);