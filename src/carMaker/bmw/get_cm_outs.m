clear; clc;

[file, path] = uigetfile('*.erg', 'Choose your .erg file');
if isequal(file, 0)
    disp('No file selected.');
    return;
end

% run(fullfile(extractBefore(path, 'SimOutput'), 'src_cm4sl', 'cmenv.m'));
data = cmread(fullfile(path, file));
defaultName = strrep(file, '.erg', '.mat');
defaultFull = fullfile(fileparts(mfilename('fullpath')), defaultName);

[saveFileName, savePath] = uiputfile('*.mat', 'Choose name and location for .mat file', defaultFull);
if isequal(saveFileName, 0)
    disp('No save file selected.');
    return;
end

[~, ~, ext] = fileparts(saveFileName);
if isempty(ext)
    saveFileName = [saveFileName '.mat'];
end

fullSavePath = fullfile(savePath, saveFileName);

if exist(fullSavePath, 'file')
    choice = questdlg(['File "' saveFileName '" already exists. Overwrite?'], 'Overwrite?', 'Yes','No','No');
    if ~strcmp(choice, 'Yes')
        disp('Save canceled by user.');
        return;
    end
end

save(fullSavePath, 'data');
disp(['File has been saved to: ' fullSavePath]);
