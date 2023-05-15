

function outImg = testCaller(leftImage,camParamStruct)

outImg = undistortImage(leftImage,cameraParameters(camParamStruct));