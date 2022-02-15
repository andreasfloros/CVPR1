% TASK 2 - Checking Correspondences
% for manual correspondences
% https://www.mathworks.com/help/images/select-matching-control-point-pairs.html#f20-23674

% automatic correspondences using
% https://www.mathworks.com/help/vision/ref/matchfeatures.html
close all;

% --- Automatic Correspondence ---
I1RGB = imread('FD/_DSC2654.JPG');
I2RGB = imread('FD/_DSC2665.JPG');
I1GS = im2gray(I1RGB);
I2GS = im2gray(I2RGB);
[matchedPoints1, matchedPoints2] = get_matched_points(I1GS, I2GS, true, 2);
figure;
showMatchedFeatures(I1RGB,I2RGB,matchedPoints1,matchedPoints2, 'montage');

% --- Manual Correspondence ---
[matchedPoints1, matchedPoints2] = get_matched_points(I1GS, I2GS, false, 2);
figure; 
showMatchedFeatures(I1RGB,I2RGB,matchedPoints1,matchedPoints2, 'montage');