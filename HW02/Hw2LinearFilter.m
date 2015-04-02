classdef Hw2LinearFilter
    
    properties
        w;
        b;
        w_history;
        b_history;
        e_history;
        isTrained;
        
        optVar;
    end
    
    methods
        function obj = Hw2LinearFilter(data)
            obj.w = data.w;
            obj.b = data.b;
            obj.w_history = data.w_history;
            obj.b_history = data.b_history;
            obj.e_history = data.e_history;
            obj.isTrained = 1;
            obj.optVar = data.optVar;
        end
        function y = predict(obj, X)
            y = X*obj.w + obj.b;
        end
        function visualinfo(obj, msg)
            if nargin < 2
                msg = '';
            end
            if obj.isTrained
                figure(1);
                semilogx(obj.e_history);
                title(['Error of each iteration' msg]);
                xlabel('index of iteration(log-scale)');
                if strcmpi(obj.optVar.type, 'batch_learning') == 1
                    ylabel('d-y mean');
                else
                    ylabel('d-y');
                end
                
                figure(2);
                for ii = 1:3
                    subplot(3, 1, ii);
                    semilogx(obj.w_history(ii, :));
                    str = sprintf('w_%d final = %.2f', ii, obj.w(ii));
                    if ii == 1
                        title([msg '' str]);
                    else
                        title(str);
                    end
                    if ii == 3
                        xlabel('index of iteration(log-scale)');
                    end
                    ylabel('value');
                    xlim([1 obj.optVar.NIter]);
                end
                
                figure(3);
                for ii = 1:3
                    subplot(3, 1, ii);
                    semilogx(obj.w_history(ii+3, :));
                    str = sprintf('w_%d final = %.2f', ii+3, obj.w(ii+3));
                    if ii == 1
                        title([msg '' str]);
                    else
                        title(str);
                    end
                    if ii == 3
                        xlabel('index of iteration(log-scale)');
                    end
                    ylabel('value');
                    xlim([1 obj.optVar.NIter]);
                end
                
                figure(4);
                for ii = 1:4
                    subplot(4, 1, ii);
                    if ii < 4
                        semilogx(obj.w_history(ii+6, :));
                        str = sprintf('w_%d final = %.2f', ii+6, obj.w(ii+6));
                    else
                        semilogx(obj.b_history);
                        str = sprintf('b final = %.2f', obj.b);
                    end
                    if ii == 1
                        title([msg '' str]);
                    else
                        title(str);
                    end
                    if ii == 4
                        xlabel('index of iteration(log-scale)');
                    end
                    ylabel('value');
                    xlim([1 obj.optVar.NIter]);
                end
            else
                error('The predictor has not been trained yet');
            end
        end
    end
    
    methods (Static = true)
        function obj = train(X, y, optVar)
            eta_default = 1e-5;
            NIter_default = 3e4;
            eta_default_batch = 1e-5;
            NIter_default_batch = 3e4;
            type_default = 'online_learning';
            if nargin < 3
                optVar.eta = eta_default;
                optVar.NIter = NIter_default;
                optVar.type = type_default;
            else
                if isfield(optVar, 'type') == 0
                    optVar.type = type_default;
                end
                if isfield(optVar, 'eta') == 0
                    if strcmpi(optVar.type, 'batch_learning') == 1
                        optVar.eta = eta_default_batch;
                    else
                        optVar.eta = eta_default;
                    end
                end
                if isfield(optVar, 'NIter') == 0
                    if strcmpi(optVar.type, 'batch_learning') == 1
                        optVar.NIter = NIter_default_batch;
                    else
                        optVar.NIter = NIter_default;
                    end
                end
            end
            data.optVar = optVar;
            data.w = zeros(size(X, 2), 1);
            data.b = 0;
            data.w_history = zeros(size(X, 2), optVar.NIter);
            data.b_history = zeros(1, optVar.NIter);
            data.e_history = zeros(1, optVar.NIter);
            for ii = 1:optVar.NIter
                if mod(ii, 100) == 0
                    disp(ii);
                end
                % gj = (y-d)(dy/dwj) = (y-d)(xj)
                if strcmpi(optVar.type, 'batch_learning') == 1
                    y_predicted = X*data.w + data.b;
                    err = mean( (y-y_predicted) );
                    g = -mean( X' * diag(y-y_predicted), 2 );
                    data.w = data.w - optVar.eta*g;
                    data.b = data.b - optVar.eta*sum(y_predicted-y);
                elseif strcmpi(optVar.type, 'online_learning') == 1
                    jj = ceil(rand(1)*size(X, 1));
                    err = y(jj) - ( X(jj, :)*data.w+data.b );
                    data.w = data.w + optVar.eta*err*(X(jj, :)');
                    data.b = data.b + optVar.eta*err;
                else
                    error('unknown learning type');
                end
                data.w_history(:, ii) = data.w;
                data.b_history(ii) = data.b;
                data.e_history(ii) = err;
            end
            obj = Hw2LinearFilter(data);
        end
    end
    
end
