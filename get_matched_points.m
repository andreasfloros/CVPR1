% given grayscale I1 and I2 return the correspondences
% auto (bool) decides if we should use automatic or manual correspondence
% specify the task number to load appropriate file
function [matchedPoints1, matchedPoints2] = get_matched_points(I1, I2, auto, taskn)
    if auto
        % detectHarrisFeatures, detectSURFFeatures...
        points1 = detectKAZEFeatures(I1);
        points2 = detectKAZEFeatures(I2);
        
        [features1,valid_points1] = extractFeatures(I1,points1);
        [features2,valid_points2] = extractFeatures(I2,points2);
        
        % change the MatchThreshold to control how many correspondences you get
        % (SURF gives a lot more compared to Harris)
        indexPairs = matchFeatures(features1,features2);
        
        matchedPoints1 = valid_points1(indexPairs(:,1),:);
        matchedPoints2 = valid_points2(indexPairs(:,2),:);
    else
        % set click = false to load existing manual correspondences
        click = false;
        if click
            % click points
            [matchedPoints1, matchedPoints2] = cpselect(I1, I2, 'Wait', true);
            % save clicked points
            save(sprintf('clicksave/clicksave_t%d.mat', taskn),'matchedPoints1','matchedPoints2');
        else
            % load clicked points
            load(sprintf('clicksave/clicksave_t%d.mat', taskn));
        end
    end
end