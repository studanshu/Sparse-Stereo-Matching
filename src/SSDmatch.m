function SSD = SSDmatch(W1, W2)
% INPUTS
%   W1    - Window1 for SSD Match Algorithm
%   W2    - Window2 for SSD Match Algorithm
%   th    - threshold for matching
%
% OUTPUTS
%   match     - Binary variable if there is a match
%   score     - Score for match
meanW1 = mean(W1(:));
meanW2 = mean(W2(:));

stdDevW1 = std(W1(:));
stdDevW2 = std(W2(:));

SSD = sum(sum((((W1 - meanW1)/stdDevW1) - ((W2 - meanW2)/stdDevW2)).^2));
end