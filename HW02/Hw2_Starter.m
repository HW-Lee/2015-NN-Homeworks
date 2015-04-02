% EE6530 NeuroNets HW2: Linear filtering
% Yi-Wen Liu, March 2015
clear; close all

%% Read excel file
DIR = './'; % <--- YOUR DIRECTORY HERE
A = importdata([DIR 'GradeData_HW2.csv']);
des = A.data(:,end); % desired output
inp = A.data(:,1:end-1); % each row is a data case

M = size(inp,2); % num of input variables
N = size(inp,1); % num input vectors
w = zeros(M,1); % initial weights
b = 0; % bias, if any
%% Try least square batch solution
w_ls = pinv(inp'*inp)*(inp'*des); % Least square solution


%% Stochastic gradient descent
L = 3000; % number of steps <---- TINKER AND TWEAK HERE PLEASE
eta = 3e-3; % the fixed learning rate <------ TINKER AND TWEAK HERE PLEASE

%%% Generate more data using the 2nd-order statistics (optional)
sw.fakedata = 1;
if sw.fakedata,
    mu_x = mean(inp); % average score for all activities
    Sigma_x = cov(inp); % covariance matrix
    
    inp_fake = getFakeData(L,M,mu_x,Sigma_x);
    des_fake = inp_fake * w_ls; 
    
end

e_all = zeros(1,L);
w_all = zeros(M,L);
b_all = zeros(1,L);
for ii = 1:L
    if sw.fakedata,
        x = inp_fake(ii,:); x = x(:);
        d = des_fake(ii);
    else
        % random sampling
        s = ceil(rand*N);
        x = inp(s,:); x = x(:);
        d = des(s);
    end
    % filtering
    y = w'*x; %%% <--- FILL IN DETAILS HERE
    err = d - y;
    % update
    w = w + eta*err*x/norm(x); %%% <--- FILL IN DETAILS HERE
    b = b + eta*err; %%% <--- FILL IN DETAILS HERE
    % save for performance analysis
    e_all(ii) = err;
    w_all(:,ii) = w;
    b_all(ii) = b;
end
plot(e_all); xlabel('n'); ylabel('err = target - y');
WeightDev = max(abs(w_ls - w));
fprintf('The estimated weights deviate from the true weights by as much as %.3g\n',WeightDev);
