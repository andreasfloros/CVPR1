rng(1)
% TASK 5 - Stereo Rectification
close all

% -----------------------------------------------
% --- Stereo Rectification and Epipolar Lines --- 
% -----------------------------------------------
I1RGB = imread('FD/_DSC2654.JPG');
I2RGB = imread('FD/_DSC2657.JPG');
% 1. Extract fundamental matrix
automatic = false;

% automatic correspondence - less accurate -> use INLIERS
if automatic
    [mp1, mp2] = get_matched_points(im2gray(I1RGB), im2gray(I2RGB));
    matchedPoints1 = mp1.Location;
    matchedPoints2 = mp2.Location;

% manual correspondence - much more accurate
else
    click = false;
    if click
        % click points
        [movingPoints, fixedPoints] = cpselect(I1RGB, I2RGB, 'Wait', true);
        % save clicked points
        save('clicksave_t5.mat','movingPoints','fixedPoints');
        matchedPoints1 = movingPoints
        matchedPoints2 = fixedPoints
    else
        % load clicked points
        load('clicksave_t5.mat');
        matchedPoints1 = movingPoints
        matchedPoints2 = fixedPoints
    end
end

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
automatic = false
% automatic correspondence 
if automatic
    [rectMatchedPoints1, rectMatchedPoints2] = get_matched_points(I1RectGray, I2RectGray);
% manual correspondence - much more accurate
else
    [movingPoints, fixedPoints] = cpselect(I1Rect, I2Rect, 'Wait', true);
    rectMatchedPoints1 = movingPoints
    rectMatchedPoints2 = fixedPoints
end
% extract new fundamental matrix
[rectFundamental,rectInliers] = estimateFundamentalMatrix(rectMatchedPoints1,...
    rectMatchedPoints2,'NumTrials',4000);

% 5. Display Stereo Rectification with Epipolar Lines
% extract epilines for image 1
figure;
subplot(2,2,1);
epiLines1 = epipolarLine(fundamental', matchedPoints2);
points1 = lineToBorderPoints(epiLines1,size(I1RGB));
image(I1RGB);
hold on;
line(points1(:,[1,3])',points1(:,[2,4])');
hold off;
pbaspect([4 2.5 1])

% extract epilines for image 2
subplot(2,2,2);
epiLines2 = epipolarLine(fundamental, matchedPoints1);
points2 = lineToBorderPoints(epiLines2,size(I2RGB));
image(I2RGB);
hold on;
line(points2(:,[1,3])',points2(:,[2,4])');
hold off;
pbaspect([4 2.5 1])

% display rectified image 1 with epilines
image(I1Rect);

subplot(2,2,3);
rectEpiLines1 = epipolarLine(rectFundamental, rectMatchedPoints1);
rectPoints1 = lineToBorderPoints(rectEpiLines1,size(I2Rect));
image(I1Rect);
hold on;
line(rectPoints1(:,[1,3])',rectPoints1(:,[2,4])');
hold off;
pbaspect([4 2 1])

% display rectified image 2
image(I2Rect);
subplot(2,2,4);
rectEpiLines2 = epipolarLine(rectFundamental', rectMatchedPoints2);
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
