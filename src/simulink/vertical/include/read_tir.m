function TIR = read_tir(filename)

lines = readlines(filename);
TIR = struct();

for i = 1:length(lines)
    line = strtrim(lines(i));

    % Kommentare und leere Zeilen überspringen
    if startsWith(line,"#") || line == ""
        continue
    end

    % Nur Zeilen mit "=" auswerten
    if contains(line,"=")
        parts = split(line,"=");
        key = strtrim(parts(1));
        value = strtrim(parts(2));

        % Kommentare am Ende entfernen
        value = split(value,["#","$"]);
        value = strtrim(value(1));

        % Versuchen in Zahl umzuwandeln
        numVal = str2double(value);

        % Nur numerische Werte berücksichtigen
        if isnan(numVal)
            continue   % überspringe Nicht-Zahlen (Strings)
        end
        
        value = numVal;

        % Punktnotation in Struktur wandeln
        keyParts = split(key,".");
        if length(keyParts) == 2
            section = matlab.lang.makeValidName(keyParts(1));
            field   = matlab.lang.makeValidName(keyParts(2));
            TIR.(section).(field) = value;
        else
            field = matlab.lang.makeValidName(key);
            TIR.(field) = value;
        end
    end
end