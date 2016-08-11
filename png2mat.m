dir_name = 'piotr-cpr/anontations1/';
fnames = dir([dir_name, '*.txt']);
numfids = length(fnames);
% numfids = numfids - 2;
image_dir = 'piotr-cpr/cprImages/';
result = zeros(100, 100, 103);

for i = 1:numfids
  file_name_index = size(fnames(i).name,2)-8;
  file_name = fnames(i).name(1:file_name_index);
  file_name = [image_dir, file_name, '.png'];
%   file_name = [image_dir,fnames(i).name];
  Im = imread(file_name);
  result(:,:,i) = Im;
  fclose('all');
end
save('test_ears.mat', 'result')