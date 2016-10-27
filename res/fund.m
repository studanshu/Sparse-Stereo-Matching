function F = fund(x1, x2)
% Computes the fundamental matrix from a set of image correspondences
%
% INPUTS
%   x1    - Image coordinates for reference camera 1 (one per row)
%   x2    - Image coordinates for moved camera 2 (one per row)
%
% OUTPUTS
%   F     - Fundamental matrix (relates pts in cam 1 to lines in cam 2)
%
% DATESTAMP
%   21-May-07 4:16pm
%
% See also SVD

%% 0. Error-checking for input
n = size(x1,1);
if (size(x2,1) ~= n)
    error('Invalid correspondence: number of points don''t match!');
end

%% 1. Perform Hartley normalization (p. 212 of MaSKS)
avg1 = sum(x1,1) / n;
avg2 = sum(x2,1) / n;
diff1 = x1 - repmat(avg1,n,1);
diff2 = x2 - repmat(avg2,n,1);
std1 = sqrt(sum(diff1.^2,1) / n);
std2 = sqrt(sum(diff2.^2,1) / n);
H1 = [1/std1(1), 0, -avg1(1)/std1(1);
      0, 1/std1(2), -avg1(2)/std1(2);
      0, 0, 1];
H2 = [1/std2(1), 0, -avg2(1)/std2(1);
      0, 1/std2(2), -avg2(2)/std2(2);
      0, 0, 1];

norm1 = ([x1 ones(n,1)])*H1';
norm2 = ([x2 ones(n,1)])*H2';

%% 2. Compute a first approximation of the fundamental matrix
design = zeros(n,9);

for i=1:n
    design(i,:) = kron(norm1(i,:), norm2(i,:));
end

[U,S,V] = svd(design);
Fs = V(:,9);
F = reshape(Fs, 3, 3);

%% 3. Impose the rank constraint
[U,S,V] = svd(F);
S(3,3) = 0;
F = U*S*V';

%% 4. Undo the normalization
F = H2'*F*H1;
