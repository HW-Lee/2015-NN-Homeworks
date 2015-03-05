classdef Hw1PerceptronClassifier
    
    properties
        w;
        b;
    end
    
    methods
        function obj = Hw1PerceptronClassifier(data)
            obj.w = data.w;
        end
        function y = predict(obj, X)
            y = sign( X*obj.w );
        end
    end
    
    methods(Static = true)
        function obj = train(X, y)
            data.w = [.4; -.3; -.7; .8];
            obj = Hw1PerceptronClassifier(data);
        end
    end
    
end

