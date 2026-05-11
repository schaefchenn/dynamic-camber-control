function [file,path] = select_file_from_ui(start_dir, file_extension, message)

    [file, path] = uigetfile(start_dir, file_extension, message);
    
    if isequal(file, 0)
        disp('No file selected.');
        return;
    end

end

