clear all; close all;

srcDir = './lib_nN*';
allDir = dir(srcDir);

errors = cell(length(allDir), 1);
names = cell(length(allDir), 1);
weights = cell(length(allDir), 1);

for ii = 1:length(allDir)
    files = dir( fullfile(allDir(ii).name, 'lib*') );
    names{ii} = allDir(ii).name;
    error = zeros(length(files), 800);
    weight = cell(length(files), 2);
    for jj = 1:length(files)
        data = load( fullfile(allDir(ii).name, files(jj).name) );
        
        w = data.net.getLayerAt(1).getWeights();
        [~, idx] = sort(w(1, :) ./ w(2, :));
        ww = zeros(size(w));
        for kk = 1:length(idx)
            ww(:, kk) = w(:, idx(kk));
        end
        weight{jj, 1} = ww;
        w = data.net.getLayerAt(2).getWeights();
        ww = zeros(size(w));
        for kk = 1:length(w)
            ww(idx(kk)) = w(kk);
        end
        weight{jj, 2} = ww;
        
        error(jj, :) = data.error';
    end
    errors{ii} = error;
    weights{ii} = weight;
end

for ii = 1:length(weights)
    weight = weights{ii};
    ww = zeros([size(weight{1, 1}) size(weight, 1)]);
    kk = zeros([size(weight{1, 2}) size(weight, 1)]);
    for jj = 1:size(weight, 1)
        ww(:, :, jj) = weight{jj, 1};
        kk(:, :, jj) = weight{jj, 2};
    end
    weights{ii} = cell(2, 1);
    weights{ii}{1} = ww;
    weights{ii}{2} = kk;
end

for ii = 1:length(weights)
    fprintf([names{ii} ':\n']);
    display( mean(weights{ii}{1}, 3) );
    display( std(weights{ii}{1}, 0, 3) );
    display( mean(weights{ii}{2}, 3) );
    display( std(weights{ii}{2}, 0, 3) );
end

clear ii jj kk error data files weight w ww idx;