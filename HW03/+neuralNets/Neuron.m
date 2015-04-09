classdef Neuron < handle
    %neuralNets.NEURON An element of a neural net
    %
    %   Constructor:
    %       neuron = Neuron();
    %
    %       void Neuron.setS_fun({S_FUNC})
    %       void Neuron.push_back_fan_in({FAN_IN_NODE}, {WEIGHT})
    %       void Neuron.push_back_fan_in({FAN_IN_NODE})
    %       void Neuron.connect_fan_in_to({FAN_OUT_NEURON}, {WEIGHT})
    %       void Neuron.setWeightAtIdx({IDX}, {VALUE})
    %       void Neuron.initWeights()
    %       void Neuron.sendMessage()
    %       Node* Neuron.getFanInAt({IDX})
    %       Vec(n) Neuron.getInputs()
    %       Vec(n) Neuron.getWeights()
    %       int Neuron.getInputsCount()
    %       double Neuron.getY()
    %       double Neuron.getZ()
    %       int Neuron.getLayerIndex()
    
    
    
    properties
        inputs; % Cell<Node>
        weights; % neuralNets.datastructure.MutableArray<double>
        y; % Node: stands for <inputs.v, weights>
        z; % Node: stands for output after non-linear function s_func
        s_func; % function object: s.t. s_func(y) = z
        layer_idx; % int value: stands for which layer it belongs to.
    end
    
    methods % private functions
        function obj = Neuron(data)
            if nargin == 1
                obj.inputs = data.inputs;
                obj.weights = data.weights;
                obj.y = data.y;
                obj.z = data.z;
                obj.s_func = data.s_func;
                obj.layer_idx = data.layer_idx;
            else
                obj.inputs = cell(0, 1);
                obj.weights = neuralNets.datastructure.MutableArray();
                obj.y = neuralNets.Node();
                obj.z = neuralNets.Node();
                obj.s_func = @(x) 1/(1+exp(-x));
                obj.layer_idx = -1;
            end
        end
        
        function obj_clone = clone(obj)
            obj_clone = neuralNets.Neuron(obj.package());
        end
        
        function data = package(obj)
            data.inputs = obj.inputs;
            data.weights = obj.weights;
            data.y = obj.y;
            data.z = obj.z;
            data.s_func = obj.s_func;
            data.layer_idx = obj.layer_idx;
        end
    end
    
    methods % public functions
        function [] = setS_func(obj, s_func)
            obj.s_func = s_func;
        end
        
        function [] = push_back_fan_in(obj, fan_in_node, weight)
            obj.inputs{length(obj.inputs)+1} = fan_in_node;
            if nargin == 3
                obj.weights.add(weight);
            else
                obj.weights.add(0);
            end
        end
        
        function [] = connect_fan_in_to(obj, fan_out_neuron, weight)
            if nargin == 2
                weight = 0;
            end
            fan_out_neuron.push_back_fan_in(obj.z, weight);
        end
        
        function [] = setWeightAtIdx(obj, idx, v)
            obj.weights.set(idx, v);
        end
        
        function inputNode = getFanInAt(obj, idx)
            inputNode = obj.inputs{idx};
        end
        
        function inputValues = getInputs(obj)
            inputValues = zeros(length(obj.inputs), 1);
            for ii = 1:length(inputValues)
                inputValues(ii) = obj.inputs{ii}.v;
            end
        end
        
        function ninput = getInputsCount(obj)
            ninput = length(obj.inputs);
        end
        
        function weights = getWeights(obj)
            weights = obj.weights.array();
        end
        
        function y_value = getY(obj)
            y_value = obj.y.v;
        end
        
        function z_value = getZ(obj)
            z_value = obj.z.v;
        end
        
        function layer_idx = getLayerIndex(obj)
            layer_idx = obj.layer_idx;
        end
        
        function [] = initWeights(obj)
            fanInNum = length(obj.inputs);
            obj.weights.data(1:fanInNum) = normrnd(0, 1/fanInNum, fanInNum, 1);
        end
        
        function [] = sendMessage(obj)
            inputValues = obj.getInputs();
            obj.y.v = inputValues' * obj.weights.array();
            obj.z.v = obj.s_func(obj.y.v);
        end
    end
    
end

