% gives decent depth map with auto results (garbage manual)
% rng(17);
% I1RGB = imread('HG/_DSC2670.jpg');
% I2RGB = imread('HG/_DSC2671.jpg');

% current gives good epipolar lines but garbage depth map in auto
% i can't get manual correspondences to work decently with this
rng(39);
% TASK 5 - Stereo Rectification
close all;

auto = false;

% -----------------------------------------------
% --- Stereo Rectification and Epipolar Lines --- 
% -----------------------------------------------
I1RGB = imread('FD/_DSC2654.JPG');
I2RGB = imread('FD/_DSC2657.JPG');

% 1. Extract fundamental matrix
[matchedPoints1, matchedPoints2] = get_matched_points(im2gray(I1RGB), im2gray(I2RGB), auto, 51);

% obtain fundamental matrix
[fundamental,inliers] = estimateFundamentalMatrix(matchedPoints1,...
    matchedPoints2,'NumTrials',4000);

% 2. Estimate Uncalibrated Rectification Transformation 
[T1,T2] = estimateUncalibratedRectification(fundamental,matchedPoints1,matchedPoints2,size(I2RGB));

% 3. Rectify Stereo Images
[I1Rect,I2Rect] = rectifyStereoImages(I1RGB,I2RGB,T1,T2);

% 4. Match Stereo Rectified Points for Epipolar Line Visualization
I1RectGray = im2gray(I1Rect);
I2RectGray = im2gray(I2Rect);

[rectMatchedPoints1, rectMatchedPoints2] = get_matched_points(I1RectGray, I2RectGray, auto, 52);

% extract new fundamental matrix
[rectFundamental,rectInliers] = estimateFundamentalMatrix(rectMatchedPoints1,...
    rectMatchedPoints2,'NumTrials',4000);

% 5. Display Stereo Rectification with Epipolar Lines

try
    matrixRectMatchedPoints1 = rectMatchedPoints1.Location;
    matrixRectMatchedPoints2 = rectMatchedPoints2.Location;
catch
    matrixMatchedPoints1 = matchedPoints1;
    matrixMatchedPoints2 = matchedPoints2;
end

% display rectified image 1 with epilines
subplot(1,2,1);
rectEpiLines1 = epipolarLine(rectFundamental, matrixRectMatchedPoints1);
rectPoints1 = lineToBorderPoints(rectEpiLines1,size(I2Rect));
image(I1Rect);
hold on;
line(rectPoints1(:,[1,3])',rectPoints1(:,[2,4])');
hold off;
pbaspect([4 2 1])

% display rectified image 2
subplot(1,2,2);
rectEpiLines2 = epipolarLine(rectFundamental', matrixRectMatchedPoints2);
rectPoints2 = lineToBorderPoints(rectEpiLines2,size(I2Rect));
image(I2Rect);
hold on;
line(rectPoints2(:,[1,3])',rectPoints2(:,[2,4])');
hold off;
pbaspect([4 2 1])


% -----------------------------
% --- Depth / Disparity Map --- 
% -----------------------------
% must immediately used rectified images
A = stereoAnaglyph(I1Rect,I2Rect);
figure;
imshow(A);

I1GS = im2gray(I1Rect);
I2GS = im2gray(I2Rect);
disparityRange = [0 128];
disparityMap = disparityBM(I1GS,I2GS,'DisparityRange',disparityRange,'UniquenessThreshold',20);

figure;
imshow(disparityMap,disparityRange);
title('Disparity Map');
colormap jet
colorbar
