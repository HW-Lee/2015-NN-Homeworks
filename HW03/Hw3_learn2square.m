% EE6530 Neural Nets Computer homework No. 3 & 4
% Back propagation and "learning" the square function
% Feb. 9, 2015
% Yi-Wen Liu

clear; close all;

% Data generator
N = 1000; % Num cases, equally spaced
x = -1:2/N:1-2/N; x = x(:);
y = abs(x);

% Arrays for recording the process of learning
NumIter = 2000;
x_online = zeros(NumIter,1);
y_online = zeros(NumIter,1);

%% Now setting up a multilayer perceptron networks
w = [-2; 1]; % hidden layer weights
b = [1; -1]; % biases
w_out = randn(2,1); % output layer weights
b_out = randn;

%% parameters
eta = 1;

%% online learning
for nn = 1:NumIter
    % forward path
    seed = ceil(N*rand);
    %seed = nn;
    v = x(seed) *w + b; % 2x1
    phi = 1./(1+exp(-v));
    z = phi(:)'*w_out + b_out; % scalar
    
    y_out = z;
    y_online(nn) = y_out;
    x_online(nn) = x(seed);
    %y_out = 1./(1+exp(-z));
    
    % bachward path
    
    err = y(seed) - y_out;
    % dEdz = y_out.*(1- y_out)*err; % 1x1 i.e. scalar
    dEdz = err;
    w_out_c = eta* dEdz *phi(:); % correction term for w_out
    b_out_c = eta* dEdz;
    dEdPhi = dEdz * w_out; % 2x1, local gradient at hidden layer
    
    dPhidV = phi(:).*(1-phi(:)); % 2x1
    delta = dEdPhi(:).*dPhidV(:); %2x1
    w_c = eta * delta * x(seed); % 2x2
    b_c = eta * delta;
    
    % correction
    w_out = w_out + w_out_c;
    b_out = b_out + b_out_c;
    w = w + w_c;
    b = b + b_c;
    
    % weight visualization
    figure(1)
    if mod(nn,10)==0,
        subplot(221); plot(nn, w, '.'); hold on; xlabel('n'); ylabel('w');
        subplot(222); plot(nn, b,'.'); hold on; xlabel('n'); ylabel('b');
        subplot(223); plot(nn,[w_out; b_out],'.'); hold on;
        subplot(224); %plot(nn,err,'.'); xlabel('n'); ylabel('error'); hold on;
        plot(x(seed),y_out,'.'); hold on;
        drawnow;
    end
end

figure(2)
v = x*w(:)' + ones(N,1)*b(:)'; % N rows, hidden layer "induced local potentials"
phi = 1./(1+exp(-v)); % N rows, hidden layer output
y_out = phi*w_out(:) + b_out;

h = plot(x,y,'g');
set(h,'linewidth',1); hold on;
set(gca,'ylim',[-1 1.5]);
pause;
plot(x_online,y_online,'r.'); 
h = plot(x,y,'g');
set(h,'linewidth',1); hold on;
pause;
h = plot(x,y_out,'--');
set(h,'linewidth',2);



