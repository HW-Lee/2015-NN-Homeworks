% EE6530 Neural Nets 1st Computer homework
% Linear binary decision
% Feb. 4, 2015
% Yi-Wen Liu

% Below is the data generator
clear; close all;

% DestDir = '/Users/jacobliu/Desktop/NN/';
DestDir = './';

w = [0.4 -0.3 -0.7 0.8]; w = w(:);

M = length(w);
N = 10000;
data = rand(N,M); % Each row presents a "case"

z = data*w;

y = sortrows([z data],1);


class0 = y(1:N/2, 2:end);
ind = randperm(N/2);
class0 = class0(ind,:);


class1 = y(N/2+1:end, 2:end);
ind = randperm(N/2);
class1 = class1(ind,:);

save([DestDir 'Hw1data'], 'class0','class1'); 