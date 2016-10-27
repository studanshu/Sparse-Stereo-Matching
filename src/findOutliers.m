function [ inlier, outlier ] = findOutliers(points3D, P2, outlierTH, corsSSD)
% INPUTS
%   points3D     - 3D co-oridnates of points evaluated
%   P2			- Projection Matrix for camera2
%   outlierTH    - Thresholding for outliers
%   corsSSD	- List of correspondences detected
%
% OUTPUTS
%   inlier     - List of points considered as inliers
%   outlier     - List of points considered as outliers