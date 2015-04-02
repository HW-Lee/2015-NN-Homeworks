clear all; close all;
import Hw2LinearFilter;

A = importdata('GradeData_HW2.csv');
sw.fakedata = 0;

L = 3000;
y = A.data(:,end); % desired output
X = A.data(:,1:end-1); % each row is a data case
Ans = pinv( [X ones(size(X, 1), 1)]'*[X ones(size(X, 1), 1)] ) * [X ones(size(X, 1), 1)]'*y;
w_ls = Ans(1:end-1);
clear Ans;
if sw.fakedata
    X = getFakeData(L, size(X, 2), mean(X), cov(X));
    y = X * w_ls;
end

% X = X + 5*randn(size(X));

linFilt = Hw2LinearFilter.train(X, y + 0*randn(size(y)), struct('type', 'online_learning', 'eta', 7e-7, 'NIter', 1e5));
% linFilt = Hw2LinearFilter.train(X, y + randn(size(y)));
error = sqrt( mean( (X*linFilt.w+linFilt.b-y).^2 ) );
display(error);
display(linFilt.w);
display(linFilt.b);

% linFilt.visualinfo('(std_n = 5)');
linFilt.visualinfo();

% error_noise = zeros(100, 1);
% for ii = 1:100
%     if mod(ii, 10) == 0
%         fprintf('ii = %d\n', ii);
%     end
%     y_n = y + 4*randn(size(y));
%     linFilt = Hw2LinearFilter.train(X, y_n);
%     error_noise(ii) = sqrt( mean( (X*linFilt.w+linFilt.b-y).^2 ) );
% end
% error_mean = mean(error_noise);
% error_std = std(error_noise);
% display(error_mean);
% clear ii;