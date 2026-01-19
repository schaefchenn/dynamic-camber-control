# --- Output Quantities -------------------------------------------------------

OutQuantsGetFName
OutQuantsDelAll

set quantGroups {
    {Time Car.v Car.ax Car.ay Car.az}
    {Car.tx Car.ty Car.tz}
    {Car.CFL.q0 Car.CFR.q0 Car.CRL.q0 Car.CRR.q0}
    {Car.CFL.q2 Car.CFR.q2 Car.CRL.q2 Car.CRR.q2}
    {Steer.L.q Steer.R.q Steer.RL.q Steer.RR.q}
    {Car.CFL.rx Car.CFR.rx Car.CRL.rx Car.CRR.rx}
    {Car.CFL.rx_kin Car.CFR.rx_kin Car.CRL.rx_kin Car.CRR.rx_kin}
    {Car.CamberFL Car.CamberFR Car.CamberRL Car.CamberRR}
    {Car.SlipAngleFL Car.SlipAngleFR Car.SlipAngleRL Car.SlipAngleRR}
    {Car.DampFL.Frc Car.DampFR.Frc Car.DampRL.Frc Car.DampRR.Frc}
    {Car.SpringFL.Frc Car.SpringFR.Frc Car.SpringRL.Frc Car.SpringRR.Frc}
    {Car.StabiFL.Frc Car.StabiFR.Frc Car.StabiRL.Frc Car.StabiRR.Frc}
    {Car.SteerAngleFL Car.SteerAngleFR Car.SteerAngleRL Car.SteerAngleRR}
    {Car.Roll Car.RollAcc Car.RollVel Car.Pitch Car.PitchAcc Car.PitchVel}
    {Car.FzFL Car.FzFR Car.FzRL Car.FzRR Car.Virtual.Trq_1.x Car.Virtual.Trq_1.y}
    {Car.KinPitchCenter_L.x Car.KinPitchCenter_L.x_1
     Car.KinPitchCenter_L.z Car.KinPitchCenter_L.z_1
     Car.KinPitchCenter_L.y_1
     Car.KinPitchCenter_R.x Car.KinPitchCenter_R.x_1
     Car.KinPitchCenter_R.z Car.KinPitchCenter_R.z_1
     Car.KinPitchCenter_R.y_1
     Car.KinRollCenter_F.y Car.KinRollCenter_F.y_1
     Car.KinRollCenter_F.z Car.KinRollCenter_F.z_1
     Car.KinRollCenter_F.x_1
     Car.KinRollCenter_R.y Car.KinRollCenter_R.y_1
     Car.KinRollCenter_R.z Car.KinRollCenter_R.z_1
     Car.KinRollCenter_R.x_1}
}

foreach quants $quantGroups {
    OutQuantsAdd $quants
}

SaveMode save_all

# --- Direct Variable Access Quantities -------------------------------------------------------

DVAReleaseQuants
QuantSubscribe Car.Virtual.Trq_1.y
QuantSubscribe Car.FzFL
QuantSubscribe Car.FzFR
QuantSubscribe Car.FzRL
QuantSubscribe Car.FzRR


# --- Execute Simulation ---------------------------------------------------------------------

set name "pitch_torque_to_rear"
set testRun "stand_still"

set maxTorque -40000                        ;# [Nm]
set rampTime 60.0                           ;# [s]
set sampleTime 1                            ;# [ms]
set minLateralForce 0                       ;# N
set timeout [expr $rampTime + 1]            ;# [s] -> if break condition is never met 

proc roll_over_check {t0 minLateralForce timeout sampleTime} {
    while {1} {

        set FzFL [DVARead Car.FzFL]
        set FzFR [DVARead Car.FzFR]
        set FzRL [DVARead Car.FzRL]
        set FzRR [DVARead Car.FzRR]

        if {($FzFL <= $minLateralForce) && ($FzFR <= $minLateralForce)} {

            set currentTorque [DVARead Car.Virtual.Trq_1.y]
            DVAWrite Car.Virtual.Trq_1.y 0 -1 Abs

            Log "   *  front of the vehicle starts to lift at:"
            Log "   *  torque = $currentTorque Nm"

            break
        }

        if {($FzRL <= $minLateralForce) && ($FzRR <= $minLateralForce)} {

            set currentTorque [DVARead Car.Virtual.Trq_1.y]
            DVAWrite Car.Virtual.Trq_1.y 0 -1 Abs

            Log "   *  rear of the vehicle starts to lift at:"
            Log "   *  torque = $currentTorque Nm"
            
            break
        }

        # --- savety-timeout ---
        if {[expr {[DVARead Time] - $t0}] > $timeout} {
            Log "    *  timeout"
            break
        }

        Sleep $sampleTime
    }
}

# 
set day [clock format [clock seconds] -format "%d_%m_%Y"]
set timestamp [clock format [clock seconds] -format "%H-%M-%S"]

# 
set dayFolder [file join "SimOutput" "Data" $day]
file mkdir $dayFolder

set testRunFolder [file join $dayFolder $name]
file mkdir $testRunFolder

# 
set resultFile [file join $testRunFolder "${timestamp}.erg"]
SetResultFName $resultFile

Log "* run $testRun"
LoadTestRun $testRun

StartSim
WaitForStatus running
Sleep 1000

Log "* graduatly apply $maxTorque Nm rolling toqrue over $rampTime s"
DVAWrite Car.Virtual.Trq_1.y $maxTorque -1 AbsRamp [expr int($rampTime * 1000)]
set t0 [DVARead Time]
roll_over_check $t0 $minLateralForce $timeout $sampleTime

StopSim
WaitForStatus idle
DVAReleaseQuants

Log "   ----> Sim $testRun done! – saved data to: $resultFile"