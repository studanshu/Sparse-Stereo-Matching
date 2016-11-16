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
[rowCorner colCorner] = size(corners1);
corsSSD = zeros(rowCorner, 4);
[width height] = size(I1);
minimumThreshold = 10;

homogeneousCoordinate = corners1';
temp = homogeneousCoordinate(1,:);
homogeneousCoordinate(1,:) = homogeneousCoordinate(2,:);
homogeneousCoordinate(2,:) = temp;
homogeneousCoordinate(3,:) = ones(rowCorner, 1);

for i = 1:rowCorner
    line(:,i) = F' * homogeneousCoordinate(:,i);
    correspondingPoints(:,:,i) = round(linePts(line(:,i)', [1, width], [1, width]));
    W1 = I1(corners1(i, 1) - R:corners1(i, 1) + R, corners1(i, 2) - R:corners1(i, 2) + R);
    upperBoundOnError = 100000;
    for x = correspondingPoints(1, 1, i) + R + 1:correspondingPoints(2, 1, i) - R - 1
        y = (- line(3, i) - line(1, i) * x) / line(2, i);
        if( (round(y) - R) > 0 && (round(x) - R) > 0 )
            W2 = I2(round(y) - R:round(y) + R, round(x) - R:round(x) + R);
            SSD = SSDmatch(W1, W2);
            if( (minimumThreshold < SSD) && (SSD < upperBoundOnError) )
                upperBoundOnError = SSD;
                corsSSD(i, 1) = round(y);
                corsSSD(i, 2) = round(x);
            end
        end
    end
    corsSSD(i, 3) = corners1(i, 1);
    corsSSD(i, 4) = corners1(i, 2);
end

I=[I1 I2];
figure;
imshow(I);
hold on;

for i = 1:rowCorner
    plot([corsSSD(i, 4), corsSSD(i, 2) + width], [corsSSD(i, 3), corsSSD(i, 1)], 'MarkerSize', 10, 'linewidth', 2);
    plot(corsSSD(i, 4),corsSSD(i, 3), 'ro', 'MarkerSize', 10, 'linewidth', 2);
    plot(corsSSD(i, 2) + width, corsSSD(i, 1), 'ro', 'MarkerSize', 10, 'linewidth', 2);
end
end