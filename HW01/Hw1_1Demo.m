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

NIter = size(clsfier.W_history, 2)-1;
for ii = 1:5
    subplot(5, 1, ii);
    plot(0:NIter , clsfier.W_history(ii, :));
    if ii < 5
        xlabel(['w_' num2str(ii)]);
    else
        xlabel('b');
    end
end
