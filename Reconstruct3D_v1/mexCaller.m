

clearMEX;

% Load example video (L&R)
videoFileLeft = '../dataset/sample-video-2-left-channel.mp4';
videoFileRight = '../dataset/sample-video-2-right-channel.mp4';

% Stereo Params
% stereoParamMat = load('../dataset/stereoParams_paper_checkerboard_50_75.mat');
stereoParamMat = load('../dataset/stereoParamsUpdated_50_200.mat');
stereoStruct = simStereoParam2Mystruct(stereoParamMat.stereoParams);

% Compute Homographies
[H1inv,H2inv,reprojMat] = computeHomographies(stereoStruct.Cam1KMat,stereoStruct.Cam2KMat,...
    stereoStruct.Cam2Rot,stereoStruct.Cam2Trans,...
    stereoStruct.Cam1PrinPoint,stereoStruct.Cam2PrinPoint,...
    stereoStruct.Cam1FocalLength,stereoStruct.Cam2Trans);

readerLeft = VideoReader(videoFileLeft);
readerRight = VideoReader(videoFileRight);

% Extract two frames
frameNumber = 400;
leftFrameRGB = read(readerLeft, frameNumber);
rightFrameRGB = read(readerRight, frameNumber);

leftFrame = rgb2gray(leftFrameRGB);
rightFrame = rgb2gray(rightFrameRGB);
 
% Sim Code
fhSim = @()generateScene3DGpuImpl(leftFrame,rightFrame,H1inv,H2inv,reprojMat,...
    stereoStruct.Cam1RadialCoeff, stereoStruct.Cam1TanCoeff,...
    stereoStruct.Cam2RadialCoeff, stereoStruct.Cam2TanCoeff, ...
    stereoStruct.Cam1FocalLength, stereoStruct.Cam2FocalLength, ...
    stereoStruct.Cam1PrinPoint, stereoStruct.Cam2PrinPoint);
% [rectLImgSim, rectRImgSim, dispMapSim, pts3DSim] = fhSim();
% % simExectime = timeit(fhSim)*1000;

% % Out Point Clouds Sim
% ptCloudSim = pointCloud(pts3DSim, 'Color', leftFrameRGB);
% pcshow(ptCloudSim);

% Gen Code
cdrConfig = coder.gpuConfig;
cdrConfig.GpuConfig.ComputeCapability = '7.5';
cdrConfig.GpuConfig.EnableMemoryManager = 1;
cdrArgs = {leftFrame,rightFrame,coder.Constant(H1inv),coder.Constant(H2inv),coder.Constant(reprojMat),...
    coder.Constant(stereoStruct.Cam1RadialCoeff), coder.Constant(stereoStruct.Cam1TanCoeff),...
    coder.Constant(stereoStruct.Cam2RadialCoeff), coder.Constant(stereoStruct.Cam2TanCoeff), ...
    coder.Constant(stereoStruct.Cam1FocalLength), coder.Constant(stereoStruct.Cam2FocalLength), ...
    coder.Constant(stereoStruct.Cam1PrinPoint), coder.Constant(stereoStruct.Cam2PrinPoint)};
codegen -config cdrConfig generateScene3DGpuImpl -args cdrArgs -report -o gpuMEX

fhGpu = @()gpuMEX(leftFrame,rightFrame,H1inv,H2inv,reprojMat,...
    stereoStruct.Cam1RadialCoeff, stereoStruct.Cam1TanCoeff,...
    stereoStruct.Cam2RadialCoeff, stereoStruct.Cam2TanCoeff, ...
    stereoStruct.Cam1FocalLength, stereoStruct.Cam2FocalLength, ...
    stereoStruct.Cam1PrinPoint, stereoStruct.Cam2PrinPoint);
[rectLImgGpu, rectRImgGpu, dispMapGpu, pts3DGpu] = fhGpu();
gpuExectime = timeit(fhGpu)*1000;

% Out Point Clouds Gpu
ptCloudGpu = pointCloud(pts3DGpu/1000, 'Color', leftFrameRGB);
pcshow(ptCloudGpu);

% Out Graphs Sim
% simOverlay = stereoAnaglyph(rectLImgSim,rectRImgSim);
% figure; imshow(dispMapSim);colormap jet;colorbar;
% figure; imshow(simOverlay,[]);

% Out Graphs Gpu
gpuOverlay = stereoAnaglyph(rectLImgGpu,rectRImgGpu);
figure; imshow(dispMapGpu,[]); colormap jet; colorbar;
figure; imshow(gpuOverlay,[]);

% figure; imagesc(imabsdiff(rectLImgGpu,rectLImgSim));colorbar;
% figure; imagesc(imabsdiff(rectRImgGpu,rectRImgSim));colorbar;
% figure; imagesc(imabsdiff(leftFrame,rectLImgSim));colorbar;
% figure; imagesc(imabsdiff(rightFrame,rectRImgSim));colorbar;