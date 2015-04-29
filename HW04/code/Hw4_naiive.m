% Mean-image method for na?ve hand-written digit recognition
% April 7, 2015
% YWLiu
clear; close all;
DIR = '../data/';

Ntrain = 700;
Ntest = 100;
W = 28;
Amean = zeros(W^2,10); % mean images

%% read images and calculate the mean image for each digit
for n = 0:9
    mu = zeros(W,W);
    for c = 1:Ntrain
        fname = sprintf('%d_train/digit_%1d_%03d.bmp',n,n,c);
        A = imread([DIR fname]);
        mu = mu+double(A);
    end
    Amean(:,n+1) = reshape(mu/Ntrain,W^2,1);
    figure(1); subplot(3,4,n+1); 
    imshow(reshape(Amean(:,n+1),W,W),[0 255])
end

%% testing
B = zeros(W,W,10);
for n = 0:9
    B(:,:,n+1) = reshape(Amean(:,n+1),W,W);
end
accuracy = zeros(1,10);
confusion = zeros(10,10);
for CL_fact = 1:10
    for c = 1:Ntest
        dist = zeros(1,10);
        fname = sprintf('%d_train/digit_%1d_%03d.bmp', CL_fact-1, CL_fact-1, c+Ntrain-1);
        A = double(imread([DIR fname]));
        for CL = 1:10
            dist(CL) = sum(sum((A-B(:,:,CL)).^2));
        end
        [y,indmin] = min(dist);
        confusion(CL_fact,indmin) = confusion(CL_fact,indmin)+1;
    end
end
fprintf('Total Accuracy = %2.1f%%\n',100*sum(diag(confusion))/sum(sum(confusion)));