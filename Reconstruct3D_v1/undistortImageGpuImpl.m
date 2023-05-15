
% Simple forward undistortion implementation (may contain holes)

function [outLeft_uint8,outRight_uint8] = undistortImageGpuImpl(leftImage, rightImage, ...
    leftRCoeff, rightRCoeff, leftTanCoeff, rightTanCoeff, focalLengthL, focalLengthR, ...
    prinAxesL, prinAxesR)
%#codegen

%% Input sizes
[numRows,numCols,~] = size(leftImage);
numRows = single(numRows);
numCols = single(numCols);

%% Allocate output matrices
outLeft_uint8 = leftImage;
outRight_uint8 = rightImage;

%% Apply Radial and Tangential Coeffs
coder.gpu.kernel;
for colIter = 1:numCols
    for rowIter = 1:numRows
        
        %% Left Image
        colIterL = single(colIter - prinAxesL(1)) / focalLengthL(1);
        rowIterL = single(rowIter - prinAxesL(2)) / focalLengthL(2);

        % r = sqrt(rowIter*rowIter + colIter*colIter);
        r_2 = rowIterL*rowIterL + colIterL*colIterL;
        r_4 = r_2*r_2;  r_6 = r_4*r_2;

        % Radial
        radMultL = single(1 + leftRCoeff(1)*r_2 + leftRCoeff(2)*r_4 + leftRCoeff(3)*r_6);
        outRowL = rowIterL*radMultL;
        outColL = colIterL*radMultL;

        % Tangential
        xy2 = 2*rowIterL*colIterL;
        ry_2 = r_2 + 2*rowIterL*rowIterL;
        rx_2 = r_2 + 2*colIterL*colIterL;

        outRowL = outRowL + xy2*leftTanCoeff(2) + leftTanCoeff(1)*ry_2;
        outColL = outColL + xy2*leftTanCoeff(1) + leftTanCoeff(2)*rx_2;

        %% Right Image
        colIterR = single(colIter - prinAxesR(1)) / focalLengthR(1);
        rowIterR = single(rowIter - prinAxesR(2)) / focalLengthR(2);

        % r = sqrt(rowIter*rowIter + colIter*colIter);
        r_2 = rowIterR*rowIterR + colIterR*colIterR;
        r_4 = r_2*r_2;  r_6 = r_4*r_2;
        
        % Radial
        radMultR = single(1 + rightRCoeff(1)*r_2 + rightRCoeff(2)*r_4 + rightRCoeff(3)*r_6);
        outRowR = rowIterR*radMultR;
        outColR = colIterR*radMultR;

        % Tangential
        xy2 = 2*rowIterR*colIterR;
        ry_2 = r_2 + 2*rowIterR*rowIterR;
        rx_2 = r_2 + 2*colIterR*colIterR;

        outRowR = outRowR + xy2*rightTanCoeff(2) + rightTanCoeff(1)*ry_2;
        outColR = outColR + xy2*rightTanCoeff(1) + rightTanCoeff(2)*rx_2;

        %% Map back
        outColL = outColL*focalLengthL(1) + prinAxesL(1);
        outRowL = outRowL*focalLengthL(2) + prinAxesL(2);

        outColR = outColR*focalLengthR(1) + prinAxesR(1);
        outRowR = outRowR*focalLengthR(2) + prinAxesR(2);
        
        % Interpolation
        if outRowL >= numRows
            outRowL = numRows-1;
        elseif outRowL < 1
            outRowL = single(1);
        end
        if outRowR >= numRows
            outRowR = numRows-1;
        elseif outRowR < 1
            outRowR = single(1);
        end
        if outColL >= numCols
            outColL = numCols-1;
        elseif outColL < 1
            outColL = single(1);
        end
        if outColR >= numCols
            outColR = numCols-1;
        elseif outColR < 1
            outColR = single(1);
        end

        % Interpolation for left image
        i1L = single(leftImage(floor(outRowL),  floor(outColL)));
        i2L = single(leftImage(floor(outRowL)+1,floor(outColL)));
        i3L = single(leftImage(floor(outRowL),  floor(outColL)+1));
        i4L = single(leftImage(floor(outRowL)+1,floor(outColL)+1));
        dU = outRowL-floor(outRowL);
        dV = outColL-floor(outColL);
        outLeftVal = i1L*(1-dU)*(1-dV) + i2L*dU*(1-dV) + i3L*(1-dU)*dV + i4L*dU*dV;
        outLeft_uint8(rowIter,colIter) = cast(outLeftVal,'like',leftImage);

        % Interpolation for right image
        i1R = single(rightImage(floor(outRowR),  floor(outColR)));
        i2R = single(rightImage(floor(outRowR)+1,floor(outColR)));
        i3R = single(rightImage(floor(outRowR),  floor(outColR)+1));
        i4R = single(rightImage(floor(outRowR)+1,floor(outColR)+1));
        dU = outRowR-floor(outRowR);
        dV = outColR-floor(outColR);
        outRightVal = i1R*(1-dU)*(1-dV) + i2R*dU*(1-dV) + i3R*(1-dU)*dV + i4R*dU*dV;
        outRight_uint8(rowIter,colIter) = cast(outRightVal,'like',rightImage);
    end
end