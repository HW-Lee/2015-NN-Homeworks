classdef Hw1PerceptronClassifier
    
    properties
        w;
        b;
    end
    
    methods
        function obj = Hw1PerceptronClassifier(data)
            obj.w = data.w;
            obj.b = data.b;
        end
        function y = predict(obj, X)
            y = sign( X*obj.w+obj.b );
        end
    end
    
    methods(Static = true)
        function obj = train(X, y)
            data.w = zeros(size(X, 2), 1);
            data.b = 0;
            N = 1e2;
            for ii = 1:N
                errIdx = find( sign( X*data.w+data.b ) ~= y );
                if isempty(errIdx)
                    break;
                end
                data = Hw1PerceptronClassifier.updateParams(data, X(errIdx, :), y(errIdx));
            end
            obj = Hw1PerceptronClassifier(data);
        end
        function [data_next] = updateParams(data, X_err, y_err)
            eta = 1e-3;
            data_next.w = data.w + eta*( sum( diag(y_err)*X_err, 1 )' );
            data_next.b = data.b + eta*( sum( y_err ) );
        end
    end
    
end

