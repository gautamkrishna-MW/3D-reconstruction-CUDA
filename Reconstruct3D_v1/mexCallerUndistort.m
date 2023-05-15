

clearMEX;

% Load example video (L&R)
videoFileLeft = '../dataset/sample-video-2-left-channel.mp4';
videoFileRight = '../dataset/sample-video-2-right-channel.mp4';

% Stereo Params
stereoParamMat = load('../dataset/stereoParams_paper_checkerboard_50_75.mat');
stereoParams = stereoParamMat.stereoParams;

readerLeft = VideoReader(videoFileLeft);
readerRight = VideoReader(videoFileRight);

% Extract two frames
frameNumber = 400;
leftFrame = read(readerLeft, frameNumber);
rightFrame = read(readerRight, frameNumber);

leftFrame = rgb2gray(leftFrame);
rightFrame = rgb2gray(rightFrame);

% Gen Code
leftRCoeff = stereoParams.CameraParameters1.Intrinsics.RadialDistortion;
rightRCoeff = stereoParams.CameraParameters2.Intrinsics.RadialDistortion;
leftTanCoeff = stereoParams.CameraParameters1.Intrinsics.TangentialDistortion;
rightTanCoeff = stereoParams.CameraParameters2.Intrinsics.TangentialDistortion;
focalLengthL = stereoParams.CameraParameters1.Intrinsics.FocalLength;
focalLengthR = stereoParams.CameraParameters2.Intrinsics.FocalLength;
prinAxesL = stereoParams.CameraParameters1.Intrinsics.PrincipalPoint;
prinAxesR = stereoParams.CameraParameters2.Intrinsics.PrincipalPoint;

fhSim = @()undistortImageGpuImpl(leftFrame,rightFrame,leftRCoeff,rightRCoeff,...
    leftTanCoeff,rightTanCoeff,focalLengthL,focalLengthR,prinAxesL,prinAxesR);
[undistLImgSim, undistRImgSim] = fhSim(); 
simExectime = timeit(fhSim)*1000;

cdrConfig = coder.gpuConfig;
cdrArgs = {leftFrame,rightFrame,...
    coder.Constant(leftRCoeff),coder.Constant(rightRCoeff),...
    coder.Constant(leftTanCoeff),coder.Constant(rightTanCoeff), ...
    coder.Constant(focalLengthL),coder.Constant(focalLengthR), ...
    coder.Constant(prinAxesL),coder.Constant(prinAxesR)};
codegen -config cdrConfig undistortImageGpuImpl -args cdrArgs -report -o gpuMEX

fhGpu = @()gpuMEX(leftFrame,rightFrame,leftRCoeff,rightRCoeff, ...
  leftTanCoeff,rightTanCoeff,focalLengthL,focalLengthR,prinAxesL,prinAxesR);
[undistLImgGpu, undistRImgGpu] = fhGpu();
gpuExectime = timeit(fhGpu)*1000;

figure; imshow([undistLImgGpu,undistRImgGpu],[]);
figure; imshow([undistLImgSim,undistRImgSim],[]);
figure; imagesc(imabsdiff(undistLImgGpu,undistLImgSim));colorbar;
figure; imagesc(imabsdiff(undistRImgGpu,undistRImgSim));colorbar;
figure; imagesc(imabsdiff(leftFrame,undistLImgSim));colorbar;
figure; imagesc(imabsdiff(rightFrame,undistRImgSim));colorbar;