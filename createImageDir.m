function createImageDir(input_dir, result_dir)

%% Description
% Script reads directory and convert images from n directories in one dir
% example:
%           001/01.png
%           ...
%           001/10.png
%           002/01.png
% result:
%            results/01.png
%            results/02.png
%            results/03.png
%            ...
%            results/11.png

%% Implementation
% get dir content
dir_name = dir(input_dir);
fnames = dir_name;
% fnames = dir([dir_name, '*.png']);
numfids = length(dir_name);
index = 1;

%iterate over all dirs
for i = 3:numfids
  file_name_index = size(fnames(i).name,2);
  file_name = fnames(i).name(1:file_name_index);
  file_name = [input_dir, file_name, '/'];
  dir_content = dir(file_name);
  
  %iterate over all files in dir
  for j = 3:size(dir_content,1)
      % construct path+name for saving
      if(strcmp(dir_content(j).name,'.DS_Store'))
          continue;
      end
      Im = imread([file_name,dir_content(j).name]);
      path = [result_dir,int2str(index),'.png'];
      if size(Im, 3) > 1
        Im = rgb2gray(Im);
      end
      imwrite(Im, path);
      index = index + 1;
  end
  fclose('all');
end

