function corners = CornerDetect(Image, nCorners, smoothSTD, windowSize)
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
        Cxy = [[Ix2(x,y), Ixy(x,y)];[Ixy(x,y) Iy2(x,y)]];
        minEigenVal(x,y) = min(eig(Cxy));
    end
end

sz1 = size(imgFil);
localmin = minEigenVal;

R = localmin(2:size(localmin,1)-1, 2:size(localmin,2)-1) > localmin(2:size(localmin,1)-1, 3:size(localmin,2));
L = localmin(2:size(localmin,1)-1, 2:size(localmin,2)-1) > localmin(2:size(localmin,1)-1, 1:size(localmin,2)-2);
U = localmin(2:size(localmin,1)-1, 2:size(localmin,2)-1) > localmin(1:size(localmin,1)-2, 2:size(localmin,2)-1);
D = localmin(2:size(localmin,1)-1, 2:size(localmin,2)-1) > localmin(3:size(localmin,1), 2:size(localmin,2)-1);
UR = localmin(2:size(localmin,1)-1, 2:size(localmin,2)-1) > localmin(1:size(localmin,1)-2, 3:size(localmin,2));
DR = localmin(2:size(localmin,1)-1, 2:size(localmin,2)-1) > localmin(3:size(localmin,1), 3:size(localmin,2));
UL = localmin(2:size(localmin,1)-1, 2:size(localmin,2)-1) > localmin(1:size(localmin,1)-2, 1:size(localmin,2)-2);
DL = localmin(2:size(localmin,1)-1, 2:size(localmin,2)-1) > localmin(3:size(localmin,1), 1:size(localmin,2)-2);
m = zeros(sz1);
m(2:sz1(1,1)-1, 2:sz1(1,2)-1) = R .* L .* U .* D.* UR .* DR .* UL .* DL;
localmin1 = m .* localmin; % local maxima



[sortedValues, sortIndex] = sort(localmin1(:), 'descend');
ind = sortIndex(1:nCorners);

[r1 c1] = ind2sub([size(localmin,1), size(localmin,2)], ind);

corners = [r1 c1];

figure(1), imshow(imgFil), hold on
plot(c1, r1, 'o', 'MarkerSize', 16, 'linewidth',2);

% minEigenVector = reshape(minEigenVal,1,numel(minEigenVal));
% [sortVal, sortIdx] = sort(minEigenVector(:), 'descend');
% topNIndex = sortIdx(1:nCorners);
% 
% r = [];
% c = [];
% topCorners = [];
% for i = 1:numel(topNIndex)
%     x = mod(topNIndex(i) - 1,height) + 1;
%     y = floor((topNIndex(i) - 1)/height) + 1;
%     r = [r;[x]];
%     c = [c;[y]];
%     topCorners = [topCorners;[x y]];
% end
% 
% corners = topCorners;
% figure(1), imshow(Image), hold on
% plot(c, r, 'o', 'MarkerSize', 10, 'linewidth',2), title('corners detected');
end