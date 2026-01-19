function data = read_json(filePath)
    if ~isfile(filePath)
        error('Datei nicht gefunden: %s', filePath);
    end
    txt = fileread(filePath);
    data = jsondecode(txt);
end