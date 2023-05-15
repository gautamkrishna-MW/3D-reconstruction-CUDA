

clc;close all;
clear mex;
clear all;

% Load example video (L&R)
videoLeftObj = VideoReader('../dataset/sample-video-2-left-channel.mp4');
videoRightObj = VideoReader('../dataset/sample-video-2-right-channel.mp4');

% Stereo Params
stereoParamMat = load('../dataset/stereoParamsUpdated_50_200.mat');
stereoStruct = simStereoParam2Mystruct(stereoParamMat.stereoParams);

% Compute Homographies
[H1inv,H2inv,reprojMat] = computeHomographies(stereoStruct.Cam1KMat,stereoStruct.Cam2KMat,...
    stereoStruct.Cam2Rot,stereoStruct.Cam2Trans,...
    stereoStruct.Cam1PrinPoint,stereoStruct.Cam2PrinPoint,...
    stereoStruct.Cam1FocalLength,stereoStruct.Cam2Trans);


% Process Images
for fIter = 1:videoRightObj.NumFrames
    leftFrameRGB = readFrame(videoLeftObj);
    leftFrame = rgb2gray(leftFrameRGB);
    rightFrame = rgb2gray(readFrame(videoRightObj));

    fhGpu = @()gpuMEX(leftFrame,rightFrame,H1inv,H2inv,reprojMat,...
        stereoStruct.Cam1RadialCoeff, stereoStruct.Cam1TanCoeff,...
        stereoStruct.Cam2RadialCoeff, stereoStruct.Cam2TanCoeff, ...
        stereoStruct.Cam1FocalLength, stereoStruct.Cam2FocalLength, ...
        stereoStruct.Cam1PrinPoint, stereoStruct.Cam2PrinPoint);

    [rectLImgGpu, rectRImgGpu, dispMapGpu, pts3DGpu] = fhGpu();
    gpuExectime = timeit(fhGpu)*1000;

%     imshow(dispMapGpu); colormap jet; colorbar;
    ptCloudGpu = pointCloud(pts3DGpu, 'Color', leftFrameRGB);
    pcshow(ptCloudGpu);
    pause(0.01);
end