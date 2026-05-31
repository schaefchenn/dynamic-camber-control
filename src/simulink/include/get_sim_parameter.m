function [] = get_sim_parameter(model, vehicle)
    mdlWks = get_param(model, "ModelWorkspace");
    entries = fieldnames(vehicle);

    for i = 1:numel(entries)
        entryName = entries{i};
        entry = vehicle.(entryName);

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
end

