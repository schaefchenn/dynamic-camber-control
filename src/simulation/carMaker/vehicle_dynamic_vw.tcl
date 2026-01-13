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

# --- Hilfsprozedur für Testruns ----------------------------------------------

proc RunTest {name} {

    # Datum und Zeit
    set day [clock format [clock seconds] -format "%d_%m_%Y"]
    set timestamp [clock format [clock seconds] -format "%H-%M-%S"]

    # Ordner für Tag und TestRun erstellen
    set dayFolder [file join "SimOutput" "Data" $day]
    file mkdir $dayFolder

    set testRunFolder [file join $dayFolder $name]
    file mkdir $testRunFolder

    # Ergebnisdatei setzen
    set resultFile [file join $testRunFolder "${timestamp}.erg"]
    SetResultFName $resultFile

    Log "* Run $name"

    # Simulation starten
    LoadTestRun $name
    StartSim
    WaitForStatus running
    WaitForStatus idle

    Log "   ----> Sim $name done! – saved data to: $resultFile"
}


# --- Testläufe ---------------------------------------------------------------

RunTest "const_vel80_vw"
RunTest "stat_circle80_vw"
RunTest "acceleration_to80_vw"
RunTest "decceleration_from80_vw"
