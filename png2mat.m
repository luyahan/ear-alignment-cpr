%% Reads images and saves them to .mat format

dir_name = 'piotr-cpr/set358_ucna/';
fnames = dir([dir_name, '*.png']);
numfids = length(fnames);
% numfids = numfids - 2;
image_dir = 'piotr-cpr/set358_orig/';
result = zeros(100, 100, 90);

for i = 1:numfids
  file_name_index = size(fnames(i).name,2);
  file_name = fnames(i).name(1:file_name_index);
  file_name = [dir_name, file_name];
%   file_name = [image_dir,fnames(i).name];
  Im = imread(file_name);
  result(:,:,i) = Im;
  fclose('all');
end
save('set358_ucna_images.mat', 'result')