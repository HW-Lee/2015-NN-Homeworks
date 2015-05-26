clear all; close all;

pathArr = ...
{
    '../data/RBM_digit0.mat', ...
    '../data/RBM_digit1.mat', ...
    '../data/RBM_digit2.mat', ...
    '../data/RBM_digit3.mat', ...
    '../data/RBM_digit4.mat', ...
    '../data/RBM_digit5.mat', ...
    '../data/RBM_digit6.mat', ...
    '../data/RBM_digit7.mat', ...
    '../data/RBM_digit8.mat', ...
    '../data/RBM_digit9.mat', ...
    '../data/RBM_digits.mat'
};

% num = randi([0 9]);
num = 2;

RBMs = cell(length(pathArr), 1);

for ii = 1:length(RBMs)
    load(pathArr{ii});
    RBMs{ii} = weights;
end

clear ii NIter eta testPath trainPath Nhidden hiddenVec visibleVec;

% Testing
hiddenVecs = cell(length(pathArr), 1);
for ii = 1:length(hiddenVecs)
    hiddenVecs{ii} = zeros(size(RBMs{ii}, 2), 1);
end
Ntest = 98;

data = imgData_train{num+1}{ randi([1 length(imgData_train{num+1})]) };
visibleVecs = affineConvert( data(:) ) * ones(1, length(pathArr));

changingVec = zeros(length(data(:)), Ntest);
changingVec(:, 1) = visibleVecs(:, end);
figure();
for ii = 1:Ntest-1
    for jj = 1:length(pathArr)
        subplot(3, 4, jj);
        imagesc( reshape(visibleVecs(:, jj), [28 28]) );
        colormap(gray(256));
        set(gca, 'XTick', []);
        set(gca, 'YTick', []);
        axis square;
        drawnow;
        p = 1 ./ ( 1 + exp( -RBMs{jj}' * visibleVecs(:, jj) ) );
        hiddenVecs{jj} = affineConvert( getBernoulliTrial(p) );
        p = 1 ./ ( 1 + exp( -RBMs{jj} * hiddenVecs{jj} ) );
        visibleVecs(:, jj) = affineConvert( getBernoulliTrial(p) );
    end
    changingVec(:, ii+1) = visibleVecs(:, end);
end

figure();
for ii = 1:Ntest
    subplot(7, 14, ii);
    imagesc( reshape(changingVec(:, ii), [28 28]) );
    colormap(gray(256));
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    axis square;
end

figure();
imagesc( reshape( mean(changingVec(:, 2:end), 2), [28 28] ) );
colormap(gray(256));
set(gca, 'XTick', []);
set(gca, 'YTick', []);
axis square;
