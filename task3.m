% TASK 3 - Camera Calibration

% parameter estimation using
% https://www.mathworks.com/help/vision/ref/estimatecameraparameters.html
close all

images = imageSet('checkerboard');
imageFileNames = images.ImageLocation;
[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);

% grid size
squareSizeInMM = 30;
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);
I = readimage(images,1);
imageSize = [size(I, 1),size(I, 2)];
params = estimateCameraParameters(imagePoints,worldPoints, ...
                                  'ImageSize',imageSize);

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
% 1. Camera Intrinsics
disp("Camera Intrinsics");
disp(params.Intrinsics);
disp(params.IntrinsicMatrix);

% 2. Camera Extrinsics 
disp("Camera Extrinsics");
disp(params.RotationMatrices);
disp(params.RotationVectors);
disp(params.TranslationVectors);

% 3. Camera Distortion
disp("Camera Distortion");
disp(params.RadialDistortion);
disp(params.TangentialDistortion);