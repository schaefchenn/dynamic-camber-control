clc; clear;

addpath(fullfile("skc"))

filename = 'DoubleWishbone_Front.skc';

% Datei als Text lesen
txt = fileread(filename);

% Abschnitt mit den numerischen Daten finden
expr = 'SuspF\.Kin\.0\.L\.Data:[\s\S]*?(?=#INFOFILE1|$)';
section = regexp(txt, expr, 'match', 'once');

% Alle Zeilen mit Zahlen extrahieren
numLines = regexp(section, '^\s*\d+\s+\d+.*$', 'match', 'lineanchors');

% In numerisches Array umwandeln
data = cellfun(@(l) str2num(l), numLines, 'UniformOutput', false);
data = vertcat(data{:});

% Beispiel: Spaltennamen auslesen
headerExpr = 'SuspF\.Kin\.0\.L\.Data\.Name\s*=\s*(.*)';
headerLine = regexp(txt, headerExpr, 'tokens', 'once');
if ~isempty(headerLine)
    vars = strsplit(strtrim(headerLine{1}));
else
    vars = {};
end
