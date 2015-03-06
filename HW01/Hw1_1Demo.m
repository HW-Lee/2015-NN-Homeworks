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
empErr = sum( y ~= y_predicted );
empErr = empErr / length(y);
display(empErr);

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

Ntest = 20;
accuracyArr = zeros(Ntest, 1);
for ii = 1:Ntest
    Hw1_LinBinPerc_DataGen;
    load Hw1data.mat
    X = [class0; class1];
    y = [ones(length(class0), 1); -ones(length(class1), 1)];
    clear class0 class1;
    y_predicted = clsfier.predict(X);
    accuracyArr(ii) = sum( y == y_predicted )/length(y);
end
clear ii;

accuracy = mean(accuracyArr);
accuStd = std(accuracyArr);

figure(2);
bar(accuracyArr);
title( sprintf('Accuracy: %.4f, Std: %.4f', accuracy, accuStd) );

xlabel('Testing Set Index');
ylabel('Accuracy');

ylim([.9 1]);
xlim([0 Ntest+1]);

display(accuracy);
display(accuStd);