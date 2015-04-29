clear all; close all;

dataDir = '../data';
resultDir = '../result';

if exist('./imgData.mat', 'file') == 0

% Find all files
imgData = cell(10, 1);
for ii = 0:9
    fprintf('Read digit %d...\n', ii);
    files = dir( fullfile([dataDir '/' num2str(ii) '_train'], 'digit*') );
    imgData{ii+1} = cell(length(files), 1);
    for jj = 1:length(files)
        path = fullfile([dataDir '/' num2str(ii) '_train'], files(jj).name);
        data = double( imread(path) );
        data = data / max(max(data));
        imgData{ii+1}{jj} = data;
    end
end
save('imgData', 'imgData')
clear ii jj files path data dataDir resultDir;

else

load imgData.mat;

end

% Parameters Initialization
imgWidth = length(imgData{1}{1});
dsRate = 1;

% Construct the filter
inputDimension = round(imgWidth/dsRate)^2;
weights = zeros(inputDimension, 10);

% for num = 0:9
%     fprintf('Process digit %d...\n', num);
%     digits = zeros(inputDimension, length(imgData{num+1}));
%     for ii = 1:length(imgData{num+1})
%         data = imresize( imgData{num+1}{ii}, 1/dsRate );
%         digits(:, ii) = data(:)-.5;
%     end
%     digits = mean(digits, 2);
%     weights(:, num+1) = digits/length(digits);
%     imagesc( reshape( mean(digits, 2), imgWidth/dsRate*[1 1] ) );
%     colormap(gray(256));
%     drawnow;
% end


save('Hw4_LinFilt.mat');