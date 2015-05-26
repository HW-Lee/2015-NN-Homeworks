clear all; close all;

path = '../data/RBM_digits.mat';

load(path);

clear ii NIter eta testPath trainPath Nhidden hiddenVec visibleVec;

Nsamples = 80;
nums = unique( ...
[
    0, ... 
%     1, ... 
%     2, ... 
    3, ...
%     4, ...
%     5, ...
%     6, ...
%     7, ...
%     8, ...
%     9
]);

% Generating
NIter = 100;
spRow = round( sqrt(Nsamples*length(nums)/2)/length(nums) ) * length(nums);
spCol = ceil(Nsamples*length(nums) / spRow);
visibleVec = zeros(size(weights, 1), 1);
avgVec = visibleVec;
hiddenVec = zeros(size(weights, 2), 1);

allData = zeros(size(weights, 1), Nsamples*length(nums));

figure();
for numIdx = 1:length(nums)
    num = nums(numIdx);
    sampleIdxes = randperm( length(imgData_test{num+1}) );
    sampleIdxes = sampleIdxes(1:Nsamples);
    for ii = 1:Nsamples
        sampleIdx = sampleIdxes(ii);
        data = imgData_test{num+1}{sampleIdx};
        visibleVec = data(:);
        allData(:, (numIdx-1)*Nsamples + ii) = visibleVec;
        avgVec = visibleVec/NIter;
        for jj = 1:NIter
            p = 1 ./ (1 + exp( -weights' * visibleVec ));
            hiddenVec = getBernoulliTrial(p);
            p = 1 ./ (1 + exp( -weights * hiddenVec ));
            visibleVec = getBernoulliTrial(p);
            avgVec = avgVec + visibleVec/NIter;
%             visibleVec = data(:);
        end
        subplot(spRow, spCol, (numIdx-1)*(spRow/length(nums))*spCol + ii);
        imagesc( reshape(avgVec, sqrt(length(avgVec))*[1 1]) );
        colormap(gray(256));
        set(gca, 'XTick', []); set(gca, 'YTick', []);
        axis square;
        drawnow;
    end
end

clear numIdx ii jj data sampleIdxes sampleIdx num avgVec visibleVec hiddenVec;

figure();
for ii = 1:size(allData, 2)
    numIdx = ceil(ii/Nsamples);
    subplot(spRow, spCol, (numIdx-1)*(spRow/length(nums))*spCol + mod(ii-1, Nsamples)+1);
    imagesc( reshape(allData(:, ii), sqrt(size(allData, 1))*[1 1]) );
    colormap(gray(256));
    set(gca, 'XTick', []); set(gca, 'YTick', []);
    axis square;
    drawnow;
end

clear ii numIdx;
