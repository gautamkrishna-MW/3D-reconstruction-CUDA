
%% Computes Homography matrices 
% This is required to get rectified images from unrectified & undistored
% stereo images
% This function should get computed at compile-time as all inputs are
% compile-time constants

function [H1inv,H2inv,reprojectionMatrix] = computeHomographies(intLMat, intRMat, ...
    rotRMat, tranRMat, Cam1PrinPoint, Cam2PrinPoint, Cam1FocalLength, Cam2Trans)
%#codegen

%% Intrinciscs of the left and right cameras
kL = intLMat;
kR = intRMat;

%% Calculate translation from left to right image
translation = (-rotRMat * tranRMat')';

%% Compute R_rect
e1 = translation / norm(translation);  % divide by scalar
e2 = [-translation(2), translation(1), 0] / norm(translation(1:2));
e3 = cross(e1, e2);
R_rect = [e1; e2; e3];

%% Compute homographies
H1 = kL * (R_rect / kL);
H2 = kL * (R_rect * (rotRMat / kR));

%% Compute inverse homographies
H1inv = pinv(H1);
H2inv = pinv(H2);

%% Compute reprojection matrix
cxRight = Cam2PrinPoint(1);
cxLeft = Cam1PrinPoint(1);
cyLeft = Cam1PrinPoint(2);
fLeft = Cam1FocalLength(1);
Tx = Cam2Trans(1);
reprojectionMatrix = [1,             0,     0,       0;
                      0,             1,     0,       0;
                      0,             0,     0,   -1/Tx;
                      -cxLeft, -cyLeft, fLeft, (cxLeft-cxRight)/Tx];