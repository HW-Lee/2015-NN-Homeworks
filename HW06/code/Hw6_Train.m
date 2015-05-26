clear all; close all;

numSel = -1;
if numSel ~= -1 path = ['../data/RBM_digit' num2str(numSel) '.mat'];
else path = '../data/RBM_digits.mat'; end

load(path);

eta = 1e-1;
num = numSel;
NIter = 1e5;
figure();
for ii = 1:NIter
    if numSel == -1 num = mod(ii, 10); end
    if mod(ii, floor(NIter/100)) == 0
        fprintf('%d %%...\n', round(ii*100/NIter));
        weightsVisualize(weights, 5, 10);
        drawnow;
    end
    data = imgData_train{num+1}{ randi( [1 length(imgData_train{num+1})] ) };
    visibleVec = affineConvert(data(:));
    hiddenActProbs = 1 ./ ( 1 + exp(-weights' * visibleVec) );
    hiddenVec = affineConvert( getBernoulliTrial(hiddenActProbs) );
    
    weights = weights + eta * (visibleVec==POS) * (hiddenVec==POS)';
    
    visibleActProbs = 1 ./ ( 1 + exp(-weights * hiddenVec) );
    visibleVec = affineConvert( getBernoulliTrial(visibleActProbs) );
    
    weights = weights - eta * (visibleVec==POS) * (hiddenVec==POS)';
end

clear data grad hiddenActProbs ii num visibleActProbs;

save(path);
