
clc;close all;
clear mex;
clear all;

% File struct
dirStruct = dir('../dataset/equalIllium/');

% Stereo Params
stereoParamMat = load('../dataset/stereoParamsUpdated_50_200.mat');
stereoStruct = simStereoParam2Mystruct(stereoParamMat.stereoParams);

% % Create a streaming point cloud viewer
% player3D = pcplayer([-0.25, 0.25], [-0.25, 0.25], [0, 0.25], 'VerticalAxis', 'y', ...
% 'VerticalAxisDir', 'down');

fh = figure;
fh.WindowState = 'maximized';

outVidObj = VideoWriter('3D Reconstruction on GPU.avi');
outVidObj.FrameRate = 1;
open(outVidObj);

% Process Images
for fIter = 3:length(dirStruct)
    fileName = ['../dataset/equalIllium/',dirStruct(fIter).name];
    
    combImg = imread(fileName);

    rightFrame = rgb2gray(combImg(:,1:size(combImg,2)/2,:));
    leftFrame = rgb2gray(combImg(:,size(combImg,2)/2+1:end,:));

    %% <Call your function script here>
    %% Example: 
	%% [rectLImgGpu, rectRImgGpu, dispMapGpu, pts3DGpu] = yourFunction();
        
    % Overlaid Images
    gpuOverlay = stereoAnaglyph(rectLImgGpu,rectRImgGpu);
    subplot(2,2,1);imshow(gpuOverlay,[]);
    title('Overlaid rectified images');

    % Show point-cloud
    ptCloudGpu = pointCloud(pts3DGpu/1000, 'Color', combImg(:,1:size(combImg,2)/2,:));
    subplot(2,2,2);
    pcshow(ptCloudGpu, 'VerticalAxis','Y', 'ViewPlane','YX','VerticalAxisDir','Up');
    title('Point Cloud');
    
    % Show disparity & depth
    depthRange = [20,300];
    mask = depthRange(1) < pts3DGpu(:,:,3) & pts3DGpu(:,:,3) < depthRange(2);
    depthMap = leftFrame.*uint8(mask);
    subplot(2,2,3); imshow(depthMap,[]); colormap jet; colorbar;
    title('Depth Map');
    subplot(2,2,4); imshow(dispMapGpu,[]); colormap jet; colorbar;
    title('Disparity Map');
    
    fh.Color = [1,1,1];
    writeVideo(outVidObj, getframe(fh));
end

close(outVidObj);