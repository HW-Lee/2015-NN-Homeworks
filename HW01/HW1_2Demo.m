clear all; close all;
import Hw1PerceptronClassifier

dataPath = './NN_RealDataForHW1.csv';
data = importdata(dataPath);
header = regexp(data{1}, ',', 'split');
data(1) = [];
sampleNum = length(data);

X = zeros(sampleNum, length(header)); % Note: length(header) = 11
for ii = 1:sampleNum
    trSpleStrFeats = regexp(data{ii}, ',', 'split');
    X(ii, 1) = strcmpi(trSpleStrFeats{1}, 'M'); % only M/F, refer to 'MALE' and 'FEMALE' respectively
    X(ii, 11) = strcmpi(trSpleStrFeats{11}, 'P'); % only P/F, refer to 'PASS' and 'FAIL' respectively
    for jj = 2:10
        X(ii, jj) = str2double(trSpleStrFeats{jj});
    end
end
clear ii jj trSpleStrFeats;
clear dataPath sampleNum data;

y = X(:, end)*2-1;
X(:, end) = [];

clsfier = Hw1PerceptronClassifier.train(X, y);
y_predicted = clsfier.predict(X);
accuracy = sum( y == y_predicted );
display( accuracy / length(y) );
display(clsfier.w);
display(clsfier.b);
