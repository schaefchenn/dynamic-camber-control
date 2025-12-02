function set_springDeflection_bus()
    elems(1) = Simulink.BusElement;
    elems(1).Name = 'springDeflection_FL';
    elems(1).Dimensions = 1;
    elems(1).DataType = 'double';
    elems(1).Unit = 'mm';
    
    elems(2) = Simulink.BusElement;
    elems(2).Name = 'springDeflection_FR';
    elems(2).Dimensions = 1;
    elems(2).DataType = 'double';
    elems(2).Unit = 'mm';

    elems(3) = Simulink.BusElement;
    elems(3).Name = 'springDeflection_RL';
    elems(3).Dimensions = 1;
    elems(3).DataType = 'double';
    elems(3).Unit = 'mm';

    elems(4) = Simulink.BusElement;
    elems(4).Name = 'springDeflection_RR';
    elems(4).Dimensions = 1;
    elems(4).DataType = 'double';
    elems(4).Unit = 'mm';
    
    BusSpringDeflection = Simulink.Bus;
    BusSpringDeflection.Elements = elems;

    assignin('base', 'BusSpringDeflection', BusSpringDeflection);

    