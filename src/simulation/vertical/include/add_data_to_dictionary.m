function add_data_to_dictionary(section, data)
    fields = fieldnames(data);
    
    for i = 1:numel(fields)
        fieldName = fields{i};
        fieldData = data.(fieldName);
    
        if isstruct(fieldData) && isfield(fieldData, 'is_bus')
    
            if fieldData.is_bus
                subFields = fieldnames(fieldData);
                elems = [];

                for j = 1:numel(subFields)
                    subName = subFields{j};
                    if isstruct(fieldData.(subName)) && isfield(fieldData.(subName), 'value')
                        elem = Simulink.BusElement;
                        elem.Name = subName;
                        elem.DataType = fieldData.(subName).data_type;
                        if isfield(fieldData.(subName), 'unit')
                            elem.Unit = fieldData.(subName).unit;
                        end
                        elems = [elems; elem];
                    end
                end

                busObj = Simulink.Bus;
                busObj.Elements = elems;

                try
                    addEntry(section, fieldData.bus_name, busObj);
                catch
                    entry = getEntry(section, fieldData.bus_name);
                    setValue(entry, busObj);
                end
                
            end
        end

        if isstruct(fieldData) && isfield(fieldData, 'value')
            param = Simulink.Parameter(fieldData.value);
    
            if isfield(fieldData, 'unit')
                param.Unit = fieldData.unit;
            end
    
            if isfield(fieldData, 'data_type')
                param.DataType = fieldData.data_type;
            end
    
            try
                entry = getEntry(section, fieldName);
                setValue(entry, param);
            catch
                addEntry(section, fieldName, param);
            end
    
        end

        if isstruct(fieldData) && isfield(fieldData, 'is_section')
            if fieldData.is_section
                subStruct = fieldData;
                add_data_to_dictionary(section, subStruct)
            end
        end
    end
end