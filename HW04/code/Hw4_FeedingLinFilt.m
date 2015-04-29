clear all; close all;
load Hw4_LinFilt.mat;

eta = 1e-4;
opt = 1; % 0: linfilt, 1: sigmoid

trainRange = 700;
ansVec = zeros(10, 1);
NIter = 1e4;
for ii = 1:NIter

    if mod(ii, floor(NIter/100)) == 0
        fprintf('Training %d %%...\n', floor(ii*100/NIter));
    end
    numArr = randperm(10)-1;
    for jj = 1:10
        num = numArr(jj);
        ansVec(num+1) = 1;
        data = imresize( imgData{num+1}{randi([1 trainRange], 1)}, 1/dsRate );
        if opt == 0
            outputs = weights' * (data(:)-.5);
        else
            outputs = 1./(1+exp(-weights'*(data(:)-.5)));
        end
        e = ansVec - outputs;
        if opt == 0
            weights = weights + eta * (data(:)-.5) * e';
        else
            weights = weights + eta * (data(:)-.5) * (e .* outputs .* (1-outputs))';
        end
        ansVec(num+1) = 0;
    end

end

clear ii num ansVec data err1 err2 decErr outputs e;

save('Hw4_LinFilt.mat');