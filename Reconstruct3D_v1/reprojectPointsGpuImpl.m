

function pts3DOut = reprojectPointsGpuImpl(disparityMap,reprojMat)
%#codegen

[nRows,nCols] = size(disparityMap);

% Generate Meshgrids
[xCoord,yCoord] = meshgrid(1:nCols,1:nRows);

% Stack points
pts3DHomogeneous = coder.nullcopy(zeros(nRows*nCols,4,'single'));
coder.gpu.kernel;
for iter = 1:nRows*nCols
    pts3DHomogeneous(iter,:) = [xCoord(iter),yCoord(iter),disparityMap(iter),1];
end

% Reprojection
pts3DHomogeneousReproject = pts3DHomogeneous*reprojMat;
pts3D = coder.nullcopy(zeros(nRows*nCols,3,'single'));
coder.gpu.kernel;
for iter = 1:nRows*nCols
    pts3D(iter,:) = [pts3DHomogeneousReproject(iter,1)./pts3DHomogeneousReproject(iter,4),...
        pts3DHomogeneousReproject(iter,2)./pts3DHomogeneousReproject(iter,4),...
        pts3DHomogeneousReproject(iter,3)./pts3DHomogeneousReproject(iter,4)];
    if (disparityMap(iter)==-realmax('single'))
        pts3D(iter,:) = [NaN,NaN,NaN];
    end
end

% Points of Cloud
pts3DOut = reshape(pts3D,[nRows,nCols,3]);