function add_data_to_dictionary(dd, data)
    fields = fieldnames(data);
    for i = 1:numel(fields)
        fieldName = fields{i};
        fieldData = data.(fieldName);

        if isfield(fieldData, 'is_section') && isfield(fieldData, 'section_name')
            sectionNames = getSectionNames(dd);
            if any(strcmp(sectionNames, fieldData.section_name))
                section = getSection(dd, fieldData.section_name);
            else
                section = addSection(dd, fieldData.section_name);
            end
        else
            sectionNames = getSectionNames(dd);
            if any(strcmp(sectionNames, 'general'))
                section = getSection(dd, 'general');
            else
                section = addSection(dd, 'general');
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

            if exist(section,fieldName)
                entry = getEntry(section, fieldName);
                setValue(entry, param);
            else
                addEntry(section, fieldName, param);
            end

        elseif isstruct(fieldData)
            add_data_to_dictionary(section, fieldData);
        end
    end
end