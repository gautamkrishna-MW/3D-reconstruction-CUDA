/* This file has the modules to calculate Matching cost in the
 * disparitySGM algorithm. */

// Copyright 2019 The MathWorks, Inc.

#ifndef GPUDISPARITYSGMCOSTCUDA_HPP
#define GPUDISPARITYSGMCOSTCUDA_HPP

#ifdef MATLAB_MEX_FILE
#include "tmwtypes.h"
#else
#include "rtwtypes.h"
#endif

#include "MWPtxUtils.hpp"
#include "gpudisparitySGMConfig.hpp"

#include <cuda.h>
#include <stdio.h>

template <typename T>
const std::vector<const char*>& gpudisparitySGMCostCuda_ptx_kernels();
const char* gpudisparitySGMCostCuda_ptx_data();

/* Computes Census transform for stereo pair and Matching cost */
template <typename T>
void computeCensusMatchingCost(int32_T inputHeight,
                               int32_T inputWidth,
                               int32_T outputWidth,
                               int32_T maxDisparity,
                               int32_T numDisparities,
                               uint8_T const* leftImage,
                               uint8_T const* rightImage,
                               T* disparityMap,
                               uint8_T* dMatchingCost,
                               uint32_T* dLeftCensusTransform,
                               uint32_T* dRightCensusTransform) {
    static const char* ptxData = gpudisparitySGMCostCuda_ptx_data();
    static const std::vector<const char*>& mangledNames = gpudisparitySGMCostCuda_ptx_kernels<T>();
    static CUmodule module;
    static std::vector<CUfunction> kernels;
    mw_ptx_utils::initialize(ptxData, mangledNames, module, kernels);

    // Kernels ordering - required while invoking
    enum { CENSUSTRANSFORM = 0, HAMMINGDISTANCE };

    /* Census Transform Kernel launch configuration */
    dim3 blockDimCensus(WARP_SIZE, WARP_SIZE, 1);
    dim3 gridDimCensus((inputWidth - 1) / WARP_SIZE + 1, (inputHeight - 1) / WARP_SIZE + 1, 1);

    /* Left census kernel arguments */
    void* censusTransformKernelArgs1[] = {&leftImage, &dLeftCensusTransform, (void*)&inputWidth,
                                          (void*)&inputHeight};
    mw_ptx_utils::launchKernelWithCheck(kernels[CENSUSTRANSFORM], // from the enum
                                        gridDimCensus, blockDimCensus, censusTransformKernelArgs1,
                                        TILE_W * TILE_H);

    /* Right census kernel arguments */
    void* censusTransformKernelArgs2[] = {&rightImage, &dRightCensusTransform, (void*)&inputWidth,
                                          (void*)&inputHeight};
    mw_ptx_utils::launchKernelWithCheck(kernels[CENSUSTRANSFORM], // from the enum
                                        gridDimCensus, blockDimCensus, censusTransformKernelArgs2,
                                        TILE_W * TILE_H);

    /* Matching Cost Kernel launch configuration */
    dim3 blockDimMatchingCost(numDisparities, 1, 1); /* Each thread Block serves one row */
    dim3 gridDimMatchingCost(1, inputHeight, 1);

    if (maxDisparity >= 0) {
        uint32_T* dLeftCensusPtr = dLeftCensusTransform + maxDisparity;
        uint32_T* dRightCensusPtr = dRightCensusTransform + 1;
        void* MatchingCostKernelArgs[] = {
            &dLeftCensusPtr,     &dRightCensusPtr,    &dMatchingCost,         (void*)&inputWidth,
            (void*)&inputHeight, (void*)&outputWidth, (void*)&numDisparities, (void*)&maxDisparity};

        mw_ptx_utils::launchKernelWithCheck(kernels[HAMMINGDISTANCE], // from the enum
                                            gridDimMatchingCost, blockDimMatchingCost,
                                            MatchingCostKernelArgs,
                                            3 * numDisparities * sizeof(uint32_T));
    } else {
        uint32_T* dRightCensusPtr = dRightCensusTransform + 1;
        void* MatchingCostKernelArgs[] = {&dLeftCensusTransform,  &dRightCensusPtr,
                                          &dMatchingCost,         (void*)&inputWidth,
                                          (void*)&inputHeight,    (void*)&outputWidth,
                                          (void*)&numDisparities, (void*)&maxDisparity};

        mw_ptx_utils::launchKernelWithCheck(kernels[HAMMINGDISTANCE], // from the enum
                                            gridDimMatchingCost, blockDimMatchingCost,
                                            MatchingCostKernelArgs,
                                            3 * numDisparities * sizeof(uint32_T));
    }
}
#endif
