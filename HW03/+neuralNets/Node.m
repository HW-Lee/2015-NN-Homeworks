classdef Node < handle
    %neuralNets.NODE Used for I/O ports of a neuron
    %   To regard a connected point between input nodes of current layer and
    %   output nodes of previous layer as an object, so they should share
    %   the same value. Therefore, make it as a reference rather than a value.
    %
    %   Constructor:
    %       node = Node({VALUE});
    %       node = Node(); // which is equivalent to Node(0)
    %
    %   Getter:
    %       value = node.v;
    
    properties
        v;
    end
    
    methods
        function obj = Node(v)
            if nargin == 1
                obj.v = v;
            else
                obj.v = 0;
            end
        end
    end
    
end

