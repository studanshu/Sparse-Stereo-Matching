function [ inlier, outlier ] = findOutliers(points3D, P2, outlierTH, corsSSD, I2)
% INPUTS
%   points3D     - 3D co-oridnates of points evaluated
%   P2			- Projection Matrix for camera2
%   outlierTH    - Thresholding for outliers
%   corsSSD	- List of correspondences detected
%
% OUTPUTS
%   inlier     - List of points considered as inliers
%   outlier     - List of points considered as outliers

correspondingPoints = corsSSD(:, 1:2);
correspondingPoints = correspondingPoints';
backProjectHomogeneous = P2 * points3D;
[row col] = size(correspondingPoints);

backProjectCartesian(1, :) = backProjectHomogeneous(1, :) ./ backProjectHomogeneous(3, :);
backProjectCartesian(2, :) = backProjectHomogeneous(2, :) ./ backProjectHomogeneous(3, :);

outlierCount = 0;
inlierCount = 0;
for i = 1:col
    error1 = (correspondingPoints(1, i) - backProjectCartesian(1, i))^2;
    error2 = (correspondingPoints(2, i) - backProjectCartesian(2, i))^2;
    if(error1 + error2 > outlierTH^2)
        outlierCount = outlierCount + 1;
        outlier(:,outlierCount) = backProjectCartesian(:,i);
    else
        inlierCount = inlierCount + 1;
        inlier(:, inlierCount) = backProjectCartesian(:, i);
    end
end

figure;
imshow(I2);
hold on;
for i = 1:inlierCount
    plot(inlier(2, i), inlier(1, i), 'b+', 'MarkerSize', 10, 'linewidth', 2);
end
hold on
for i = 1:outlierCount
    plot(outlier(2,i), outlier(1,i), 'r+', 'MarkerSize', 10, 'linewidth',2); 
end
hold on
for i=1:col
    plot(correspondingPoints(2,i), correspondingPoints(1,i), 'ko', 'MarkerSize', 10, 'linewidth',2);
end
end