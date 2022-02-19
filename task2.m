% TASK 2 - Keypoint Correspondences Between Images
close all;

% --- Automatic Correspondence ---
I1RGB = imread('FD/_DSC2654.JPG');
I2RGB = imread('FD/_DSC2665.JPG');
I1GS = im2gray(I1RGB);
I2GS = im2gray(I2RGB);
% [matchedPoints1, matchedPoints2] = get_matched_points(I1GS, I2GS, true, 2);
% figure;
% showMatchedFeatures(I1RGB,I2RGB,matchedPoints1,matchedPoints2, 'montage');
% 
% matrixMatchedPoints1 = matchedPoints1.Location';
% matrixMatchedPoints2 = matchedPoints2.Location';
% homography = homography_solve(matrixMatchedPoints1, matrixMatchedPoints2);
% transformedPts = homography_transform(matrixMatchedPoints1, homography);
% 
% % calculate msd
% msd = matrixMatchedPoints2 - transformedPts;
% num_matches = length(matrixMatchedPoints2);
% msd = sum(sum(msd .^ 2)) / num_matches;
% % display mean squared distances as a measure of quality
% display(msd);
% % display number of matches as a measure of quantity
% display(num_matches);

num_outliers = 3;
% --- Manual Correspondence ---
[matchedPoints1, matchedPoints2] = get_matched_points(I1GS, I2GS, false, 2);
matchedPoints1 = [matchedPoints1; 100 * rand(num_outliers, 2)];
matchedPoints2 = [matchedPoints2; 100 * rand(num_outliers, 2)];
figure;
showMatchedFeatures(I1RGB,I2RGB,matchedPoints1,matchedPoints2, 'montage');

matrixMatchedPoints1 = matchedPoints1';
matrixMatchedPoints2 = matchedPoints2';
homography = homography_solve(matrixMatchedPoints1, matrixMatchedPoints2);
transformedPts = homography_transform(matrixMatchedPoints1, homography);


% calculate msd
msd = matrixMatchedPoints2 - transformedPts;
num_matches = length(matrixMatchedPoints2);
msd = sum(sum(msd .^ 2)) / num_matches;
% display mean squared distances as a measure of quality
display(msd);
% display number of matches as a measure of quantity
display(num_matches);