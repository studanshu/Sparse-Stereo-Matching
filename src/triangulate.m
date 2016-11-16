function points3D = triangulate(corsSSD, P1, P2)
% INPUTS
%   P1      - Projection Matrix for camera1
%   P2      - Projection Matrix for camera2
%   corsSSD	- List of corners detected
%
% OUTPUTS
%   points3D   - 3D co-oridnates of points
homogeneousPoints1(:, 1) = corsSSD(:, 3);
homogeneousPoints1(:, 2) = corsSSD(:, 4);
homogeneousPoints1(:, 3) = 1;
homogeneousPoints1 = homogeneousPoints1';

homogeneousPoints2(:, 1) = corsSSD(:, 1);
homogeneousPoints2(:, 2) = corsSSD(:, 2);
homogeneousPoints2(:, 3) = 1;
homogeneousPoints2 = homogeneousPoints2';

[width height] = size(homogeneousPoints1)

for i = 1:height
    currentPoint1 = homogeneousPoints1(:, i);
    currentPoint2 = homogeneousPoints2(:, i);

    A = [currentPoint1(1, 1) .* P1(3, :) - P1(1, :);
         currentPoint1(2, 1) .* P1(3, :) - P1(2, :); 
         currentPoint2(1, 1) .* P2(3, :) - P2(1, :);
         currentPoint2(2, 1) .* P2(3, :) - P2(2, :)
        ];
    [U,Sigma,V] = svd(A);

    currentWorldCoordinate = V(:, 4);
    currentWorldCoordinate = currentWorldCoordinate ./ repmat(currentWorldCoordinate(4, 1), 4, 1);

    points3D(:,i) = currentWorldCoordinate;
end
end