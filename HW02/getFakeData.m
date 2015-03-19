function fake = getFakeData(L,M,mu,S)
% function fake = getFakeData(L,M,mu,S) returns L rows of length-M
% vectors according to given mean vector mu and covariance matrix S.
%   
% Created by Yi-Wen Liu for NTHU-EE 6530 Neural Nets Homework #2.
% March 16, 2015

[Q,D] = eig(S);
% so that S Q = Q D, 
% and each column of Q is a principal component (PC), where Q is
% orthonormal
STDEV = sqrt(diag(D));
fake = zeros(L,M);
for kk = 1:L
    coeff = STDEV.*randn(M,1); % generate M random coeffs
    x = Q*coeff; % Combine PCs to generate x
    x = x + mu(:);
    fake(kk,:) = x(:)';
end

end

