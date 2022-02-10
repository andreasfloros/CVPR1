% I took some images of my own and ordered them in FD and HG folders
% they are not that great and we should probably try again but lets
% organise them like this?

% for manual correspondences maybe we can use this?
% https://www.mathworks.com/help/images/select-matching-control-point-pairs.html#f20-23674

% automatic correspondences using
% https://www.mathworks.com/help/vision/ref/matchfeatures.html

I1RGB = imread('FD/_DSC2654.JPG');
I2RGB = imread('FD/_DSC2655.JPG');
I1 = im2gray(I1RGB);
I2 = im2gray(I2RGB);

[matchedPoints1, matchedPoints2] = get_matched_points(I1, I2);

figure; 
showMatchedFeatures(I1RGB,I2RGB,matchedPoints1,matchedPoints2, 'montage');