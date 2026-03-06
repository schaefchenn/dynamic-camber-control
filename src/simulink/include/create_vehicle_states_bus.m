function []= create_vehicle_states_bus()

    elem(1) = Simulink.BusElement;
    elem(1).Name = 'ax';
    elem(1).DataType = 'double';
    
    elem(2) = Simulink.BusElement;
    elem(2).Name = 'ay';
    elem(2).DataType = 'double';
    
    elem(3) = Simulink.BusElement;
    elem(3).Name = 'v';
    elem(3).DataType = 'double';

    elem(4) = Simulink.BusElement;
    elem(4).Name = 'yaw_rate';
    elem(4).DataType = 'double';

    elem(5) = Simulink.BusElement;
    elem(5).Name = 'side_slip_angle';
    elem(5).DataType = 'double';

    elem(6) = Simulink.BusElement;
    elem(6).Name = 'delta_FL';
    elem(6).DataType = 'double';

    elem(7) = Simulink.BusElement;
    elem(7).Name = 'delta_FR';
    elem(7).DataType = 'double';

    elem(8) = Simulink.BusElement;
    elem(8).Name = 'delta_RL';
    elem(8).DataType = 'double';

    elem(9) = Simulink.BusElement;
    elem(9).Name = 'delta_RR';
    elem(9).DataType = 'double';

    elem(10) = Simulink.BusElement;
    elem(10).Name = 'omega_FL';
    elem(10).DataType = 'double';

    elem(11) = Simulink.BusElement;
    elem(11).Name = 'omega_FR';
    elem(11).DataType = 'double';

    elem(12) = Simulink.BusElement;
    elem(12).Name = 'omega_RL';
    elem(12).DataType = 'double';

    elem(13) = Simulink.BusElement;
    elem(13).Name = 'omega_RR';
    elem(13).DataType = 'double';

    elem(14) = Simulink.BusElement;
    elem(14).Name = 'is_transient';
    elem(14).DataType = 'boolean';

    elem(15) = Simulink.BusElement;
    elem(15).Name = 'camber_FL';
    elem(15).DataType = 'double';

    elem(16) = Simulink.BusElement;
    elem(16).Name = 'camber_FR';
    elem(16).DataType = 'double';

    elem(17) = Simulink.BusElement;
    elem(17).Name = 'camber_RL';
    elem(17).DataType = 'double';

    elem(18) = Simulink.BusElement;
    elem(18).Name = 'camber_RR';
    elem(18).DataType = 'double';
    
    vehicleStates = Simulink.Bus;
    vehicleStates.Elements = elem;

    assignin('base',"vehicle_states",vehicleStates);

end