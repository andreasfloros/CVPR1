% TASK 5 - 3D Geometry (Stereo Rectification and Disparity Map)
close all;

% set seed
rng(17803);
auto = true;

% -----------------------------------------------
% --- Stereo Rectification and Epipolar Lines --- 
% -----------------------------------------------
% I1RGB = imread('FD/_DSC2654.JPG');
% I2RGB = imread('FD/_DSC2661.JPG');
I1RGB = imread('high_res_FD/high_res_1.JPG');
I2RGB = imread('high_res_FD/high_res_2.JPG');

% 1. Extract fundamental matrix
[matchedPoints1, matchedPoints2] = get_matched_points(im2gray(I1RGB), im2gray(I2RGB), auto, 51);

% obtain fundamental matrix
[fundamental,inliers] = estimateFundamentalMatrix(matchedPoints1,...
    matchedPoints2,'NumTrials',4000);
showMatchedFeatures(I1RGB, I2RGB, matchedPoints1(inliers,:), matchedPoints2(inliers,:), 'montage');

% 2. Estimate Uncalibrated Rectification Transformation 
[T1,T2] = estimateUncalibratedRectification(fundamental,matchedPoints1(inliers,:),matchedPoints2(inliers,:),size(I2RGB));
tform1 = projective2d(T1);
tform2 = projective2d(T2);

% 3. Rectify Stereo Images
[I1Rect,I2Rect] = rectifyStereoImages(I1RGB,I2RGB,tform1,tform2);

% 4. Match Stereo Rectified Points for Epipolar Line Visualization
I1RectGray = im2gray(I1Rect);
I2RectGray = im2gray(I2Rect);

[rectMatchedPoints1, rectMatchedPoints2] = get_matched_points(I1RectGray, I2RectGray, auto, 52);

% extract new fundamental matrix
[rectFundamental,rectInliers] = estimateFundamentalMatrix(rectMatchedPoints1,...
    rectMatchedPoints2,'NumTrials',4000);

% 5. Display Stereo Rectification with Epipolar Lines
try
    matrixRectMatchedPoints1 = rectMatchedPoints1(rectInliers,:).Location;
    matrixRectMatchedPoints2 = rectMatchedPoints2(rectInliers,:).Location;
catch
    matrixMatchedPoints1 = matchedPoints1;
    matrixMatchedPoints2 = matchedPoints2;
end

% display rectified image 1
figure;
subplot(2,2,1);
image(I1Rect);

% display rectified image 2
subplot(2,2,2);
image(I2Rect);

% display rectified image 1 with epilines
subplot(2,2,3);
rectEpiLines1 = epipolarLine(rectFundamental, matrixRectMatchedPoints1);
rectEpiLines1 = rectEpiLines1(1:8:end,:);
rectPoints1 = lineToBorderPoints(rectEpiLines1,size(I2Rect));
image(I1Rect);
hold on;
line(rectPoints1(:,[1,3])',rectPoints1(:,[2,4])');
hold off;
pbaspect([4 2 1])

% display rectified image 2
subplot(2,2,4);
rectEpiLines2 = epipolarLine(rectFundamental', matrixRectMatchedPoints2);
rectEpiLines2 = rectEpiLines2(1:8:end,:);
rectPoints2 = lineToBorderPoints(rectEpiLines2,size(I2Rect));
image(I2Rect);
hold on;
line(rectPoints2(:,[1,3])',rectPoints2(:,[2,4])');
hold off;
pbaspect([4 2 1])

% -----------------------------
% --- Disparity / Depth Map --- 
% -----------------------------
figure;
subplot(2,2,1);
A = stereoAnaglyph(I1Rect,I2Rect);
imshow(A);

% disparity map
subplot(2,2,2);
I1GS = im2gray(I1Rect);
I2GS = im2gray(I2Rect);
disparityRange = [0 48];
disparityMap = disparityBM(I1GS,I2GS,'DisparityRange',disparityRange,'UniquenessThreshold',20);
imshow(disparityMap, disparityRange);
colorbar

% depth map
subplot(2,2,3);
disparityMap = disparityMap + 0.1;
disparityMap = (1/128).*disparityMap;
imshow(1./disparityMap, disparityRange);
colormap bone;
colorbar

disp(disparityMap);




