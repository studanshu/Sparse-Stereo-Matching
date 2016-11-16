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
    
    %Initialzing the variables for future use
[rowCorner colCorner] = size(corners1);
corsSSD = zeros(rowCorner, 4);
[width height] = size(I1);
minimumThreshold = 10;


for i = 1:rowCorner
    if (corners1(i, 1)+R) < width
        W1 = I1(corners1(i, 1) - R:corners1(i, 1) + R, corners1(i, 2) - R:corners1(i, 2) + R);
        upperBoundOnError = 1000000;
        for j = 1:rowCorner
            W2 = I2(corners2(j, 1) - R: corners2(j, 1) + R, corners2(j, 2) - R:corners2(j, 2) + R);
            % Calling SSDmatch to compute the sum of squared difference.
            SSD = SSDmatch(W1, W2);
            if minimumThreshold < SSD && SSD < upperBoundOnError
                upperBoundOnError = SSD;
                %Taking a valid correspondence with minimum upperBound
                corsSSD(i, 1) = corners2(j, 1);
                corsSSD(i, 2) = corners2(j, 2);
            end
        end
    end
    corsSSD(i, 3) = corners1(i, 1);
    corsSSD(i, 4) = corners1(i, 2);
end

% Adjoining the two images
I = [I1 I2];
figure;
imshow(I);
hold on;
for i = 1:rowCorner
    %Plotting for I1
    plot(corsSSD(i, 4), corsSSD(i, 3), 'ro', 'MarkerSize', 10, 'linewidth', 2);
    %Plotting for I2
    plot(corsSSD(i, 2) + width, corsSSD(i, 1), 'ro', 'MarkerSize', 10, 'linewidth', 2);
    %Plotting line if there's a match
    if corsSSD(i, 2) > 1
        plot([corsSSD(i, 4), corsSSD(i, 2) + width], [corsSSD(i, 3), corsSSD(i, 1)], 'MarkerSize', 10, 'linewidth', 2);
    end
end
end