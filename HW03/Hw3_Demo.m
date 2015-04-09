clear all; close all;

import neuralNets.*;
import neuralNets.datastructure.*;
import neuralNets.trainingalgo.*;

func_opt = 2;

target_func = @(x) x;

switch(func_opt)
    case 1
        target_func = @(x) x.^2;
    case 2
        target_func = @(x) cos(x*pi/2).^2;
    case 3
        target_func = @(x) sin(x*pi/2);
    case 4
        target_func = @(x) abs(x);
    case 5
        target_func = @(x) sqrt(abs(x));
end

% Construct the net
net = NeuralNet();
biasNode = Node(1);
inputNode = Node();

layer = NeuralLayer();

neuron = Neuron();
neuron.push_back_fan_in(biasNode);
neuron.push_back_fan_in(inputNode);
layer.push_back(neuron);

neuron = Neuron();
neuron.push_back_fan_in(biasNode);
neuron.push_back_fan_in(inputNode);
layer.push_back(neuron);

net.push_back_layer(layer);


layer = NeuralLayer();

neuron = Neuron();
neuron.push_back_fan_in(biasNode);
layer.push_back(neuron);

net.push_back_layer(layer);

net.push_back_input_port(inputNode);
net.push_back_output_port(neuron.y);

% Start Training
net.initWeights();

NIter = 300;
Ntest = 100;
error = zeros(NIter, 1);

xx = rand(Ntest, 1)*2-1;
yy = zeros(size(xx));

trainSys = BPSystem(@(err) 1e-1 / max(.1, mean(err).^2));
net.setTrainingSystem(trainSys);
for ii = 1:NIter
    if mod(ii, floor(NIter/10)) == 0
        fprintf('%d %%...\n', floor(100*ii/NIter));
    end
    for jj = 1:Ntest
        x = xx(jj);
        trainSys.feed(x, target_func(x));
        error(ii) = error(ii) + mean(abs( target_func(x) - net.getOutputs() ));
    end
    error(ii) = error(ii) / Ntest;
end

figure(1);
plot(error);

xlin = linspace(-1, 1, 200);
ylin = xlin;
for ii = 1:length(xlin)
    net.setInputs(xlin(ii));
    net.sendMessage();
    ylin(ii) = net.getOutputs();
end

figure(2);
for ii = 1:Ntest
    net.setInputs(xx(ii));
    net.sendMessage();
    yy(ii) = net.getOutputs();
end
plot(xlin, ylin, '-', xx, target_func(xx), '*');
