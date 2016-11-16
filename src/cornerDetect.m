function corners = cornerDetect(Image, nCorners, smoothSTD, windowSize)
% INPUTS
%   Image    - Image to detect corners
%   nCorners    - number of corners to detect
%	smoothSTD	- standard deviation of the smoothing kernel
%	windowSize	- size of the smoothing window
%
% OUTPUTS
%   corners     - Corners in the image
sobelX = [-1 0 1; -1 0 1; -1 0 1];
sobelY = sobelX';
imgGray = rgb2gray(Image);
gaussianKernel = fspecial('Gaussian',[windowSize windowSize],smoothSTD);
imgFil = conv2(imgGray,gaussianKernel,'same');
[width height] = size(imgFil);

Ix = conv2(imgFil,sobelX,'same');
Iy = conv2(imgFil, sobelY, 'same');
Ix2 = conv2(Ix, sobelX, 'same');
Iy2 = conv2(Iy, sobelY, 'same');
Ixy = conv2(Ix, sobelY, 'same');
sumFilter = ones(windowSize);

sumIx2 = conv2(Ix2, sumFilter, 'same');
sumIy2 = conv2(Iy2, sumFilter, 'same');
sumIxy = conv2(Ixy, sumFilter, 'same');

minEigenVal = zeros(size(imgFil));
for x = 1:width
    for y = 1:height
        Cxy = [[sumIx2(x,y), sumIxy(x,y)];[sumIxy(x,y) sumIy2(x,y)]];
        minEigenVal(x,y) = min(eig(Cxy));
    end
end

tempMinEigenVal = zeros(size(imgFil));
for x = 1:width
    for y = 1:height
        currentMax = minEigenVal(x,y);
        for tempX = x - windowSize: x + windowSize
            for tempY = y - windowSize: y + windowSize
                if(tempX < 1 || tempX > width || tempY < 1 || tempY > height)
                    continue;
                end
                currentMax = max(currentMax, minEigenVal(tempX,tempY));
            end
        end
        if(minEigenVal(x,y) == currentMax)
            tempMinEigenVal(x,y) = currentMax;
        end
    end
end

minEigenVector = reshape(tempMinEigenVal,1,numel(minEigenVal));
[sortVal, sortIdx] = sort(minEigenVector(:), 'descend');
topNIndex = sortIdx(1:nCorners);

r = [];
c = [];
topCorners = [];
for i = 1:numel(topNIndex)
    x = mod(topNIndex(i) - 1,height) + 1;
    y = floor((topNIndex(i) - 1)/height) + 1;
    r = [r;[x]];
    c = [c;[y]];
    topCorners = [topCorners;[x y]];
end

corners = topCorners;
figure(1), imshow(Image), hold on
plot(c, r, 'o', 'MarkerSize', 10, 'linewidth',2), 
title('corners detected');
end