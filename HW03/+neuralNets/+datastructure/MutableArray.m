classdef MutableArray < handle
    %MUTABLEARRAY a dynamically editable array
    %   Constructors:
    %       array = MutableArray(size)
    %           init the array with a specific size.
    %
    %       array = MutableArray();
    %           init the array with default size.
    %
    %   Getters:
    %       MutableArray.size()
    %           return the array size.
    %
    %       MutableArray.get(idx) throws IndexOutOfBoundException
    %           return the value of the idx^th element in the array.
    %
    %       MutableArray.array()
    %           return a vector(defined in MATLAB) contains the same
    %           values of the array.
    %
    %
    %   Setters:
    %       MutableArray.add(values)
    %           append the vector into the array.
    %
    %       MutableArray.insert(values, idx) throws IndexOutOfBoundException
    %           insert the vector after the idx^th element.
    %
    %       MutableArray.set(idx, value)
    %           change the idx^th element with value.
    %
    %
    %   Others:
    %       MutableArray.clone()
    %           return an object contains the same properties.
    %
    %       MutableArray.clear()
    %           clear all data contained in the array.
    
    properties
        maxSize;
        data;
    end
    
    methods
        function obj = MutableArray(size)
            if nargin == 1
                obj.data = zeros(size, 1);
                obj.maxSize = 0;
            else
                obj.data = zeros(10, 1);
                obj.maxSize = 0;
            end
        end
        
        function obj_clone = clone(obj)
            obj_clone = neuralNets.datastructure.MutableArray();
            obj_clone.add(obj.array());
        end
        
        function size = size(obj)
            size = obj.maxSize;
        end
        
        function [] = add(obj, num)
            if obj.maxSize + length(num) > length(obj.data)
                if obj.maxSize + length(num) > length(obj.data)*2
                    obj.data = [obj.data(1:obj.maxSize); zeros(length(num), 1)];
                else
                    obj.data = [obj.data; zeros(size(obj.data))];
                end
            end
            obj.data(obj.maxSize+1:obj.maxSize+length(num)) = num(:);
            obj.maxSize = obj.maxSize + length(num);
        end
        
        function [] = insert(obj, num, idx)
            if idx > obj.maxSize
                error('IndexOutOfBoundException');
            else
                if obj.maxSize + length(num) > length(obj.data)
                    if obj.maxSize + length(num) > length(obj.data)*2
                        obj.data = [obj.data(1:obj.maxSize); zeros(length(num), 1)];
                    else
                        obj.data = [obj.data; zeros(size(obj.data))];
                    end
                end
                obj.data(idx+1+length(num):obj.maxSize+length(num)) = obj.data(idx+1:obj.maxSize);
                obj.data(idx+1:idx+length(num)) = num(:);
                obj.maxSize = obj.maxSize + length(num);
            end
        end
        
        function [] = set(obj, idx, v)
            if idx > obj.maxSize || idx < 0
                error('IndexOutOfBoundException');
            end
            obj.data(idx) = v;
        end
        
        function [] = clear(obj)
            obj.data = zeros(10, 1);
            obj.maxSize = 0;
        end
        
        function value = get(obj, idx)
            if idx > obj.maxSize
                error('IndexOutOfBoundException');
            else
                value = obj.data(idx);
            end
        end
        
        function arrayData = array(obj)
            arrayData = obj.data(1:obj.maxSize);
        end
    end
    
end

