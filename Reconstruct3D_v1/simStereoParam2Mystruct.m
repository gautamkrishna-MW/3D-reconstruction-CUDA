

function myStereoStruct = simStereoParam2Mystruct(stereoParams)

% Radial distortion coefficients
myStereoStruct.Cam1RadialCoeff = stereoParams.CameraParameters1.Intrinsics.RadialDistortion;
myStereoStruct.Cam2RadialCoeff = stereoParams.CameraParameters2.Intrinsics.RadialDistortion;

% Tangential distortion coefficients
myStereoStruct.Cam1TanCoeff = stereoParams.CameraParameters1.Intrinsics.TangentialDistortion;
myStereoStruct.Cam2TanCoeff = stereoParams.CameraParameters2.Intrinsics.TangentialDistortion;

% Focal length
myStereoStruct.Cam1FocalLength = stereoParams.CameraParameters1.Intrinsics.FocalLength;
myStereoStruct.Cam2FocalLength = stereoParams.CameraParameters2.Intrinsics.FocalLength;

% Principal Point
myStereoStruct.Cam1PrinPoint = stereoParams.CameraParameters1.Intrinsics.PrincipalPoint;
myStereoStruct.Cam2PrinPoint = stereoParams.CameraParameters2.Intrinsics.PrincipalPoint;

% Intrinsics Mat
myStereoStruct.Cam1KMat = stereoParams.CameraParameters1.Intrinsics.K;
myStereoStruct.Cam2KMat = stereoParams.CameraParameters2.Intrinsics.K;

% Camera Rotation and Translation
myStereoStruct.Cam2Rot = stereoParams.RotationOfCamera2;
myStereoStruct.Cam2Trans = stereoParams.TranslationOfCamera2;