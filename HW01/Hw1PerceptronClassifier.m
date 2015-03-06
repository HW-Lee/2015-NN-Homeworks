classdef Hw1PerceptronClassifier
    
    properties
        w;
        b;
        W_history;
    end
    
    methods
        function obj = Hw1PerceptronClassifier(data)
            obj.w = data.w;
            obj.b = data.b;
            obj.W_history = data.W_history;
        end
        function y = predict(obj, X)
            y = sign( X*obj.w+obj.b );
        end
    end
    
    methods(Static = true)
        function obj = train(X, y, initGuess)
            if nargin >= 3
                data.w = initGuess.w;
                data.b = initGuess.b;
            else
                data.w = zeros(size(X, 2), 1);
                data.b = 0;
            end
            N = 1e2;
            data.W_history = zeros(size(X, 2)+1, N+1);
            data.W_history(:, 1) = [data.w; data.b];
            for ii = 1:N
                errIdx = find( sign( X*data.w+data.b ) ~= y );
                if isempty(errIdx)
                    break;
                end
                data = Hw1PerceptronClassifier.updateParams(data, X(errIdx, :), y(errIdx));
                data.W_history(:, ii+1) = [data.w; data.b];
            end
            obj = Hw1PerceptronClassifier(data);
        end
        function [data_next] = updateParams(data, X_err, y_err)
            eta = 1e-3;
            data_next = data;
            data_next.w = data.w + eta*( sum( diag(y_err)*X_err, 1 )' );
            data_next.b = data.b + eta*( sum( y_err ) );
        end
    end
    
end

