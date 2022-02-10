% parameter estimation using
% https://www.mathworks.com/help/vision/ref/estimatecameraparameters.html

% my images have a pretty big error (especially HG)
% also, the grid needs to be asymmetric: one side should be even and the
% other should be odd (my grid was symmetric)
% I think we should retake the pictures to at least bring the reprojection error down

images = imageSet('checkerboard');
imageFileNames = images.ImageLocation;

[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);

% not sure if we should change this
squareSizeInMM = 29;
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);

I = readimage(images,1);
imageSize = [size(I, 1),size(I, 2)];
params = estimateCameraParameters(imagePoints,worldPoints, ...
                                  'ImageSize',imageSize);

showReprojectionErrors(params);

figure;
showExtrinsics(params);

drawnow;

figure; 
imshow(imageFileNames{1}); 
hold on;
plot(imagePoints(:,1,1), imagePoints(:,2,1),'go');
plot(params.ReprojectedPoints(:,1,1),params.ReprojectedPoints(:,2,1),'r+');
legend('Detected Points','ReprojectedPoints');
hold off;