clear all; close all;

path = '../data/RBM_digits.mat';

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
Nhidden = 450;


% Components Construction
affineConvert = @(x) NEG+x*(POS-NEG);
visibleVec = zeros(Nvisible, 1);
hiddenVec = zeros(Nhidden, 1);
weights = normrnd(0, Nvisible^(-1), Nvisible, Nhidden);

save(path);
