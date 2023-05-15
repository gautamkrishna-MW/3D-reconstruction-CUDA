
function [leftRect, rightRect] = imwarpGpuImpl(leftImage, leftInvTformMat, rightImage, rightInvTformMat)
%#codegen

leftRect = zeros(size(leftImage),'like',leftImage);
rightRect = zeros(size(rightImage),'like',rightImage);

[numRows,numCols,~] = size(leftImage);

%% Performing inverse mapping and bilinear interpolation
coder.gpu.kernel
for rowIter = 1:numRows
    for colIter = 1:numCols
        % Left Image
        inpPointL = single(leftInvTformMat) * single([colIter;rowIter;1]);
        inpColL = inpPointL(1)/inpPointL(3);
        inpRowL = inpPointL(2)/inpPointL(3);

        % Right Image
        inpPointR = single(rightInvTformMat) * single([colIter;rowIter;1]);
        inpColR = inpPointR(1)/inpPointR(3);
        inpRowR = inpPointR(2)/inpPointR(3);

        % Bounds Check Left
        if (inpRowL > 1 && inpRowL <= numRows && inpColL > 1 && inpColL <= numCols)
            i1L = leftImage(floor(inpRowL),  floor(inpColL));
        else
            i1L = cast(0,'like',leftImage);
        end

        if (inpRowL > 1 && inpRowL <= numRows-1 && inpColL > 1 && inpColL <= numCols)
            i2L = leftImage(floor(inpRowL)+1,  floor(inpColL));
        else
            i2L = cast(0,'like',leftImage);
        end

        if (inpRowL > 1 && inpRowL <= numRows && inpColL > 1 && inpColL <= numCols-1)
            i3L = leftImage(floor(inpRowL),  floor(inpColL)+1);
        else
            i3L = cast(0,'like',leftImage);
        end

        if (inpRowL > 1 && inpRowL <= numRows-1 && inpColL > 1 && inpColL <= numCols-1)
            i4L = leftImage(floor(inpRowL)+1,  floor(inpColL)+1);
        else
            i4L = cast(0,'like',leftImage);
        end

        % Bounds Check Right
        if (inpRowR > 1 && inpRowR <= numRows && inpColR > 1 && inpColR <= numCols)
            i1R = rightImage(floor(inpRowR),  floor(inpColR));
        else
            i1R = cast(0,'like',rightImage);
        end

        if (inpRowR > 1 && inpRowR <= numRows-1 && inpColR > 1 && inpColR <= numCols)
            i2R = rightImage(floor(inpRowR)+1,  floor(inpColR));
        else
            i2R = cast(0,'like',rightImage);
        end

        if (inpRowR > 1 && inpRowR <= numRows && inpColR > 1 && inpColR <= numCols-1)
            i3R = rightImage(floor(inpRowR),  floor(inpColR)+1);
        else
            i3R = cast(0,'like',rightImage);
        end

        if (inpRowR > 1 && inpRowR <= numRows-1 && inpColR > 1 && inpColR <= numCols-1)
            i4R = rightImage(floor(inpRowR)+1,  floor(inpColR)+1);
        else
            i4R = cast(0,'like',rightImage);
        end

        % Interpolation for left image
        dU = inpRowL-floor(inpRowL);
        dV = inpColL-floor(inpColL);
        outLeftVal = single(i1L)*(1-dU)*(1-dV) + single(i2L)*dU*(1-dV) + ...
            single(i3L)*(1-dU)*dV + single(i4L)*dU*dV;
        leftRect(rowIter,colIter) = cast(outLeftVal,'like',leftImage);

        % Interpolation for right image
        dU = inpRowR-floor(inpRowR);
        dV = inpColR-floor(inpColR);
        outRightVal = single(i1R)*(1-dU)*(1-dV) + single(i2R)*dU*(1-dV) + ...
            single(i3R)*(1-dU)*dV + single(i4R)*dU*dV;
        rightRect(rowIter,colIter) = cast(outRightVal,'like',rightImage);
    end
end