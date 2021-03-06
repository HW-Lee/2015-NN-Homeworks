# Name 李豪韋 (HW-Lee) ID 103061527

# Homework1 / Linear Binary Perceptron

## Overview
<p>The homework consists of two parts: 1) Implement a perceptron which is able to tell data with positive labels from those with negative labels; and 2) Calculate the weights, which can be simply regarded as correlation, between students features (namely gender, activities, tests, and participation) in a course and final consequences (pass or fail) of them.</p>
<p>In the first part, a matlab script <code>Hw1_LinBinPerc_DataGen.m</code> is needed to generate a random set of data with binary labels so that the data are known to be linearly separable. Then, the task is to pretend that the linear weight are unknown and train the perceptron with some algorithm iteratively.</p>
<p>In the second part, there is a given excel file <code>NN_RealDataForHW1.csv</code> that contains grade information from a real NTHU course (obfuscated to hide the identity of students). Each column contains the grades for an activity, and the task is to discover how these columns were linearly combined to determine whether a student has passed (P) or failed (F). The code developed for the first part can be used in this part, and the final weights and bias in the trained perceptron should be shown in the report.</p>
<p>Note: For the second part, the following MATLAB functions may be useful: <code>csvread()</code>, <code>importdata()</code>.</p>


## Implementation
1. <b>Functions</b>
	* <b>Hw1PerceptronClassifier.train(X, y)</b>
<p>Return a reference of a perceptron classifier trained with training set <code>X</code> and corresponded ground truths <code>y</code>.</p>
	* <b>Hw1PerceptronClassifier.predict(X)</b>
<p>Return a binary vector contains elements with value of either -1 or 1, which refers to predicted results with unknown testing set <code>X</code>.</p>
	* <b>Hw1PerceptronClassifier.visualInfo()</b>
<p>Show the property of a classifier in a visual way, including parameters <code>w</code>, <code>b</code>, and all <code>w's</code> and <code>b's</code> during training process.</p>

2. <b>Process</b>
	* <b>Generate training set <code>X</code> and corresponded ground truths <code>y</code></b>
<p>Combine two matrices <code>class0</code> and <code>class1</code> into a matrix vertically, and generate a vector which contains the 'class label' indicating which class each row instance belongs to. (-1 refers to <code>class0</code> and 1 to <code>class1</code>)</p>
	* <b>Initialize parameters of the perceptron classifier</b>
<p>In default, the parameters, namely <code>w</code> and <code>b</code>, will be zero vector and zero respectively.</p>
	* <b>Iterate algorithm with N times</b>
<p>
<img width="70%" src="https://raw.githubusercontent.com/HW-Lee/2015-NN-Homeworks/master/HW01/res/algorithm.png"/>
</p>

## Results
![Distribution diagram](https://raw.githubusercontent.com/HW-Lee/2015-NN-Homeworks/master/HW01/res/part1_distributionDiag.png)
![Parametrogram](https://raw.githubusercontent.com/HW-Lee/2015-NN-Homeworks/master/HW01/res/part1_parametrogram_init0.png)
![Performance](https://raw.githubusercontent.com/HW-Lee/2015-NN-Homeworks/master/HW01/res/part1_performance.png)
![Parametrogram1](https://raw.githubusercontent.com/HW-Lee/2015-NN-Homeworks/master/HW01/res/part2_parametrogram1_init0.png)
![Parametrogram2](https://raw.githubusercontent.com/HW-Lee/2015-NN-Homeworks/master/HW01/res/part2_parametrogram2_init0.png)
![Parametrogram3](https://raw.githubusercontent.com/HW-Lee/2015-NN-Homeworks/master/HW01/res/part2_parametrogram3_init0.png)

## Discussion
1. In the first part, does the final weight vector approximate the weights used for data generation (up to a scaling factor)?
2. Does the perceptron successfully (that is, with 100% accuracy) separate the data into two classes?
3. If not, does it help to repeatedly feed the whole set of data to your algorithm? (such as done in the for loop line 25)
4. In the starter code <code>Hw1_starter.m</code>, line16-17, the data are randomly sorted. What is the purpose of this, or does it matter?
5. In the second part, does the gender information help predicting whether a student passed or failed?
