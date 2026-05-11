function []= create_bus_controls()

    elem(1) = Simulink.BusElement;
    elem(1).Name = 'u_camber_FL';
    elem(1).DataType = 'double';
    
    elem(2) = Simulink.BusElement;
    elem(2).Name = 'u_camber_FR';
    elem(2).DataType = 'double';
    
    elem(3) = Simulink.BusElement;
    elem(3).Name = 'u_camber_RL';
    elem(3).DataType = 'double';

    elem(4) = Simulink.BusElement;
    elem(4).Name = 'u_camber_RR';
    elem(4).DataType = 'double';
    
    controls = Simulink.Bus;
    controls.Elements = elem;

    assignin('base',"controls",controls);

end