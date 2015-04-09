classdef Neuron < handle
    %neuralNets.NEURON An element of a neural net
    %
    %   Constructor:
    %       neuron = Neuron();
    %           Construct a neuron with only output ports.
    %
    %   Setters:
    %       void Neuron.setS_fun({S_FUNC})
    %           Set the sigmoid function of the neuron. It basically need
    %           not be used for general purposes.
    %           {S_FUNC} a function handle:
    %           e.g.
    %               Default: @(x) 1/(1+exp(-x))
    %               Quadratic: @(x) x.^2
    %
    %       void Neuron.setWeightAtIdx({IDX}, {VALUE})
    %           Set the value of the {IDX}^th weight of the neuron.
    %
    %   Getters:
    %       Node Neuron.getFanInAt({IDX})
    %           Get the {IDX}^th input node(reference).
    %
    %       Vec(n) Neuron.getInputs()
    %           Get all input values of the neuron in the form of MATLAB matrix.
    %           n: the number of input nodes.
    %
    %       Vec(n) Neuron.getWeights()
    %           Get all weights of the neuron in the form of MATLAB matrix.
    %           n: the number of input nodes.
    %           
    %       int Neuron.getInputsCount()
    %           Get the number of input nodes.
    %
    %       double Neuron.getY()
    %           Get the value of linear output of the neuron. 
    %           (i.e. y = x(1)w(1)+...+x(n)w(n))
    %
    %       double Neuron.getZ()
    %           Get the value of nonlinear output of the neuron. 
    %           (i.e. z = sigmoid(y))
    %
    %       int Neuron.getLayerIndex()
    %           Get index indicates which layer it blongs to.
    %
    %   Others:
    %       void Neuron.push_back_fan_in({FAN_IN_NODE}, {WEIGHT})
    %           Push a input node with initial weight at the back of
    %           inputs.
    %           {FAN_IN_NODE} : Node
    %           {WEIGHT} : double
    %       
    %       void Neuron.push_back_fan_in({FAN_IN_NODE})
    %           Push a input node with 0 weight at the back of inputs,
    %           which is equivalent to push_back_fan_in({FAN_IN_NODE}, 0).
    %           {FAN_IN_NODE} : Node
    %
    %       void Neuron.connect_fan_in_to({FAN_OUT_NEURON}, {WEIGHT})
    %           Connect nonlinear output(z) to an input of another neuron
    %           with initial weight.
    %           {FAN_OUT_NEURON} : Neuron
    %           {WEIGHT} : double
    %
    %       void Neuron.connect_fan_in_to({FAN_OUT_NEURON})
    %           Connect nonlinear output(z) to an input of another neuron
    %           with 0 weight, which is equivalent to
    %           connect_fan_in_to({FAN_OUT_NEURON}, 0).
    %           {FAN_OUT_NEURON} : Neuron
    %
    %       void Neuron.initWeights()
    %           Automatically initiate weights of the neuron. (initiated
    %           with Gaussian distribution with 0-mean and m^(-1)-variance,
    %           m stands for # of input nodes)
    %
    %       void Neuron.sendMessage()
    %           After setting inputs, this function will generate
    %           corresponding outputs, namely linear(y) and nonlinear(z).
    %           y = x(1)w(1)+...+x(n)w(n), z = s_func(y)
    
    
    
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
            obj.weights.data(1:fanInNum) = normrnd(0, 1/sqrt(fanInNum), fanInNum, 1);
        end
        
        function [] = sendMessage(obj)
            inputValues = obj.getInputs();
            obj.y.v = inputValues' * obj.weights.array();
            obj.z.v = obj.s_func(obj.y.v);
        end
    end
    
end

