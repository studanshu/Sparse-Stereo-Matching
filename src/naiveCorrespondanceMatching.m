function [I, corsSSD] = naiveCorrespondanceMatching(I1, I2, corners1, corners2, R, SSDth)
% INPUTS
%   I1    - Image1 given for correspondeces
%   I1    - Image2 given for correspondeces
%   corners1    - corners in I1
%   corners2    - corners in I2
%   R    - radius of the patch used
%	SSDth	- SSD Match Threshold
%
% OUTPUTS
%   I     - Final Image with correspondences
%	corsSSD	- List of correspondences detected