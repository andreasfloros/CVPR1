% TASK 1 - Collect Data
close all;

% --- Calibration Grid - Original --- 
I1RGB = imread('checkerboard/_DSC2643.JPG');
I2RGB = imread('checkerboard/_DSC2644.JPG');
I3RGB = imread('checkerboard/_DSC2645.JPG');
I4RGB = imread('checkerboard/_DSC2647.JPG');
I5RGB = imread('checkerboard/_DSC2648.JPG');
I6RGB = imread('checkerboard/_DSC2649.JPG');
I7RGB = imread('checkerboard/_DSC2651.JPG');
I8RGB = imread('checkerboard/_DSC2652.JPG');
I9RGB = imread('checkerboard/_DSC2653.JPG');
figure;
montage({I1RGB, I2RGB, I3RGB, I4RGB, I5RGB, I6RGB, I7RGB, I8RGB, I9RGB});

% --- Calibration Grid - Distorted --- 
I1RGB = imread('checkerboard_distorted/distorted_1.JPG');
I2RGB = imread('checkerboard_distorted/distorted_2.JPG');
I3RGB = imread('checkerboard_distorted/distorted_3.JPG');
I4RGB = imread('checkerboard_distorted/distorted_4.JPG');
I5RGB = imread('checkerboard_distorted/distorted_5.JPG');
I6RGB = imread('checkerboard_distorted/distorted_6.JPG');
I7RGB = imread('checkerboard_distorted/distorted_7.JPG');
I8RGB = imread('checkerboard_distorted/distorted_8.JPG');
I9RGB = imread('checkerboard_distorted/distorted_9.JPG');
figure;
montage({I1RGB, I2RGB, I3RGB, I4RGB, I5RGB, I6RGB, I7RGB, I8RGB, I9RGB});

% --- FD - Fundamental ---
I1RGB = imread('FD/_DSC2654.JPG');
I2RGB = imread('FD/_DSC2655.JPG');
I3RGB = imread('FD/_DSC2656.JPG');
I4RGB = imread('FD/_DSC2657.JPG');
I5RGB = imread('FD/_DSC2658.JPG');
I6RGB = imread('FD/_DSC2659.JPG');
I7RGB = imread('FD/_DSC2660.JPG');
I8RGB = imread('FD/_DSC2661.JPG');
I9RGB = imread('FD/_DSC2662.JPG');
I10RGB = imread('FD/_DSC2663.JPG');
I11RGB = imread('FD/_DSC2664.JPG');
I12RGB = imread('FD/_DSC2665.JPG');
I13RGB = imread('FD/_DSC2666.JPG');
I14RGB = imread('FD/_DSC2667.JPG');
I15RGB = imread('FD/_DSC2668.JPG');
I16RGB = imread('FD/_DSC2669.JPG');
figure;
montage({I1RGB, I2RGB, I3RGB, I4RGB, I5RGB, I6RGB, I7RGB, I8RGB, I9RGB, I10RGB, I11RGB, I12RGB, I13RGB, I14RGB, I15RGB, I16RGB});

% --- HG - Homography ---
I1RGB = imread('HG/_DSC2696.JPG');
I2RGB = imread('HG/_DSC2698.JPG');
I3RGB = imread('HG/_DSC2699.JPG');
I4RGB = imread('HG/_DSC2700.JPG');
I5RGB = imread('HG/_DSC2702.JPG');
I6RGB = imread('HG/_DSC2703.JPG');
I7RGB = imread('HG/_DSC2704.JPG');
I8RGB = imread('HG/_DSC2705.JPG');
I9RGB = imread('HG/_DSC2706.JPG');
I10RGB = imread('HG/_DSC2707.JPG');
I11RGB = imread('HG/_DSC2709.JPG');
I12RGB = imread('HG/_DSC2710.JPG');
I13RGB = imread('HG/_DSC2711.JPG');
I14RGB = imread('HG/_DSC2712.JPG');
I15RGB = imread('HG/_DSC2713.JPG');
I16RGB = imread('HG/_DSC2714.JPG');
figure;
montage({I1RGB, I2RGB, I3RGB, I4RGB, I5RGB, I6RGB, I7RGB, I8RGB, I9RGB, I10RGB, I11RGB, I12RGB, I13RGB, I14RGB, I15RGB, I16RGB});