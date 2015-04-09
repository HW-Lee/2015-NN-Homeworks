classdef NeuralLayer < handle
    %neuralNets.NEURALLAYER a container contains all Neurons which have same layer index.
    %
    %   Constructors:
    %       layer = NeuralLayer({LAYER_IDX});
    %       layer = NeuralLayer(); // which is equivalent to NeuralLayer(1)
    %
    %       void NeuralLayer.push_back({NEURON})
    %       void NeuralLayer.connect_to_next_layer({LAYER})
    %       void NeuralLayer.clear()
    %       Neuron NeuralLayer.getNeuronAt({IDX})
    %       int NeuralLayer.getNeuronsCount()
    %       int NeuralLayer.getLayerIndex()
    %       Vec(n) NeuralLayer.getOutputs()
    %       Vec(n) NeuralLayer.getInputs()
    %       Mat(n, m) NeuralLayer.getWeights()
    %       void NeuralLayer.initWeights()
    %       void NeuralLayer.sendMessage()
    
    properties
        neurons; % Cell<Neuron>
        layer_idx; % int: stands for layer index
    end
    
    methods
        function obj = NeuralLayer(layer_idx)
            if nargin == 0
                layer_idx = 1;
            end
            obj.layer_idx = layer_idx;
            obj.neurons = cell(0, 1);
        end
        
        function [] = push_back(obj, neuron)
            obj.neurons{length(obj.neurons)+1} = neuron;
            neuron.layer_idx = obj.layer_idx;
        end
        
        function [] = connect_to_next_layer(obj, next_layer)
            for ii = 1:length(obj.neurons)
                currentNeuron = obj.getNeuronAt(ii);
                for jj = 1:length(next_layer.neurons)
                    currentNeuron.connect_fan_in_to(next_layer.getNeuronAt(jj));
                end
                next_layer.layer_idx = obj.layer_idx + 1;
            end
        end
        
        function [] = clear(obj)
            obj.neurons = cell(0, 1);
        end
        
        function neuron = getNeuronAt(obj, idx)
            neuron = obj.neurons{idx};
        end
        
        function nneuron = getNeuronsCount(obj)
            nneuron = length(obj.neurons);
        end
        
        function layer_idx = getLayerIndex(obj)
            layer_idx = obj.layer_idx;
        end
        
        function outputs = getOutputs(obj)
            outputs = zeros(obj.getNeuronsCount(), 1);
            for ii = 1:length(outputs)
                outputs(ii) = obj.getNeuronAt(ii).getZ();
            end
        end
        
        function inputs = getInputs(obj)
            if obj.getNeuronsCount() == 0
                inputs = [];
                return;
            end
            inputs = obj.getNeuronAt(1).getInputs();
        end
        
        function weights = getWeights(obj)
            if obj.getNeuronsCount() == 0
                weights = [];
                return;
            end
            weights = zeros( length(obj.getNeuronAt(1).getInputs()), obj.getNeuronsCount() );
            for ii = 1:obj.getNeuronsCount()
                weights(:, ii) = obj.getNeuronAt(ii).getWeights();
            end
        end
        
        function [] = initWeights(obj)
            for ii = 1:length(obj.neurons)
                obj.getNeuronAt(ii).initWeights();
            end
        end
        
        function [] = sendMessage(obj)
            for ii = 1:length(obj.neurons)
                obj.getNeuronAt(ii).sendMessage();
            end
        end
    end
    
end

