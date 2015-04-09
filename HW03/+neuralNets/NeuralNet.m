classdef NeuralNet < handle
    %neuralNets.NEUROLNET A container includes functions that a neural net
    %   has.
    %
    %   Constructors:
    %       net = NeuralNet({SIZE})
    %       net = NeuralNet()
    %
    %       void NeuralNet.push_back_layer({LAYER})
    %       void NeuralNet.push_back_input_port({INPUT_NODE})
    %       void NeuralNet.push_back_output_port({OUTPUT_NODE})
    %       double NeuralNet.getOutput({IDX})
    %       Vec(n) NeuralNet.getOutputs()
    %       double NeuralNet.getInput({IDX})
    %       Vec(n) NeuralNet.getInputs()
    %       void NeuralNet.setInputAtIdx({IDX}, {VALUE})
    %       void NeuralNet.setInputs({VALUES})
    %       int NeuralNet.getLayersCount()
    %       NeuralLayer NeuralNet.getLayerAt({IDX})
    %       void NeuralNet.initWeights()
    %       void NeuralNet.sendMessage()
    %       void NeuralNet.setTrainingSystem({TRAINING_SYSTEM})
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

