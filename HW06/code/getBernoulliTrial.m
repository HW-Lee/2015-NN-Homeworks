function [ outcome ] = getBernoulliTrial( p, s, convert )

    if nargin == 1 s = size(p); end
    outcome = rand(s) < p;
    if nargin == 3 outcome = convert(outcome); end

end

