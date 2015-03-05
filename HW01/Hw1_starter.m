% EE6530 Neural Nets Hw1 solution attempt
% Topic: Linear binary decision
% 
% Yi-Wen Liu
% Feb. 4, 2015
clear; close all

SourceDir = './'; % replace with your source directory
load([SourceDir 'Hw1data.mat'],'class0','class1');

M = size(class0,2); % data dimension
N = size(class0,1);
class0 = [class0 zeros(N,1)]; % append labels in the last column
class1 = [class1 ones(N,1)];
Alldata = [class0; class1];
ind = randperm(2*N);
Alldata = Alldata(ind,:);

% Weights and bias initialization.
w = zeros(M,1);
b = 0; % bias
N = size(Alldata,1);
mu = mean(Alldata(:,1:M));
K = 10; % # repeated re-use of data
for kk = 1:K
    for n = 1:N
        data = Alldata(n,1:M);
        label = Alldata(n,end);
        %% Implement rules for updating the weight vector w and the bias b
        %
        if  %blahblahblah
            ...
        elseif %blahblahblah
            ...
        end
        %%%%%%%%%%%%%%%
    end
    
end
% calculating the perceptron output for all data
z0 = class0(:,1:4)*w+b;
z1 = class1(:,1:4)*w+b;
figure(1)
subplot(211); hist(z0, 50); hold on
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r','EdgeColor','w')
set(gca,'xlim',[-50 50])

subplot(212);
hist(z1, 50);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','b','EdgeColor','w')
set(gca,'xlim',[-50 50])

fprintf('Class 0 output ranges from %f to %f\n',min(z0),max(z0));
fprintf('Class 1 output ranges from %f to %f\n',min(z1),max(z1));
