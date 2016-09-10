function bmpToJpg(dirName, trainDir)
%% select random images from directory (database) and creating learning(random) dataset
% dirName: path of database
% trainDir: dir where train images are stored from 1 to n 
% testDir: images which are not in trainDir

% usage : selectRandomImagesForLearningSet('piotr-cpr/databases/ustb2', 'ucnaUstbTEST/', 'testnaUstbTEST/');


%% count number of files inside dir
    dir_name = dirName;
    dirContntent = dir(dir_name);
%     fnames = dir([dir_name, '*.png']);
    numfids = length(dirContntent);
    result = zeros(100,100,size(randomArray, 2));
    index = 1;

    testIndex = 1;
    for i = 3:numfids
        if(dirContntent(i).isdir == 1)
            % set name of dir
            file_name_index = size(dirContntent(i).name,2);
            file_name = dirContntent(i).name(1:file_name_index);
            inside_dir_name = [dir_name,'/',file_name,'/'];
            inside_dir_content = dir([inside_dir_name, '*.BMP']);
            inside_dir_size = length(inside_dir_content);
            % read content of the dir
            for j = 1:inside_dir_size
                file_name = [inside_dir_name,inside_dir_content(j).name];
                I = imread(file_name);
                if(size(I, 3) == 3 )
                    I = rgb2gray(I);
                end
                I = imresize(I, [100 100]);

                save_path = file_name(length(dirName)+2:end);
                folder = inside_dir_name(length(dirName)+2:end);
                if ~exist([testDir,folder], 'dir')
                    % Folder does not exist so create it.
                    mkdir([testDir,folder]);
                end
                %TODO SAVE TO .MAT
                imwrite(I, [testDir, save_path]);
                result(:,:,testIndex) = I;
                testIndex = testIndex + 1;
                
                index = index + 1;
            end
        end
    end
    save('testnaMnozica.mat', 'result');