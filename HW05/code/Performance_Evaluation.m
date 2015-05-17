clear all; close all;

path = '../../HW04/code/Hw4_LinFilt_perfect.mat';
load(path);

dataDir = '../data';

if exist('./imgData.mat', 'file') == 0

% Find all files
imgData = cell(10, 1);
for ii = 0:9
    fprintf('Read digit %d...\n', ii);
    files = dir( fullfile([dataDir '/' num2str(ii) '_test'], 'digit*') );
    imgData{ii+1} = cell(length(files), 1);
    for jj = 1:length(files)
        path = fullfile([dataDir '/' num2str(ii) '_test'], files(jj).name);
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

% Performance Evaluation
falsePrediction = cell(10, 10);
for ii = 1:10
    for jj = 1:10
        falsePrediction{ii, jj} = zeros(size(imgData{1}{1}));
    end
end

perfVec = zeros(10);
confusion = zeros(10);
cnt = 0;
for num = 0:9
    for ii = 1:length(imgData{num+1})
        data = imresize( imgData{num+1}{ii}, 1/dsRate );
        if opt == 0
            outputs = weights' * (data(:)-.5);
        else
            outputs = 1./(1+exp(-weights'*(data(:)-.5)));
        end
        [~, idx] = max(outputs);
        perfVec(:, num+1) = perfVec(:, num+1) + outputs;
        confusion(num+1, idx) = confusion(num+1, idx) + 1;
        if idx ~= num+1
            falsePrediction{num+1, idx} = falsePrediction{num+1, idx} + data;
        end
        cnt = cnt + 1;
    end
    fprintf('Evaluate performance %d %%...\n', 10*(num+1));
end
perfVec = perfVec / cnt * 10;
confusion = confusion / cnt * 10;

clear num ii data idx outputs;

for ii = 1:2
    figure();
    for jj = 1:5
        subplot(5, 1, jj);
        bar((0:9)', perfVec(:, 5*(ii-1)+jj));
        xlabel(['Average response of digit ''' num2str(5*(ii-1)+jj-1) '''']);
    end
end

clear ii jj cnt data;

fig_handle = figure();
imagesc(confusion');
str = sprintf('Average accuracy: %.2f %%\n', 100*mean(diag(confusion)));
title(str);
colorbar;
axis_handle = get(fig_handle, 'CurrentAxes');
set(axis_handle, 'XTick', 1:10)
set(axis_handle, 'XTickLabel', 0:9)
set(axis_handle, 'YTick', 1:10)
set(axis_handle, 'YTickLabel', 0:9)

axis square;

clear str fig_handle axis_handle ans;

for ii = 1:10
    for jj = 1:10
        if ii ~= jj && confusion(ii, jj) > 0
            falsePrediction{ii, jj} = falsePrediction{ii, jj} / (confusion(ii, jj)*200);
        end
    end
end

figure();
for num = 0:9
    subplot(3, 4, num+1);
    imagesc( reshape( weights(:, num+1), sqrt(inputDimension)*[1 1] ) );
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    xlabel(['''' num2str(num) '''']);
    colormap(1-gray(256));
    colorbar;
    axis square
end

for num = 0:9
    figure();
    for ii = 1:10
        if ii ~= num+1
            subplot(1, 10, ii);
            imagesc(falsePrediction{num+1, ii});
            set(gca, 'XTickLabel', []);
            set(gca, 'YTickLabel', []);
            xlabel(['false prediction to ' '''' num2str(ii-1) '''']);
            colormap(gray(256));
            axis square;
        end
    end
end

for ii = 1:10
    fprintf('''%d'' & ', ii-1);
    for jj = 1:10
        if ii == jj fprintf('{\\bf '); end
        if ii == jj fprintf('%.3f', confusion(ii, jj));
        else fprintf('%.3f ', confusion(ii, jj)); end
        if ii == jj fprintf('} '); end
        if jj == 10 fprintf('\\\\ \n \\hline \n');
        else fprintf('& '); end
    end
end

clear ii jj;
