function T = mkStochastic(T)
% T = MKSTOCHASTIC(T) Ensure the argument is a stochastic matriX
%
% The sum over the last dimension is 1.
%
% If T is a vector, it will sum to 1.
% If T is a matrix, each row will sum to 1.
% If T is a 3D array, then sum_k T(i,j,k) = 1 for all i,j.

if sum(size(T)>1) <= 1
    normalizer=sum(T(:));
    % Set eventual zero to one before dividing  
    normalizer=normalizer+(normalizer==0);
    T = T/normalizer;
else
    n = ndims(T);
    % Copy the normalizer plane for each i.
    normalizer = sum(T,n);
    % Replicate the vector to create a matrix, to use a matlab trick for
    % the division.
    normalizer = repmat(normalizer,[ones(1,n-1) size(T,n)]);
    % If normalizer==0, normalizer=1.
    normalizer = normalizer + (normalizer==0);
    T = T ./ normalizer;
end