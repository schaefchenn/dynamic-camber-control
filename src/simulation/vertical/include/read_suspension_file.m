function [data] = read_suspension_file(filename)
    txt = fileread(filename);
    lines = strsplit(txt, '\n')';

    data = struct();
    i = 1;
    
    while i <= numel(lines)
        line = strtrim(lines{i});
    
        % Skip empty or commented lines
        if isempty(line) || startsWith(line, '#')
            i = i + 1;
            continue;
        end
    
        % ---------------------------------------------------------
        % CASE 1: key = value   (with numbers OR strings)
        % ---------------------------------------------------------
        if contains(line, '=')
            parts = split(line, '=');
    
            key = matlab.lang.makeValidName(strtrim(parts{1}));
            rawValue = strtrim(parts{2});
    
            % Split into tokens
            tokens = split(rawValue);
    
            % Try numeric conversion
            numVals = str2double(tokens);
            allNum = ~any(isnan(numVals));
    
            if allNum
                % Pure numeric list
                data.(key) = numVals';
            else
                % STRING values
                % remove empty tokens
                tokens = tokens(tokens ~= "");
                
                if isscalar(tokens)
                    % single string
                    data.(key) = string(tokens{1});
                else
                    % multiple strings -> string array
                    data.(key) = string(tokens)';
                end
            end
    
            i = i + 1;
            continue;
        end
    
        % ---------------------------------------------------------
        % CASE 2: table block "Key:"
        % ---------------------------------------------------------
        if endsWith(line, ':')
            key = matlab.lang.makeValidName(extractBefore(line, ':'));
            tableData = [];
    
            i = i + 1;
    
            while i <= numel(lines)
                row = strtrim(lines{i});
    
                % End of table block?
                if isempty(row) || contains(row, '=') || endsWith(row, ':')
                    break;
                end
    
                % Read numeric row as ROW VECTOR
                nums = sscanf(row, '%f').';
    
                if ~isempty(nums)
                    tableData = [tableData; nums];
                end
    
                i = i + 1;
            end
    
            data.(key) = tableData;
            continue;
        end
    
        i = i + 1;
    end
end