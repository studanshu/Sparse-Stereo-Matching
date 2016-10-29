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
    corsSSD = zeros(rowCorner, 2);
    [width height] = size(I1);

    cors1(:,1)=corners1(:,2);
    cors1(:,2)=corners1(:,1);
    cor11=cors1';
    for i=1:rowCorner
    cor11(3,i)=1;
    end;

    a = [1,width];
    b = a;

    for i = 1:rowCorner
        c1(:,i) = F'*cor11(:,i);
        pts1(:,:,i) = linePts(c1(:,i)',a,b);
        pts1=round(pts1);
        %%%%%%%%SSDmatch%%%%%%%%%%%%%%%%
            W1 = I1(corners1(i, 1) - R:corners1(i, 1) + R, corners1(i, 2) - R:corners1(i, 2) + R);
            upperBoundOnError = 40000;
            for x = pts1(1, 1, i) + R + 1:pts1(2, 1, i) - R - 1
                y = (- c1(3, i) - c1(1, i) * x) / c1(2, i);
                x1 = round(x);
                y1 = round(y);
                if( (y1 - R) > 0 && (x1 - R) > 0 )
                W2 = I2(y1 - R:y1 + R, x1 - R:x1 + R);
                SSD = SSDmatch(W1, W2, SSDth);
                if (minimumThreshold < SSD) && (SSD < upperBoundOnError)
                    upperBoundOnError = SSD;
                    corsSSD(i, 1) = y1; %corsSSD(i,1) y row
                    corsSSD(i, 2) = x1; %corsSSD(i,1) x column
                end
                end
            end
    end
    corsSSD(:, 3) = corners1(:, 1);
    corsSSD(:, 4) = corners1(:, 2);


    I=[I1 I2];
    figure;
    imshow(I);
    hold on;


    for i=1:sz(1,1)
      % plot([pts1(1,1,i)+szI(1,1),pts1(2,1,i)+szI(1,1)],[pts1(1,2,i),pts1(2,2,i)]);
        plot([corsSSD(i,4),corsSSD(i,2)+szI(1,1)],[corsSSD(i,3),corsSSD(i,1)], 'MarkerSize', 10, 'linewidth',2);
    end

    for i=1:sz(1,1)
        plot(corsSSD(i,4),corsSSD(i,3),'ro', 'MarkerSize', 10, 'linewidth',2);
    end

    for i=1:sz(1,1)
        plot(corsSSD(i,2)+szI(1,1),corsSSD(i,1),'ro', 'MarkerSize', 10, 'linewidth',2);
    end
end