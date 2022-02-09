% results aren't very good atm, I think it's a combination of not too great
% pictures and weak matching algorithm

% homography

HG1RGB = imread('HG/object/1.JPG');
HG2RGB = imread('HG/object/2.JPG');
HG1 = im2gray(HG1RGB);
HG2 = im2gray(HG2RGB);

% get matches
[matchedPoints1, matchedPoints2] = get_matched_points(HG1, HG2);

% convert matches to matrices and use SVD to get the homography matrix
matrixMatchedPoints1 = matchedPoints1.Location';
matrixMatchedPoints2 = matchedPoints2.Location';
homography = homography_solve(matrixMatchedPoints1, matrixMatchedPoints2);

transformedPts = homography_transform(matrixMatchedPoints1, homography);

figure;
image(HG1RGB);
hold on;
plot(matrixMatchedPoints1(1, :), matrixMatchedPoints1(2, :), '*');
plot(transformedPts(1, :), transformedPts(2, :), '*');
legend('Detected Points','Transformed Points');

% fundamental

% I think this is interesting:
% https://www.mathworks.com/help/vision/ref/estimatefundamentalmatrix.html

FD1RGB = imread('FD/object/1.JPG');
FD2RGB = imread('FD/object/2.JPG');
FD1 = im2gray(FD1RGB);
FD2 = im2gray(FD2RGB);