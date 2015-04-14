clear all; close all;

% for okay = 1:10

import neuralNets.*;
import neuralNets.datastructure.*;
import neuralNets.trainingalgo.*;

func_opt = 5;
nNeurons = 5;

target_func = @(x) x.^3;

switch(func_opt)
    case 1
        target_func = @(x) x.^2;
    case 2
        target_func = @(x) cos(x*pi/2).^2;
    case 3
        target_func = @(x) sin(x*pi/2*2);
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

for ii = 1:nNeurons

    neuron = Neuron();
    neuron.push_back_fan_in(biasNode);
    neuron.push_back_fan_in(inputNode);
    layer.push_back(neuron);

end

net.push_back_layer(layer);


% layer = NeuralLayer();
% for ii = 1:5
%     layer.push_back(Neuron());
% end
% net.push_back_layer(layer);

layer = NeuralLayer();
neuron = Neuron();
layer.push_back(neuron);
net.push_back_layer(layer);

net.push_back_input_port(inputNode);
net.push_back_output_port(neuron.y);

% Start Training
net.initWeights();

NIter = 800;
Ntest = 50;
error = zeros(NIter, 1);

range = 1;

xx = rand(Ntest, 1)*2*range - range;
yy = zeros(size(xx));

etaConst = .2;
for ii = 1:net.getLayersCount()
    etaConst = etaConst / net.getLayerAt(ii).getNeuronsCount();
end
trainSys = BPSystem(@(err) etaConst / max(.1, mean(err).^2));
net.setTrainingSystem(trainSys);
for ii = 1:NIter
    if mod(ii, floor(NIter/10)) == 0
        fprintf('%d %%...\n', floor(100*ii/NIter));
    end
    xx = rand(Ntest, 1)*2*range - range;
    for jj = 1:Ntest
        x = xx(jj);
        trainSys.feed(x, target_func(x));
        error(ii) = error(ii) + mean(abs( target_func(x) - net.getOutputs() ));
    end
    error(ii) = error(ii) / Ntest;
end

figure(1);
plot(error);
title('Error at each iteration');
xlabel('iteration');
ylabel('|\epsilon|');

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

plot(xlin, ylin, '-', xlin(1:2:end), target_func(xlin(1:2:end)), 'x');
title('Training Result');
legend('NN system', 'target function');
xlabel('input space');
ylabel('output space');
axis equal;

clear NIter Ntest etaConst ii jj x xlin xx ylin yy;

% save(['./lib_nN2/lib' num2str(okay) 'nN2']);

% end
