function [] = get_sim_parameter(model, vehicle, tyre)
    mdlWks = get_param(model, "ModelWorkspace");
    entries = fieldnames(vehicle.parameters);
    entries2 = fieldnames(tyre.parameters);

    for i = 1:numel(entries)
        entryName = entries{i};
        entry = vehicle.parameters.(entryName);

        % Simulink.Parameter erzeugen
        p = Simulink.Parameter;
        p.Value    = entry.value;
        p.DataType = entry.datatype;

        % Einheit optional setzen
        if isfield(entry, "unit")
            p.Unit = entry.unit;
        end

        % Im Model Workspace verfügbar machen
        assignin(mdlWks, entryName, p);
    end

    for i = 1:numel(entries2)
        entry2Name = entries2{i};
        entry2 = tyre.parameters.(entry2Name);

        % Simulink.Parameter erzeugen
        p2 = Simulink.Parameter;
        p2.Value    = entry2.value;
        p2.DataType = entry2.datatype;

        % Einheit optional setzen
        if isfield(entry2, "unit")
            p2.Unit = entry2.unit;
        end

        % Im Model Workspace verfügbar machen
        assignin(mdlWks, entry2Name, p2);
    end
end

