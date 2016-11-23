function getOriginalDatabaseFromAllignedDb(dbPath, orgPath, resPath)
    dir_name = dbPath;
    res_dir_name = resPath;
    org_dir_name = orgPath;
    dirContntent = dir(dir_name);
    numDirs = length(dirContntent);
    
    for i = 4:numDirs
        if(dirContntent(i).isdir == 1)
            file_name_index = size(dirContntent(i).name,2);
            file_name = dirContntent(i).name(1:file_name_index);
            inside_dir_name = [dir_name,'/',file_name,'/'];
            result_dir_name = [res_dir_name,'/',file_name,'/'];
            original_dir_name = [org_dir_name,'/',file_name,'/'];
            
            inside_dir_content = dir([inside_dir_name, '*.png']);
            inside_dir_size = length(inside_dir_content);
            for j = 1:inside_dir_size
                if ~exist(result_dir_name, 'dir')
                    % Folder does not exist so create it.
                    mkdir(result_dir_name);
                end
                
                % take picture from original db and save it to the resultDb
                I = imread([original_dir_name, inside_dir_content(j).name]);
                imwrite(I, [result_dir_name, inside_dir_content(j).name]);
            end
        end
    end
end