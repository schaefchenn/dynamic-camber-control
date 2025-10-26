function assign_vehicle_params(model, vehicleData)
    sv   = double(vehicleData.dimensions.track_width_front_mm);
    sh   = double(vehicleData.dimensions.track_width_rear_mm);
    l    = double(vehicleData.dimensions.wheelbase_mm);
    lnzv = double(vehicleData.vertical_parameters.distance_to_pitch_center_front_mm);
    

    mw = get_param(model,'ModelWorkspace');
    
    mw.assignin('sv', sv);
    mw.assignin('sh', sh);
    mw.assignin('l', l);
    mw.assignin('lnzv', lnzv);