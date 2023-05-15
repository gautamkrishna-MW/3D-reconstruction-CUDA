

clearMEX;

% Load example video (L&R)
videoFileLeft = '../dataset/sample-video-2-left-channel.mp4';
videoFileRight = '../dataset/sample-video-2-right-channel.mp4';

% Stereo Params
stereoParamMat = load('../dataset/stereoParams_paper_checkerboard_50_75.mat');
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

% Create hardware object
hwObj = jetson('10.21.100.56','brain','cmrbrain');
system(hwobj,'ls -al ~');

% GPU Codegen
cfg = coder.gpuConfig('exe');
cfg.TargetLang = 'C++';
cfg.Hardware = coder.hardware('NVIDIA Jetson');
cfg.Hardware.BuildDir = '/media/brain/fd5a17aa-4127-45a1-8ed0-0922369fc0bd/gautamCodes/3dRecons/testMatlabHSP/';
cfg.CustomSource  = fullfile('main.cu');
cfg.GpuConfig.ComputeCapability = '7.5';
cfg.GpuConfig.EnableMemoryManager = 1;
cdrArgs = {leftFrame,rightFrame,coder.Constant(H1inv),coder.Constant(H2inv),coder.Constant(reprojMat),...
    coder.Constant(stereoStruct.Cam1RadialCoeff), coder.Constant(stereoStruct.Cam1TanCoeff),...
    coder.Constant(stereoStruct.Cam2RadialCoeff), coder.Constant(stereoStruct.Cam2TanCoeff), ...
    coder.Constant(stereoStruct.Cam1FocalLength), coder.Constant(stereoStruct.Cam2FocalLength), ...
    coder.Constant(stereoStruct.Cam1PrinPoint), coder.Constant(stereoStruct.Cam2PrinPoint)};
codegen -config cfg generateScene3DGpuImpl -args cdrArgs -report
pid = runApplication(hwobj,'generateScene3DGpuImpl');