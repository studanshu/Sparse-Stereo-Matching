function plotEpiLines(I1, I2, cors1, cors2)

F = fund(cors2, cors1);
[width height] = size(I1);
[rowCorner colCorner] = size(cors1)

homogeneousEqCor1 = cors1';
for i = 1:rowCorner
    homogeneousEqCor1(3,i) = 1;
end

homogeneousEqCor2 = cors2';
for i = 1:rowCorner
    homogeneousEqCor2(3,i)=1;
end

figure
imshow(I1);
hold on;

for i = 1:rowCorner
    plot(cors1(i, 1), cors1(i, 2), 'o');
    line(:, i) = F * homogeneousEqCor2(:, i);
    points(:, :, i) = linePts(line(:, i)', [1, width], [1, width]);
    plot([points(1, 1, i),points(2, 1, i)],[points(1, 2, i),points(2, 2, i)]);
end

figure
imshow(I2);
hold on;

for i = 1:rowCorner
    plot(cors2(i, 1), cors2(i, 2), 'o');
    line(:, i) = F' * homogeneousEqCor1(:, i);
    points(:, :, i) = linePts(line(:, i)', [1, width], [1, width]);
    plot([points(1, 1, i), points(2, 1, i)], [points(1, 2, i), points(2, 2, i)]);
end
end