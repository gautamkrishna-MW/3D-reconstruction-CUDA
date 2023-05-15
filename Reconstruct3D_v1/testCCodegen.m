

clearMEX;

% Load example video (L&R)
videoFileLeft = '../dataset/sample-video-2-left-channel.mp4';
videoFileRight = '../dataset/sample-video-2-right-channel.mp4';

% Stereo Params
stereoParamMat = load('../dataset/stereoParams_paper_checkerboard_50_75.mat');
stereoParams = stereoParamMat.stereoParams;
stereoParamsStruct = stereoParams.toStruct();

readerLeft = VideoReader(videoFileLeft);
readerRight = VideoReader(videoFileRight);

% Extract two frames
frameNumber = 400;
leftFrame = rgb2gray(read(readerLeft, frameNumber));
rightFrame = rgb2gray(read(readerRight, frameNumber));

% Gen Code
leftRCoeff = stereoParams.CameraParameters1.Intrinsics.RadialDistortion;
rightRCoeff = stereoParams.CameraParameters2.Intrinsics.RadialDistortion;
leftTanCoeff = stereoParams.CameraParameters1.Intrinsics.TangentialDistortion;
rightTanCoeff = stereoParams.CameraParameters2.Intrinsics.TangentialDistortion;
focalLengthL = stereoParams.CameraParameters1.Intrinsics.FocalLength;
focalLengthR = stereoParams.CameraParameters2.Intrinsics.FocalLength;
prinAxesL = stereoParams.CameraParameters1.Intrinsics.PrincipalPoint;
prinAxesR = stereoParams.CameraParameters2.Intrinsics.PrincipalPoint;

cdrConfig = coder.config('exe');
% cdrArgs = {leftFrame,rightFrame,...
%     coder.Constant(leftRCoeff),coder.Constant(rightRCoeff),...
%     coder.Constant(leftTanCoeff),coder.Constant(rightTanCoeff), ...
%     coder.Constant(focalLengthL),coder.Constant(focalLengthR), ...
%     coder.Constant(prinAxesL),coder.Constant(prinAxesR)};
cdrArgs = {leftFrame, coder.Constant(stereoParamsStruct.CameraParameters1)};
codegen -config cdrConfig testCaller -args cdrArgs -report -c