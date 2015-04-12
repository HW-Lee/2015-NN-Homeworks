classdef BPSystem < handle
    %neuralNets.trainingalgo.BPSYSTEM A training system using Back-propagation algorithm.
    %
    %   Constructors:
    %       system = BPSystem({ETA})
    %       system = BPSystem();
    %
    %       void BPSystem.setNeuralNet({NET})
    %       void BPSystem.feed({INSTANCES}, {DESIRED_OUTPUTS})
    %       double BPSystem.learningRate({ERR})
    
    properties
        net;
        d;
        eta;
    end
    
    methods
        function obj = BPSystem(eta)
            if nargin == 0
                eta = @(err) 1e-1 / max(.1, mean(err).^2);
            end
            obj.net = cell(0, 1);
            obj.d = cell(0, 1);
            obj.eta = eta;
        end
    end
    
    methods % Required Implemented Functions
        function [] = setNeuralNet(obj, net)
            obj.net = net;
            nlayer = obj.net.getLayersCount();
            obj.d = cell(nlayer, 1);
        end
        function [] = feed(obj, X, y)
            n = size(X, 1);
            d = size(X, 2);
            
            for ii = 1:n
                obj.net.setInputs(X(ii, :));
                obj.net.sendMessage();
                e = y(ii, :)' - obj.net.getOutputs();
                
                obj.d{length(obj.d)} = e;
                for layerIdx = obj.net.getLayersCount()-1:-1:1
                    Z = obj.net.getLayerAt(layerIdx+1).getInputs();
                    W = obj.net.getLayerAt(layerIdx+1).getWeights();
                    obj.d{layerIdx} = diag( Z.*(1-Z) ) * W * obj.d{layerIdx+1};
                end
                
                for layerIdx = 1:length(obj.d)
                    del = obj.d{layerIdx}';
                    layer = obj.net.getLayerAt(layerIdx);
                    del = obj.learningRate(e) * ( layer.getInputs() * del(end-layer.getNeuronsCount()+1:end) );
                    w = obj.net.getLayerAt(layerIdx).getWeights() + del;
                    for i = 1:size(del, 1)
                        for j = 1:size(del, 2)
                            obj.net.getLayerAt(layerIdx).getNeuronAt(j).setWeightAtIdx(i, w(i, j));
                        end
                    end
                end
            end
        end
        function eta = learningRate(obj, err)
            eta = obj.eta(err);
        end
    end
    
end

