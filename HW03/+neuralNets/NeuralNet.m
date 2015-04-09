classdef NeuralNet < handle
    %neuralNets.NEUROLNET A container includes functions that a neural net
    %   has.
    %
    %   Constructors:
    %       net = NeuralNet({SIZE})
    %           Create a neural net with specific layers.
    %
    %       net = NeuralNet() \\ which is equivalent to NeuralNet(0)
    %
    %   Setters:
    %       void NeuralNet.setInputAtIdx({IDX}, {VALUE})
    %           Set the {IDX}^th input with {VALUE}.
    %           {VALUE} : double
    %
    %       void NeuralNet.setInputs({VALUES})
    %           Set inputs with {VALUES}.
    %           {VALUES} : array with length as many as # of inputs
    %
    %       void NeuralNet.setTrainingSystem({TRAINING_SYSTEM})
    %           Set the training system. (see more detailed below)
    %
    %   Getters:
    %       double NeuralNet.getOutput({IDX})
    %           Get the value of the {IDX}^th output node.
    %
    %       double NeuralNet.getInput({IDX})
    %           Get the value of the {IDX}^th input node.
    %
    %       Vec(n) NeuralNet.getOutputs()
    %           Get all values of output nodes.
    %           n: # of output nodes
    %
    %       Vec(n) NeuralNet.getInputs()
    %           Get all values of input nodes.
    %           n: # of input nodes
    %
    %       int NeuralNet.getLayersCount()
    %           Get # of layers in the net.
    %
    %       NeuralLayer NeuralNet.getLayerAt({IDX})
    %           Get the {IDX}^th layer in the net.
    %
    %   Others:
    %       void NeuralNet.push_back_layer({LAYER})
    %           Push a layer at the end of the net.
    %           {LAYER} : NeuralLayer
    %
    %       void NeuralNet.push_back_input_port({INPUT_NODE})
    %           Push a node at the and of inputs of the net.
    %           {INPUT_NODE} : Node
    %
    %       void NeuralNet.push_back_output_port({OUTPUT_NODE})
    %           Push a node at the end of outputs of the net.
    %           {OUTPUT_NODE} : Node
    %
    %       void NeuralNet.initWeights()
    %           Automatically initiate the weights of all neurons in the
    %           net. (see Neuron.initWeights())
    %
    %       void NeuralNet.sendMessage()
    %           After setting values of inputs, this function will generate
    %           the outputs based on the structure of the net.
    %
    %
    % **  VERY IMPORTANT IF YOU ARE TRYING TO APPLY YOUR OWN ALGORITHM  **
    %
    %   Required implemented functions in an acceptable training system:
    %       1) void YOUR_SYSTEM.setNeuralNet({NET})
    %       2) void YOUR_SYSTEM.feed(Vars... {VAR(S)})
    %       3) double YOUR_SYSTEM.learningRate(Vars... {VAR(S)})
    
    properties
        layers; % Cell<NeuralLayer>
        inputPorts; % Cell<Node>
        outputPorts; % Cell<Node>
        trainingSystem;
    end
    
    methods
        function obj = NeuralNet(size)
            default_size = 0;
            if nargin == 0
                size = default_size;
            end
            obj.layers = cell(size, 1);
            obj.inputPorts = cell(0, 1);
            obj.outputPorts = cell(0, 1);
        end
        
        function [] = push_back_layer(obj, layer)
            obj.layers{length(obj.layers)+1} = layer;
            if length(obj.layers) > 1
                obj.layers{length(obj.layers)-1}.connect_to_next_layer(layer);
            end
        end
        
        function [] = push_back_input_port(obj, input_node)
            obj.inputPorts{length(obj.inputPorts)+1} = input_node;
        end
        
        function [] = push_back_output_port(obj, output_node)
            obj.outputPorts{length(obj.outputPorts)+1} = output_node;
        end
        
        function output = getOutput(obj, idx)
            output = obj.outputPorts{idx}.v;
        end
        
        function outputs = getOutputs(obj)
            outputs = zeros(length(obj.outputPorts), 1);
            for ii = 1:length(outputs)
                outputs(ii) = obj.outputPorts{ii}.v;
            end
        end
        
        function input = getInput(obj, idx)
            input = obj.inputPorts{idx}.v;
        end
        
        function inputs = getInputs(obj)
            inputs = zeros(length(obj.inputPorts), 1);
            for ii = 1:length(inputs)
                inputs(ii) = obj.inputPorts{ii}.v;
            end
        end
        
        function [] = setInputAtIdx(obj, idx, v)
            obj.inputPorts{idx}.v = v;
        end
        
        function [] = setInputs(obj, v)
            for ii = 1:length(v)
                obj.setInputAtIdx(ii, v(ii));
            end
        end
        
        function nlayer = getLayersCount(obj)
            nlayer = length(obj.layers);
        end
        
        function layer = getLayerAt(obj, idx)
            layer = obj.layers{idx};
        end
        
        function [] = initWeights(obj)
            for ii = 1:length(obj.layers)
                obj.getLayerAt(ii).initWeights();
            end
        end
        
        function [] = sendMessage(obj)
            for ii = 1:length(obj.layers)
                obj.getLayerAt(ii).sendMessage();
            end
        end
        
        function [] = setTrainingSystem(obj, trainingSystem)
            obj.trainingSystem = trainingSystem;
            trainingSystem.setNeuralNet(obj);
        end
    end
    
end

