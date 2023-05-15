

clearMEX;

stereoParamMat = load('../dataset/stereoParamsUpdated_50_200.mat');
combImg = imread('../dataset/equalIllium/position15.png');

% leftFrame = combImg(:,1:size(combImg,2)/2,:);
% rightFrame = combImg(:,size(combImg,2)/2+1:end,:);

rightFrame = combImg(:,1:size(combImg,2)/2,:);
leftFrame = combImg(:,size(combImg,2)/2+1:end,:);

disp_min = 0;
disp_max = 40;
depth_min = 20;
depth_max = 300;
thresh=0;

[frameLeftRect, frameRightRect, reprojectionMatrix]= rectifyStereoImages(leftFrame, rightFrame, stereoParamMat.stereoParams);

graySampleLeftRectified  = (rgb2gray(frameLeftRect));
graySampleRightRectified = (rgb2gray(frameRightRect));

disparityMap = disparitySGM(graySampleLeftRectified, graySampleRightRectified, "DisparityRange", [disp_min disp_max], 'UniquenessThreshold',thresh);

nanmap = isnan(disparityMap);
% disparityMap = regionfill(disparityMap, nanmap);
% disparityMap = imfill(disparityMap);
% disparityMap = imdiffusefilt(disparityMap,'GradientThreshold',10,'numberOfIterations',5);

points3D = reconstructScene(disparityMap, reprojectionMatrix);
depthThreshold = [depth_min depth_max];
depth = points3D (:,:,3);
mask = repmat(depth > depthThreshold(1) & depth < depthThreshold(2),[1,1,3]);
filterImage = frameLeftRect;
filterImage(~mask) = 0;

h = tiledlayout(2,2, 'TileSpacing', 'tight');
nexttile
imshow(leftFrame);
title('Original image')

nexttile
imshow(frameLeftRect);
title('Processed image')

nexttile
imshow(depth,[depth_min depth_max]);
colormap jet
colorbar
title('Depth Map');

nexttile
imshow(disparityMap, [disp_min disp_max]);
colormap jet
colorbar
title('Disparity Map');

%% 

% Convert to meters and create a pointCloud object
points3D = points3D ./ 1000;
ptCloud = pointCloud(points3D, 'Color', frameLeftRect);
% Create a streaming point cloud viewer
player3D = pcplayer([-0.25, 0.25], [-0.25, 0.25], [0, 0.25], 'VerticalAxis', 'y', ...
'VerticalAxisDir', 'down');

% Visualize the point cloud
view(player3D, ptCloud);

