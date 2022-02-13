% TASK 3 - Camera Calibration and Distortion

% parameter estimation using
% https://www.mathworks.com/help/vision/ref/estimatecameraparameters.html
close all

% 1. Camera Parameter Estimation
images = imageSet('checkerboard');
imageFileNames = images.ImageLocation;
[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);

% grid size
squareSizeInMM = 30;
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);
I = readimage(images,1);
imageSize = [size(I, 1),size(I, 2)];
params = estimateCameraParameters(imagePoints,worldPoints, ...
                                  'ImageSize',imageSize,'EstimateSkew',true);
% show reprojection error
showReprojectionErrors(params);
figure;
showExtrinsics(params);
drawnow;

% display reprojection
figure;
for i = 1:length(imageFileNames)
    subaxis(3,3,i, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
    imshow(imageFileNames{i}); 
    hold on;
    plot(imagePoints(:,1,i), imagePoints(:,2,i),'go');
    plot(params.ReprojectedPoints(:,1,i),params.ReprojectedPoints(:,2,i),'r+');
    legend('Detected Points','ReprojectedPoints');
    hold off;    
end

% show camera parameters - https://www.mathworks.com/help/vision/ref/cameraparameters.html
% Camera Intrinsics
disp("Camera Intrinsics");
disp(params.Intrinsics);
disp(params.IntrinsicMatrix);
% Camera Extrinsics 
disp("Camera Extrinsics");
disp(params.RotationMatrices);
disp(params.RotationVectors);
disp(params.TranslationVectors);
% Camera Distortion
disp("Camera Distortion");
disp(params.RadialDistortion);
disp(params.TangentialDistortion);


% 2. Illustrating Camera Distortion
% Note: the camera used has little radial and tangential distortion, so we 
% can try applying a manual distortion transformation
J1 = undistortImage(I, params);
figure; imshowpair(I, J1, 'montage');

% 3. Camera Calibration with Manually Distorted Images
% First perform camera calibration
images = imageSet('checkerboard_distorted');
imageFileNames = images.ImageLocation;
[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);
squareSizeInMM = 30;
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);
I1 = readimage(images,1);
imageSize = [size(I1, 1),size(I1, 2)];
params = estimateCameraParameters(imagePoints,worldPoints, ...
                                  'ImageSize',imageSize,'EstimateSkew',true);
% Obtain distortion parameters
disp("Modified Camera Distortion");
disp(params.RadialDistortion);
disp(params.TangentialDistortion);

% Undistort image - checkerboard
J1 = undistortImage(I1, params);
figure; imshowpair(I1, J1, 'montage');

% Undistort image - book
I2 = imread('HG/hg_distorted_1.JPG');
J2 = undistortImage(I2, params);
figure; imshowpair(I2, J2, 'montage');


