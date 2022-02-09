% given grayscale I1 and I2 return the correspondences
function [matchedPoints1, matchedPoints2] = get_matched_points(I1, I2)
    % detectHarrisFeatures, detectSURFFeatures...
    points1 = detectHarrisFeatures(I1);
    points2 = detectHarrisFeatures(I2);
    
    [features1,valid_points1] = extractFeatures(I1,points1);
    [features2,valid_points2] = extractFeatures(I2,points2);
    
    % change the MatchThreshold to control how many correspondences you get
    % (SURF gives a lot more compared to Harris)
    indexPairs = matchFeatures(features1,features2, 'MatchThreshold', 10.0);
    
    matchedPoints1 = valid_points1(indexPairs(:,1),:);
    matchedPoints2 = valid_points2(indexPairs(:,2),:);
end