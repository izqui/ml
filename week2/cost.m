function J = cost(X, y, tetha)

m = size(X, 1);
predictions = X * tetha;
errors = (predictions-y).^2;

J = 1/(2*m) * sum(errors);

