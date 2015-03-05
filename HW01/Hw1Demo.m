clear all; close all;
import Hw1PerceptronClassifier

load Hw1data.mat

X = [class0; class1];
y = [ones(length(class0), 1); -ones(length(class1), 1)];

clear class0 class1;

clsfier = Hw1PerceptronClassifier.train(X, y);
y_predicted = clsfier.predict(X);
accuracy = sum( y ~= y_predicted );
accuracy = accuracy / length(y);
display(accuracy);
