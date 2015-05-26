clear all; close all;

% Load Images
trainPath = '../data/imgData_train.mat';
testPath = '../data/imgData_test.mat';

load(trainPath);
imgData_train = imgData;
load(testPath);
imgData_test = imgData;
clear imgData;

% Parameter Initialization
POS = 1; NEG = 0;
Nvisible = 28*28;
Nhidden = 16;


% Components Construction
affineConvert = @(x) NEG+x*(POS-NEG);
visibleVec = zeros(Nvisible, 1);
hiddenVec = zeros(Nhidden, 1);
weights = normrnd(0, Nvisible^(-0.5), Nvisible, Nhidden);
% weights = zeros(Nvisible, Nhidden);

% Training
eta = 1e-3;
NIter = 1e6;
num = 3;
grad = zeros(size(weights));
figure();
for ii = 1:NIter
    num = randi([0 9]);
    if mod(ii, floor(NIter/1000)) == 0
        weightsVisualize(weights, 4, 4);
%         fprintf('updeate...\n');
        drawnow;
    end
    data = imgData_train{num+1}{ randi( [1 length(imgData_train{num+1})] ) };
    visibleVec = affineConvert(data(:));
    hiddenActProbs = 1 ./ ( 1 + exp(-weights' * visibleVec) );
%     for jj = 1:1:Nvisible
%         for kk = 1:Nhidden
%             if visibleVec(jj) == 1 grad(jj, kk) = POS*POS*hiddenActProbs(kk) + POS*NEG*(1 - hiddenActProbs(kk));
%             else grad(jj, kk) = NEG*POS*hiddenActProbs(kk) + NEG*NEG*(1 - hiddenActProbs(kk)); end
%         end
%     end
    hiddenVec = affineConvert( getBernoulliTrial(hiddenActProbs) );
    
    weights = weights + eta * visibleVec * hiddenVec';
    
    visibleActProbs = 1 ./ ( 1 + exp(-weights * hiddenVec) );
%     for jj = 1:1:Nvisible
%         for kk = 1:Nhidden
%             if hiddenVec(kk) == 1 grad(jj, kk) = grad(jj, kk) - ( POS*POS*visibleActProbs(jj) + POS*NEG*(1 - visibleActProbs(jj)) );
%             else grad(jj, kk) = grad(jj, kk) - ( NEG*POS*visibleActProbs(jj) + NEG*NEG*(1 - visibleActProbs(jj)) ); end
%         end
%     end
%     weights = weights + eta*grad;

    visibleVec = affineConvert( getBernoulliTrial(visibleActProbs) );
    weights = weights - eta * visibleVec * hiddenVec';
end
