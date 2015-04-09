clear all; close all;

import neuralNets.datastructure.*;
import neuralNets.*;

testingTime = 50;

%% Neurons Functions
fprintf('Testing for functions of Neurons...   ');

for ii = 1:testingTime
    neuron = Neuron();
    fanInNum = randi([1 100], 1);
    v = rand(fanInNum, 1);
    w = rand(fanInNum, 1);
    for jj = 1:fanInNum
        neuron.push_back_fan_in(Node(v(jj)), w(jj));
    end
    neuron.sendMessage();
    errorY = abs( v' * w - neuron.getY() );
    errorZ = abs( 1/(1+exp(-v' * w)) - neuron.getZ() );
    if errorY ~= 0 || errorZ ~= 0
        fprintf('<FAIL>\n');
    end
end

fprintf('<PASS>\n');

%% Neurons Connections
fprintf('Testing for connections between Neurons...   ');

for ii = 1:testingTime
    neuron_output = Neuron();
    fanInNum = randi([1 100], 1);
    neuron_inputs = cell(fanInNum, 1);
    for jj = 1:fanInNum
        neuron_inputs{jj} = Neuron();
        neuron = neuron_inputs{jj};
        neuron.push_back_fan_in(Node(rand(1)), rand(1));
        neuron.connect_fan_in_to(neuron_output);
        neuron.sendMessage();
    end
    vs = neuron_output.getInputs();
    for jj = 1:fanInNum
        if neuron_inputs{jj}.getZ() ~= vs(jj)
            fprintf('<FAIL>\n');
            return;
        end
    end
end

fprintf('<PASS>\n');

%% NeuralLayers Functions
fprintf('Testing for functions of NeuralLayers...   ');

for ii = 1:testingTime
    layer = NeuralLayer(1);
    nextLayer = NeuralLayer();
    nlayer = randi([1 9], 1);
    nnextLayer = randi([1 100], 1);
    neurons1 = cell(nlayer, 1);
    neurons2 = cell(nnextLayer, 1);
    for jj = 1:nlayer
        neurons1{jj} = Neuron();
        neurons1{jj}.push_back_fan_in(Node(0), 1);
        layer.push_back(neurons1{jj});
    end
    for jj = 1:nnextLayer
        neurons2{jj} = Neuron();
        nextLayer.push_back(neurons2{jj});
    end
    layer.connect_to_next_layer(nextLayer);
    for jj = 1:nnextLayer
        if length(nextLayer.getNeuronAt(jj).getInputs()) ~= nlayer
            fprintf('<FAIL>\n');
            return;
        end
        for kk = 1:nlayer
            nextLayer.getNeuronAt(jj).setWeightAtIdx(kk, jj);
        end
    end
    layer.sendMessage();
    nextLayer.sendMessage();
    for jj = 1:nnextLayer
        if nextLayer.getNeuronAt(jj).getY() ~= nlayer*jj/2
            fprintf('<FAIL>\n');
            return;
        end
    end
end

fprintf('<PASS>\n');

clear;
