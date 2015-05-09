# Speech in Neural Network

## Deep Mind
### Game Objects Recognition
- Decision
- Using pixels information

## Supervised Deep Learning
### Examples of Supervised Learning
- Classification
- Denoising (Regression)
- OCR (Optical Characteristic Recognition: structure prediction)

### Deep Learning
- Multi-Stage Predictor

### Neural Network
- Assumption
	- The input image is vectorized (disregard the spatial layout of pixels)
	- The target label is discrete (classification)
- FAQ
	- What class of functions shall we consider to map the input into output?
		- Composition of simpler functions
	- Why not a linear combination? What are the "simpler" functions? What is the interpretation?
		- Later.

### Neural Networks
- Example
- Forward Propagation
- Fully Connected
	- Pros: able to learn a very complex mapping
	- Cons: lots of parameters to learn (time consumption issues)

### Interpretation
- Why can't the mapping between layers be linear?
	- Because composition of linear functions is a linear function. Neural netowrk would reduce to (1 layer) logistic regression
- What do ReLU layers accomplish?
	- Piece-wise linear tiling: mapping is locally linear.
- Why do we need many layers?
	- When input has hierarchical structure, the use of a hierarchical architecture is potentially more efficient because intermediate computations can be re-used.DL architectures are efficient also because they use 'distributed representations' which are shared across classes.
	- 與人的辨識過程相似
		-  是否是一個卡車會觀察： 1)輪子 2)車燈 3)車門 ...
		-  可以共用特徵： 1)摩托車 2)小客車 ...
- What does the hidden unit do?
	- It can be thought of as a classifier or feature detector
- How many layers? How many hidden units?
	- Cross-validation or hyper-parameter search methods are the answer. In general, the wider and the deeper the network the more complicated the mapping.
- How do I set the initial weights?
	- Use a good weights which are well-trained before.

### How good is a Network?
- Loss function

### Training
- Learning consists of minimizing the loss.

### Optimization
- Stochastic Gradient Descent (on mini-batches)
- Stochastic Gradient Descent with Momentum

## Convolutional Neural Networks

### Fully Connected Layer
- lots of parameters: 200x200 image, 40K hidden => ~2B parameters!
- Concerns
	- Spatial correlation is local
	- Waste of resources
	- \# of parameters

### Locally Connected Layer
- Solve:
	- \# of parameters

### As a result...
- Convolutional Layer
	- Sliding window
- Solve:
	- \# of parameters
	- weights sharing
	- position variation handling
- Difference:
	- 每一個neuron的output變成2D Mat

### FAQ
- What is the size of the output? Whats the computational cost?
- How should I set the size of the pools?
	- It depends on how much 'invariant' or robust to distortions we want the representation to be. It is best to pool slowly (via a few stacks of conv-pooling layers).

### Pooling Layer
- Hwo can we make the detection robust to the exact location of the eye?
- Idea: no need to know exactly which neuron is activated
- Pooling:
	- max pooling: taking the max response
	- avg pooling: taking the avg response

### Pooling Layer: Receptive Field Size

### Local Contrast Normalization
- Idea: positive response can be arbitrarily large because of using ReLU
- Equivalent to:
	- 讓影像更清晰，特徵截取更加明顯
