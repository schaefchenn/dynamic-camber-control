OutQuantsGetFName
OutQuantsDelAll
set quants {Time Car.v Car.ax Car.ay Car.az}
OutQuantsAdd $quants
set quants2 {Car.CFL.q0 Car.CFL.rx Car.CFR.q0 Car.CFR.rx Car.CRL.q0 Car.CRL.rx Car.CRR.q0 Car.CRR.rx}
OutQuantsAdd $quants2
set quants3 {Car.DampFL.Frc Car.DampFR.Frc Car.DampRL.Frc Car.DampRR.Frc}
OutQuantsAdd $quants3
set quants4 {Steer.L.q Steer.R.q Steer.RL.q Steer.RR.q}
OutQuantsAdd $quants4
set quants5 {Car.Roll Car.RollAcc Car.RollVel Car.Pitch Car.PitchAcc Car.PitchVel}
OutQuantsAdd $quants5
set quants5 {Car.KinPitchCenter_L.x Car.KinPitchCenter_L.z Car.KinPitchCenter_R.x Car.Pitch Car.KinPitchCenter_R.z Car.KinRollCenter_F.y Car.KinRollCenter_F.x_1 Car.KinRollCenter_F.z Car.KinRollCenter_R.x_1 Car.KinRollCenter_R.y Car.KinRollCenter_R.z}
OutQuantsAdd $quants5

SaveMode save_all

Log "* Run constant velocity 80km/h"
LoadTestRun "const_vel80"
StartSim
SaveStart
WaitForStatus running
WaitForStatus idle
SaveStop

Log "* Run stationary circle drive 80km/h"
LoadTestRun "stat_circle80"
StartSim
WaitForStatus running
WaitForStatus idle

Log "* Run acceleration to 80km/h"
LoadTestRun "acceleration_to80"
StartSim
WaitForStatus running
WaitForStatus idle

Log "* Run decceleration from 80km/h"
LoadTestRun "decceleration_from80"
StartSim
WaitForStatus running
WaitForStatus idle
