function pts = linePts(line, xrange, yrange)
% Returns the endpoints of a line clipped by the given bounding box.
%
% INPUTS
%   line    - Homogeneous coordinates of the line
%   xrange  - X-coordinate range of the bounding box [xmin, xmax]
%   yrange  - Y-coordinate range of the bounding box [ymin, ymax]
% 
% OUTPUTS
%   pts     - The endpoints of the line in the bounding box.
% 
% DATESTAMP
%   18-May-07 12:10am
% 

xmin = xrange(1); xmax = xrange(2);
ymin = yrange(1); ymax = yrange(2);

% Find the four intersections with the bounding box limits
allPts = [xmin, -(line(1)*xmin + line(3))/line(2);
          xmax, -(line(1)*xmax + line(3))/line(2);
          -(line(2)*ymin + line(3))/line(1), ymin;
          -(line(2)*ymax + line(3))/line(1), ymax];

% Clip testing: find the two intersections inside the bounding box
count = 0;
pts = zeros(2,2);
for i=1:4
    if ((allPts(i,1) >= xmin) && (allPts(i,1) <= xmax) && ...
        (allPts(i,2) >= ymin) && (allPts(i,2) <= ymax))
        % add it to the list of endpoints
        count = count + 1;

        if (count == 1)
            pts(count,:) = allPts(i,:);
        elseif (count > 1)
            addPoint = logical(1);
            for j=1:count-1
                % Check to see that we're not adding a duplicate point
                diff = sum(abs(pts(j,:) - allPts(i,:)));
                if (diff < 1e-5)
                    % Don't add the point
                    addPoint = 0;
                end
            end
            
            if (~addPoint)
                count = count - 1;
            elseif (count > 2)
                % This is an error
                error('Bug: more than two points on the line intersect the bounding box!');
            else
                % Add the point to the list
                pts(count,:) = allPts(i,:);
            end
        end
    end
end