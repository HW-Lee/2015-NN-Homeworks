Hw1_LinBinPerc_DataGen;
clear all; close all;
import Hw1PerceptronClassifier

load Hw1data.mat

X = [class0; class1];
y = [ones(length(class0), 1); -ones(length(class1), 1)];

clear class0 class1;

tic;
clsfier = Hw1PerceptronClassifier.train(X, y);
toc;
y_predicted = clsfier.predict(X);
accuracy = sum( y == y_predicted );
accuracy = accuracy / length(y);
display(accuracy);
