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
        function visualInfo(obj, startIdx, endIdx)
            NIter = size(obj.W_history, 2)-1;
            d = length(obj.w)+1;
            if nargin == 1
                startIdx = 1;
                endIdx = d;
            elseif nargin == 2
                endIdx = startIdx;
            end
            for ii = 1:endIdx-startIdx+1
                subplot(endIdx-startIdx+1, 1, ii);
                plot(0:NIter , obj.W_history(ii+startIdx-1, :));
                if ii+startIdx-1 < d
                    xlabel(['w_{' num2str(ii+startIdx-1) '}']);
                    title(['w_{' num2str(ii+startIdx-1) '} final = ' num2str( obj.w(ii+startIdx-1) )]);
                else
                    xlabel('b');
                    title(['b final = ' num2str( obj.b )]);
                end
            end
        end
    end
    
    methods(Static = true)
        function obj = train(X, y, initGuess, range)
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
                if nargin < 4
                    data = Hw1PerceptronClassifier.updateParams(data, X(errIdx, :), y(errIdx));
                else
                    data = Hw1PerceptronClassifier.updateParams(data, X(errIdx, :), y(errIdx), range);
                end
                data.W_history(:, ii+1) = [data.w; data.b];
            end
            obj = Hw1PerceptronClassifier(data);
        end
        function [data_next] = updateParams(data, X_err, y_err, range)
            eta = 1e-3;
            data_next = data;
            data_next.w = data.w + eta*( sum( diag(y_err)*X_err, 1 )' );
            data_next.b = data.b + eta*( sum( y_err ) );
            if nargin == 4
                if numel(range) == 2
                    data_next.w = max(data_next.w, range(1));
                    data_next.w = min(data_next.w, range(2));
                else
                    data_next.w = max(data_next.w, range(:, 1));
                    data_next.w = min(data_next.w, range(:, 2));
                end
            end
        end
    end
    
end

