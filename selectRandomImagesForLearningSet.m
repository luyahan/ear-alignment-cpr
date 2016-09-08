function selectRandomImagesForLearningSet(dirName, trainDir, testDir)
%% select random images from directory (database) and creating learning(random) dataset
% dirName: path of directory
% trainDir: dir where train images index.png images are stored from 1 to n 
% testDir: images which are not in trainDir
% sample : selectRandomImagesForLearningSet('piotr-cpr/databases/ustb2', 'ucnaUstbTEST/', 'testnaUstbTEST/');

if ~exist(testDir, 'dir')
    % Folder does not exist so create it.
    mkdir(testDir);
end

if ~exist(trainDir, 'dir')
    % Folder does not exist so create it.
    mkdir(trainDir);
end

%% count number of files inside dir
    dir_name = dirName;
    dirContntent = dir(dir_name);
%     fnames = dir([dir_name, '*.png']);
    numfids = length(dirContntent);
    numberOfFiles = 0;
    
    for i = 4:numfids
        if(dirContntent(i).isdir == 1)
            file_name_index = size(dirContntent(i).name,2);
            file_name = dirContntent(i).name(1:file_name_index);
            inside_dir_name = [dir_name,'/',file_name,'/'];
            inside_dir_content = dir([inside_dir_name, '*.BMP']);
            inside_dir_size = length(inside_dir_content);
            numberOfFiles = numberOfFiles + inside_dir_size;
        end
    end

%% choose random images
    % matrix is 1/3 of number of files
    % create array of random permutation indexes from 1 to randomArray
    randomArray = randperm(numberOfFiles, round(numberOfFiles/3));
    randomArray = sort(randomArray);
%     arrayOfNames = zeros(1, size(randomArray,2));
    result = zeros(100,100,size(randomArray, 2));
    index = 1;
    randomIndex = 1;
    dataIndex = 1;
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
%               % if index is equal as index at randomIndex position in
%               randomArray -> save this image
                if(index == randomArray(randomIndex) && randomIndex < size(randomArray, 2))
                    file_name = [inside_dir_name,inside_dir_content(j).name];
                    % save name to file
                    arrayOfNames{randomIndex} = {file_name};
                    
                    
                    % create resultDir if does not exist
                    if ~exist(trainDir, 'dir')
                        % Folder does not exist so create it.
                        mkdir(trainDir);
                    end
                    % save it to file
                    I = imread(file_name);
                    if(size(I, 3) == 3 )
                        I = rgb2gray(I);
                    end
                    I = imresize(I, [100 100]);
                    imwrite(I, [trainDir,int2str(dataIndex), '.jpg']);
                    % save it to .mat
                    dataIndex = dataIndex + 1;
                    randomIndex = randomIndex + 1;
                % save to testdIR
                else
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
                end
                
                index = index + 1;
            end
        end
    end
    save('testnaMnozica.mat', 'result');