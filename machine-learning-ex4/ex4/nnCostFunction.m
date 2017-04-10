function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

m1 = ones(m, 1);
a1 = [m1 X];
z2 = a1 * Theta1.';
a2 = [m1 sigmoid(z2)];
a3 = sigmoid(a2 * Theta2.');
id = eye(num_labels);
T1 = Theta1(:, 2:end);
T2 = Theta2(:, 2:end);

Y = id(y, :); % m x num_labels

% unroll a bunch of crap
a3v = a3(:);
yv = Y(:);
t1v = T1(:);
t2v = T2(:);

J = (-yv.' * log(a3v) - (1 - yv).' * log(1 - a3v)) / m;
J = J + 0.5 * lambda * ((t1v.' * t1v) + (t2v.' * t2v)) / m;

% some other ways to do, trace and elementwise amount to same thing as dot
% product vectors
% J = trace(-Y.' * log(a3v) - (1 - Y).' * log(1 - a3)) / m;
% J = J + 0.5 * lambda * (sum(sum(T1.^2)) + sum(sum(T2.^2))) / m;


d3 = a3 - Y;
d2 = (d3 * T2) .* sigmoidGradient(z2);

D1 = d2.' * a1; % 25 x 401
D2 = d3.' * a2; % 10 x 26

t1z = zeros(size(Theta1, 1), 1);
t2z = zeros(size(Theta2, 1), 1);

Theta1_grad = (D1 + lambda * [t1z T1]) ./ m;
Theta2_grad = (D2 + lambda * [t2z T2]) ./ m;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
