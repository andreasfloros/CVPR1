% TASK 4 - Transformation Estimation
close all

% ------------------
% --- Homography ---
% ------------------
HG1RGB = imread('HG/_DSC2705.JPG');
HG2RGB = imread('HG/_DSC2707.JPG');
HG1 = im2gray(HG1RGB);
HG2 = im2gray(HG2RGB);

% get matches
[matchedPoints1, matchedPoints2] = get_matched_points(HG1, HG2);
figure; 
showMatchedFeatures(HG1RGB,HG2RGB,matchedPoints1,matchedPoints2, 'montage');

% convert matches to matrices and use SVD to get the homography matrix
matrixMatchedPoints1 = matchedPoints1.Location';
matrixMatchedPoints2 = matchedPoints2.Location';
homography = homography_solve(matrixMatchedPoints1, matrixMatchedPoints2);
transformedPts = homography_transform(matrixMatchedPoints1, homography);

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
FD2RGB = imread('FD/_DSC2661.JPG');
FD1 = im2gray(FD1RGB);
FD2 = im2gray(FD2RGB);

automatic = false
% automatic correspondence - less accurate -> use INLIERS
if automatic
    [matchedPoints1, matchedPoints2] = get_matched_points(FD1, FD2);

% manual correspondence - much more accurate
else
    click = false;
    if click
        % click points
        cpselect(FD1RGB, FD2RGB);
        % save clicked points
        save('clicksave_t4.mat','movingPoints','fixedPoints');
        matchedPoints1 = movingPoints
        matchedPoints2 = fixedPoints
    else
        % load clicked points
        load('clicksave_t4.mat');
        matchedPoints1 = movingPoints
        matchedPoints2 = fixedPoints
    end
end

% extract fundamental matrix
[fundamental,inliers] = estimateFundamentalMatrix(matchedPoints1,...
    matchedPoints2,'NumTrials',4000);

figure; 
showMatchedFeatures(FD1RGB, FD2RGB, matchedPoints1, matchedPoints2, 'montage');

% extract epilines for image 1
figure;
subplot(1,2,1);
epiLines1 = epipolarLine(fundamental', matchedPoints2);
points1 = lineToBorderPoints(epiLines1,size(FD1RGB));
image(FD1RGB);
hold on;
line(points1(:,[1,3])',points1(:,[2,4])');
hold off;
pbaspect([4 2.5 1])

% extract epilines for image 2
subplot(1,2,2);
epiLines2 = epipolarLine(fundamental, matchedPoints1);
points2 = lineToBorderPoints(epiLines2,size(FD2RGB));
image(FD2RGB);
hold on;
line(points2(:,[1,3])',points2(:,[2,4])');
hold off;
pbaspect([4 2.5 1])