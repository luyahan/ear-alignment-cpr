dir_name = 'piotr-cpr/set254_orig_annotations/';
fnames = dir([dir_name, '*.txt']);
numfids = length(fnames);
% numfids = numfids - 2;

result = zeros(numfids, 5);

for i = 1:numfids
  file_name = [dir_name,fnames(i).name];
  A = textscan(fopen(file_name), '%s');
  for k = 1:5
      index = 4 + k;
      result(i,k) = str2double(A{1}{index}); 
  end
  fclose('all');
end
save('set254_orig_annotations.mat', 'result')