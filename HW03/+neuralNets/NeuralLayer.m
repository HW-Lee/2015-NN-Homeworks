classdef NeuralLayer < handle
    %neuralNets.NEURALLAYER a container contains all Neurons which have same layer index.
    %
    %   Constructors:
    %       layer = NeuralLayer({LAYER_IDX});
    %           Create the {LAYER_IDX}^th layer.
    %
    %       layer = NeuralLayer(); // which is equivalent to NeuralLayer(1)
    %
    %   Getters:
    %       Neuron NeuralLayer.getNeuronAt({IDX})
    %           Get the {IDX}^th neuron of the layer.
    %
    %       int NeuralLayer.getNeuronsCount()
    %           Get # of neurons in the layer.
    %
    %       int NeuralLayer.getLayerIndex()
    %           Get the index of the layer.
    %
    %       Vec(n) NeuralLayer.getOutputs()
    %           Get all output values of the layer in the form of MATLAB
    %           matrix.
    %           n: # of neurons
    %
    %       Vec(n) NeuralLayer.getInputs()
    %           Get all input values of the layer in the form of MATLAB
    %           matrix, Nots that it is exactly the outputs of the previous
    %           layer.
    %           n: # of inputs of a neuron in the layer
    %
    %       Mat(n, m) NeuralLayer.getWeights()
    %           Get all weights of the layer in the form of MATLAB matrix.
    %           (i.e. Weights(i, j) stands for the i^th weight of the j^th
    %           neuron in the layer.
    %           n: # of inputs of a neuron in the layer
    %           m: # of neurons in the layer
    %
    %   Others:
    %       void NeuralLayer.push_back({NEURON})
    %           Push a neuron at the end of the layer.
    %           {NEURON} : Neuron
    %
    %       void NeuralLayer.connect_to_next_layer({LAYER})
    %           Connect to another layer. (fully-connected)
    %           {LAYER} : NeuralLayer
    %
    %       void NeuralLayer.clear()
    %           Clear all neurons in the layer.
    %
    %       void NeuralLayer.initWeights()
    %           Automatically initiate the weights of all neurons in the
    %           layer. (see Neuron.initWeights())
    %
    %       void NeuralLayer.sendMessage()
    %           Call Neuron.sendMessage() with all neurons in the layer.
    
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

