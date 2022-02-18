% TASK 4 - Transformation Estimation
close all;

% ------------------
% --- Homography ---
% ------------------
auto = true;
HG1RGB = imread('HG/_DSC2705.JPG');
HG2RGB = imread('HG/_DSC2707.JPG');
HG1 = im2gray(HG1RGB);
HG2 = im2gray(HG2RGB);

% get matches
[matchedPoints1, matchedPoints2] = get_matched_points(HG1, HG2, auto, 41);
figure;

% I have disabled inliers to calculate KAZE MSD

% extract inliers (to get accurate homography matrix)
% [x,inliers] = estimateFundamentalMatrix(matchedPoints1,...
%     matchedPoints2,'NumTrials',4000);
% showMatchedFeatures(HG1RGB,HG2RGB,matchedPoints1(inliers,:),matchedPoints2(inliers,:), 'montage');

% convert matches to matrices and use SVD to get the homography matrix
try
    matrixMatchedPoints1 = matchedPoints1.Location';
    matrixMatchedPoints2 = matchedPoints2.Location';
catch
    matrixMatchedPoints1 = matchedPoints1';
    matrixMatchedPoints2 = matchedPoints2';
end
homography = homography_solve(matrixMatchedPoints1, matrixMatchedPoints2);
transformedPts = homography_transform(matrixMatchedPoints1, homography);


% calculate msd
msd = matrixMatchedPoints2 - transformedPts;
msd = sum(sum(msd .^ 2)) / length(matrixMatchedPoints2);

% visualize homography transformation
figure;
image(HG2RGB);
hold on;
plot(matrixMatchedPoints2(1, :), matrixMatchedPoints2(2, :), '*', 'MarkerSize', 16);
plot(transformedPts(1, :), transformedPts(2, :), '*', 'MarkerSize', 16);
legend('Detected Points','Transformed Points');
hold off;

% --------------------------
% --- Fundamental Matrix ---
% --------------------------
FD1RGB = imread('FD/_DSC2657.JPG');
FD2RGB = imread('FD/_DSC2658.JPG');
FD1 = im2gray(FD1RGB);
FD2 = im2gray(FD2RGB);
[matchedPoints1, matchedPoints2] = get_matched_points(FD1, FD2, auto, 42);

% extract fundamental matrix
[fundamental,inliers] = estimateFundamentalMatrix(matchedPoints1,...
    matchedPoints2,'NumTrials',4000);
figure; 
showMatchedFeatures(FD1RGB, FD2RGB, matchedPoints1(inliers,:), matchedPoints2(inliers,:), 'montage');

% extract epipolar lines for image 2
try
    matrixMatchedPoints1 = matchedPoints1.Location;
    matrixMatchedPoints2 = matchedPoints2.Location;
catch
    matrixMatchedPoints1 = matchedPoints1;
    matrixMatchedPoints2 = matchedPoints2;
end

% visualize keypoints and their corresponding epipolar lines
figure;
subplot(1,2,1);
epiLines1 = epipolarLine(fundamental', matrixMatchedPoints2(inliers,:));
points1 = lineToBorderPoints(epiLines1,size(FD1RGB));
image(FD1RGB);
hold on;
line(points1(:,[1,3])',points1(:,[2,4])');
plot(matrixMatchedPoints1(inliers,1),matrixMatchedPoints1(inliers,2),'g.','MarkerSize',10);
hold off;
pbaspect([4 2.5 1]);

subplot(1,2,2);
epiLines2 = epipolarLine(fundamental, matrixMatchedPoints1(inliers,:));
points2 = lineToBorderPoints(epiLines2,size(FD2RGB));
image(FD2RGB);
hold on;
line(points2(:,[1,3])',points2(:,[2,4])');
plot(matrixMatchedPoints2(inliers,1),matrixMatchedPoints2(inliers,2),'g.','MarkerSize',10);
hold off;
pbaspect([4 2.5 1]);

% show the homography and fundamental matrices
disp(homography);
disp(fundamental);
