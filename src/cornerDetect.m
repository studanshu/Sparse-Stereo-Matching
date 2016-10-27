function corners = CornerDetect(Image, nCorners, smoothSTD, windowSize)
% INPUTS
%   Image    - Image to detect corners
%   nCorners    - number of corners to detect
%	smoothSTD	- standard deviation of the smoothing kernel
%	windowSize	- size of the smoothing window
%
% OUTPUTS
%   corners     - Corners in the image