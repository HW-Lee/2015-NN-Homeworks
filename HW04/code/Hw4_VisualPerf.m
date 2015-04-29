clear all; close all;
path = 'Hw4_LinFilt_perfect.mat';
% path = 'Hw4_LinFilt.mat';
load(path);

% Performance Evaluation
perfVec = zeros(10);
confusion = zeros(10);
cnt = 0;
for num = 0:9
    for ii = trainRange+1:800
        data = imresize( imgData{num+1}{ii}, 1/dsRate );
        if opt == 0
            outputs = weights' * (data(:)-.5);
        else
            outputs = 1./(1+exp(-weights'*(data(:)-.5)));
        end
        [~, idx] = max(outputs);
        perfVec(:, num+1) = perfVec(:, num+1) + outputs;
        confusion(num+1, idx) = confusion(num+1, idx) + 1;
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

for ii = 1:10
    fprintf('''%d'' & ', ii-1);
    for jj = 1:10
        if ii == jj fprintf('{\\bf '); end
        if jj < 10 fprintf('%.2f ', confusion(ii, jj));
        else fprintf('%.2f ', confusion(ii, jj)); end
        if ii == jj fprintf('} '); end
        if jj == 10 fprintf('\\\\ \n \\hline \n');
        else fprintf('& '); end
    end
end

clear ii jj;

save(path);