

function [leftRect,rightRect,disparityMap,pts3DOut] = generateScene3DGpuImpl(leftImage, rightImage, ...
    HLeftInv, HRightInv, reprojMat, LCamRadCoeff, LCamTanCoeff, RCamRadCoeff, RCamTanCoeff, ...
    LCamFocalLength,RCamFocalLength,LCamPrinPoint,RCamPrinPoint)
%#codegen
coder.gpu.kernelfun;

%% Undistort Image
[outLeftUndistorted,outRightUndistorted] = undistortImageGpuImpl(leftImage, rightImage, ...
    LCamRadCoeff, RCamRadCoeff, LCamTanCoeff, RCamTanCoeff, LCamFocalLength, RCamFocalLength, ...
    LCamPrinPoint, RCamPrinPoint);

%% Rectify Images
[leftRect, rightRect] = imwarpGpuImpl(outLeftUndistorted, HLeftInv, outRightUndistorted, HRightInv);

%% Preprocessing Image
filterSize = 11;
fh = @(X)applyFilt(X);
leftFiltered = stencilfun(fh, leftRect, [filterSize,filterSize], Shape = 'same');
rightFiltered = stencilfun(fh, rightRect, [filterSize,filterSize], Shape = 'same');

%% Compute disparity
disparityRange = [0,40];
uniquenessThreshold = 0;
disparityMap = disparitySGM(leftFiltered, rightFiltered, "DisparityRange", disparityRange,...
    'UniquenessThreshold', uniquenessThreshold);

%% Post processing
disparityMap = holeFillGpuImpl(disparityMap, disparityRange);

%% Reprojection
pts3DOut = reprojectPointsGpuImpl(disparityMap,reprojMat);
end

function outVal = applyFilt(inpMat)
    sum = single(0);
    for i = 1:numel(inpMat)
        sum = sum + cast(inpMat(i),'single');
    end
    outVal = sum/(255*numel(inpMat));
end

function outVal = applyMedFilt(inpMat_3x3)
    for iter = 1:5
        for jter = iter+1:9
            if inpMat_3x3(iter) > inpMat_3x3(jter)
                t = inpMat_3x3(iter);
                inpMat_3x3(iter) = inpMat_3x3(jter);
                inpMat_3x3(jter) = t;
            end
        end
    end
    outVal = inpMat_3x3(5);
end