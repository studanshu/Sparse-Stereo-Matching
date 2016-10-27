function corsSSD = correspondanceMatchingLine( I1, I2, corners1, F, R, SSDth)
% INPUTS
%   I1    - Image1 given for correspondeces
%   I1    - Image2 given for correspondeces
%   corners1    - corners in I1
%   R    - radius of the patch used
%	SSDth	- SSD Match Threshold
%
% OUTPUTS
%	corsSSD	- List of correspondences detected