
fname = 'results.csv';
header = {'time','springDeflFL','springDeflFR','camberFL', 'camberFR' ...
    'cmComFL', 'cmComFR', 'cmCamKinFL', 'cmCamKinFR', 'cmCamFL','cmCamFR' ...
    'cmPitchCenterL', 'cmPitchCenterR'};
addpath(fullfile("outputs"))

time = simin.Time.data;

springDeflectionFL = out.springDeflectionFL;
springDeflectionFR = out.springDeflectionFR;
camberFL = out.camberFL;
camberFR = out.camberFR;

carMakerCompFL = simin.Car_CFL_q0.data;
carMakerCompFR = simin.Car_CFR_q0.data;
carMakerCamberKinFL = simin.Car_CFL_rx_kin.data;
carMakerCamberKinFR = simin.Car_CFR_rx_kin.data;
carMakerCamberFL = simin.Car_CFL_rx.data;
carMakerCamberFR = simin.Car_CFR_rx.data;
carMakerPitchCenterL = simin.Car_KinPitchCenter_L_x_1.data;
carMakerPitchCenterR = simin.Car_KinPitchCenter_R_x_1.data;

time(end) = [];
carMakerCompFL(end) = [];
carMakerCompFR(end) = [];
carMakerCamberKinFL(end) = [];
carMakerCamberKinFR(end) = [];
carMakerCamberFL(end) = [];
carMakerCamberFR(end) = [];
carMakerPitchCenterL(end) = [];
carMakerPitchCenterR(end) = [];

simOuts = [springDeflectionFL springDeflectionFR camberFL camberFR];
cmOuts = [carMakerCompFL', carMakerCompFR', carMakerCamberKinFL', ... 
    carMakerCamberKinFR', carMakerCamberFL', carMakerCamberFR', ... 
    carMakerPitchCenterL', carMakerPitchCenterR'];
outputs = [time' simOuts cmOuts];


writecell(header,fname);
writematrix(outputs,fname,'WriteMode','append');