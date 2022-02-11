% TASK 2 - Checking Correspondences
% for manual correspondences maybe we can use this?
% https://www.mathworks.com/help/images/select-matching-control-point-pairs.html#f20-23674

% automatic correspondences using
% https://www.mathworks.com/help/vision/ref/matchfeatures.html
close all

% --- Automatic Correspondence ---
I1RGB = imread('FD/_DSC2654.JPG');
I2RGB = imread('FD/_DSC2665.JPG');
I1GS = im2gray(I1RGB);
I2GS = im2gray(I2RGB);
[matchedPoints1, matchedPoints2] = get_matched_points(I1GS, I2GS);
figure; 
showMatchedFeatures(I1RGB,I2RGB,matchedPoints1,matchedPoints2, 'montage');

% --- Manual Correspondence ---
click = false;
if click
    % click points
    cpselect(I1RGB, I2RGB);
    % save clicked points
    save('clicksave_t2.mat','movingPoints','fixedPoints');
else
    % load clicked points
    load('clicksave_t2.mat');
end
figure; 
showMatchedFeatures(I1RGB,I2RGB,movingPoints,fixedPoints, 'montage');