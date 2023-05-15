

function inpDispMap = holeFillGpuImpl(inpDispMap, disparityRange)
%#codegen

coder.gpu.kernelfun;
[numRows,numCols] = size(inpDispMap);
globalConvergenceFlag = true;

coder.gpu.kernel;
for iter = 1:numel(inpDispMap)
    if (inpDispMap(iter) == 0)
        inpDispMap(iter) = -Inf;
    elseif (inpDispMap(iter) == 39)
        inpDispMap(iter) = Inf;
    end
end

coder.gpu.nokernel;
while (globalConvergenceFlag)
    globalConvergenceFlag = false;
    coder.gpu.kernel;
    for colIter = disparityRange(1)+1:numCols-1
        coder.gpu.kernel;
        for rowIter = 2:numRows-1
            % Thread checks for NaN in N-8 and if found one, runs the
            % algorithm one more time.
            if isinf(inpDispMap(rowIter,colIter))
                globalConvergenceFlag = true;
                sumIntensities = single(0);
                countIntensities = 0;
                for subCol = -1:1
                    for subRow = -1:1
                        if ~isinf(inpDispMap(rowIter+subRow,colIter+subCol))
                            sumIntensities = sumIntensities + inpDispMap(rowIter+subRow,colIter+subCol);
                            countIntensities = countIntensities + 1;
                        end
                    end
                end
                if countIntensities > 0
                    inpDispMap(rowIter,colIter) = sumIntensities/countIntensities;
                end
            end
        end
    end
end
end