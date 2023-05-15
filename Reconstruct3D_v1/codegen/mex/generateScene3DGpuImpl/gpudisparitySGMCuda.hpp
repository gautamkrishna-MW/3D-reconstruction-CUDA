/* This file has the modules to calculate directional cost and estimates
 * disparity. */

// Copyright 2019 The MathWorks, Inc.

#ifndef GPUDISPARITYSGMCUDA_HPP
#define GPUDISPARITYSGMCUDA_HPP

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
const std::vector<const char*>& gpudisparitySGMCuda_ptx_kernels();
const char* gpudisparitySGMCuda_ptx_data();

/* Computes directional cost, directional cost and finds disparity from
 * sum buffer */
template <typename T>
void computeDirectionalCost(int32_T memoryMode,
                            const uint8_T penalty1,
                            const uint8_T penalty2,
                            int32_T inputHeight,
                            int32_T inputWidth,
                            int32_T outputWidth,
                            int32_T numDirections,
                            int32_T minDisparity,
                            int32_T numDisparities,
                            int32_T uniquenessThreshold,
                            T* disparityMap,
                            uint8_T* dMatchingCost,
                            uint8_T* dCostLeftToRight,
                            uint8_T* dCostTopLeftToBottomRight,
                            uint8_T* dCostTopToBottom,
                            uint8_T* dCostTopRightToBottomLeft,
                            uint8_T* dCostRightToLeft,
                            uint8_T* dCostBottomRightToTopLeft,
                            uint8_T* dCostBottomToTop,
                            uint8_T* dCostBottomLeftToTopRight,
                            uint16_T* dDirectionalCostSum) {
    static const char* ptxData = gpudisparitySGMCuda_ptx_data();
    static const std::vector<const char*>& mangledNames = gpudisparitySGMCuda_ptx_kernels<T>();
    static CUmodule module;
    static std::vector<CUfunction> kernels;
    mw_ptx_utils::initialize(ptxData, mangledNames, module, kernels);

    // Kernels ordering - required while invoking
    enum { DIRECTIONALCOST = 0, POSTPROCESS, PADDISPARITY, PADDISPARITYLAST };

    int32_T maxDisparity = minDisparity + numDisparities;

    /* Combining 4 uchars to uint32_T for processing */
    uchar4 penalty1U4Temp;
    penalty1U4Temp.x = penalty1;
    penalty1U4Temp.y = penalty1;
    penalty1U4Temp.z = penalty1;
    penalty1U4Temp.w = penalty1;
    uint32_T penalty1U4 = (*(uint32_T*)&penalty1U4Temp);

    uchar4 penalty2U4Temp;
    penalty2U4Temp.x = penalty2;
    penalty2U4Temp.y = penalty2;
    penalty2U4Temp.z = penalty2;
    penalty2U4Temp.w = penalty2;
    uint32_T penalty2U4 = (*(uint32_T*)&penalty2U4Temp);

    dim3 gridDimLeftToRight(inputHeight / 2, 1, 1);
    dim3 blockDimLeftToRight(
        WARP_SIZE * 2, 1,
        1); /* Each warp(threadBlock) does operation of one row(for LeftToRight & RightToLeft) */

    dim3 gridDimCosts(outputWidth / 2, 1, 1);
    dim3 blockDimCosts(
        WARP_SIZE * 2, 1,
        1); /* Each warp(threadBlock) does operation of one row(for LeftToRight & RightToLeft) */

    if (outputWidth & 1) {
        gridDimCosts = dim3(outputWidth, 1, 1);
        blockDimCosts = dim3(WARP_SIZE, 1, 1); /* Each warp(threadBlock) does operation of one
                                          row(for LeftToRight & RightToLeft) */
    }
    if (inputHeight & 1) {
        gridDimLeftToRight = dim3(inputHeight, 1, 1);
        blockDimLeftToRight = dim3(WARP_SIZE, 1, 1); /* Each warp(threadBlock) does operation of one
                                         row(for LeftToRight & RightToLeft) */
    }

    cudaError_t cerror = cudaSuccess;
    int32_T directionNum = 1;
    void* leftToRightCostArgs[] = {(void*)&directionNum,        (void*)&memoryMode,
                                   (void*)&dMatchingCost,       (void*)&dCostLeftToRight,
                                   (void*)&dDirectionalCostSum, (void*)&outputWidth,
                                   (void*)&inputHeight,         (void*)&numDisparities,
                                   (void*)&penalty1U4,          (void*)&penalty2U4};

    mw_ptx_utils::launchKernelWithCheck(kernels[DIRECTIONALCOST], gridDimLeftToRight,
                                        blockDimLeftToRight, leftToRightCostArgs);

    if (numDirections >= 2) {
        directionNum = 2;
        void* topLeftToRightBottomCostArgs[] = {
            (void*)&directionNum,        (void*)&memoryMode,
            (void*)&dMatchingCost,       (void*)&dCostTopLeftToBottomRight,
            (void*)&dDirectionalCostSum, (void*)&outputWidth,
            (void*)&inputHeight,         (void*)&numDisparities,
            (void*)&penalty1U4,          (void*)&penalty2U4};

        mw_ptx_utils::launchKernelWithCheck(kernels[DIRECTIONALCOST], gridDimCosts, blockDimCosts,
                                            topLeftToRightBottomCostArgs);
    }

    if (numDirections >= 3) {
        directionNum = 3;
        void* topToBottomCostArgs[] = {(void*)&directionNum,        (void*)&memoryMode,
                                       (void*)&dMatchingCost,       (void*)&dCostTopToBottom,
                                       (void*)&dDirectionalCostSum, (void*)&outputWidth,
                                       (void*)&inputHeight,         (void*)&numDisparities,
                                       (void*)&penalty1U4,          (void*)&penalty2U4};

        mw_ptx_utils::launchKernelWithCheck(kernels[DIRECTIONALCOST], gridDimCosts, blockDimCosts,
                                            topToBottomCostArgs);
    }

    if (numDirections >= 4) {
        directionNum = 4;
        void* topRightToBottomLeftCostArgs[] = {
            (void*)&directionNum,        (void*)&memoryMode,
            (void*)&dMatchingCost,       (void*)&dCostTopRightToBottomLeft,
            (void*)&dDirectionalCostSum, (void*)&outputWidth,
            (void*)&inputHeight,         (void*)&numDisparities,
            (void*)&penalty1U4,          (void*)&penalty2U4};

        mw_ptx_utils::launchKernelWithCheck(kernels[DIRECTIONALCOST], gridDimCosts, blockDimCosts,
                                            topRightToBottomLeftCostArgs);
    }

    if (numDirections >= 5) {
        directionNum = 5;
        void* rightToLeftCostArgs[] = {(void*)&directionNum,        (void*)&memoryMode,
                                       (void*)&dMatchingCost,       (void*)&dCostRightToLeft,
                                       (void*)&dDirectionalCostSum, (void*)&outputWidth,
                                       (void*)&inputHeight,         (void*)&numDisparities,
                                       (void*)&penalty1U4,          (void*)&penalty2U4};

        mw_ptx_utils::launchKernelWithCheck(kernels[DIRECTIONALCOST], gridDimLeftToRight,
                                            blockDimLeftToRight, rightToLeftCostArgs);
    }

    if (numDirections >= 6) {
        cerror = cudaMalloc(&dCostBottomRightToTopLeft,
                            sizeof(uint8_T) * outputWidth * inputHeight * numDisparities);
        if (cerror) {
            return;
        }
        directionNum = 6;
        void* bottomRightToTopLeftCostArgs[] = {
            (void*)&directionNum,        (void*)&memoryMode,
            (void*)&dMatchingCost,       (void*)&dCostBottomRightToTopLeft,
            (void*)&dDirectionalCostSum, (void*)&outputWidth,
            (void*)&inputHeight,         (void*)&numDisparities,
            (void*)&penalty1U4,          (void*)&penalty2U4};

        mw_ptx_utils::launchKernelWithCheck(kernels[DIRECTIONALCOST], gridDimCosts, blockDimCosts,
                                            bottomRightToTopLeftCostArgs);
    }

    if (numDirections >= 7) {
        cerror = cudaMalloc(&dCostBottomToTop,
                            sizeof(uint8_T) * outputWidth * inputHeight * numDisparities);
        if (cerror) {
            return;
        }
        directionNum = 7;
        void* bottomToTopCostArgs[] = {(void*)&directionNum,        (void*)&memoryMode,
                                       (void*)&dMatchingCost,       (void*)&dCostBottomToTop,
                                       (void*)&dDirectionalCostSum, (void*)&outputWidth,
                                       (void*)&inputHeight,         (void*)&numDisparities,
                                       (void*)&penalty1U4,          (void*)&penalty2U4};

        mw_ptx_utils::launchKernelWithCheck(kernels[DIRECTIONALCOST], gridDimCosts, blockDimCosts,
                                            bottomToTopCostArgs);
    }

    if (numDirections == 8) {
        cerror = cudaMalloc(&dCostBottomLeftToTopRight,
                            sizeof(uint8_T) * outputWidth * inputHeight * numDisparities);
        if (cerror) {
            return;
        }
        directionNum = 8;
        void* bottomLeftToTopRightCostArgs[] = {
            (void*)&directionNum,        (void*)&memoryMode,
            (void*)&dMatchingCost,       (void*)&dCostBottomLeftToTopRight,
            (void*)&dDirectionalCostSum, (void*)&outputWidth,
            (void*)&inputHeight,         (void*)&numDisparities,
            (void*)&penalty1U4,          (void*)&penalty2U4};

        mw_ptx_utils::launchKernelWithCheck(kernels[DIRECTIONALCOST], gridDimCosts, blockDimCosts,
                                            bottomLeftToTopRightCostArgs);
    }

    dim3 gridDimDisparity(outputWidth, inputHeight);
    dim3 blockDimDisparity(WARP_SIZE, 1);

    /* Directional Costs sum and disparity computation */
    if (maxDisparity >= 0) {
        float* dDisparityMapPtr = disparityMap + maxDisparity;
        void* disparityMapKernelArgs[] = {(void*)&memoryMode,
                                          (void*)&dCostLeftToRight,
                                          (void*)&dCostRightToLeft,
                                          (void*)&dCostTopToBottom,
                                          (void*)&dCostBottomToTop,
                                          (void*)&dCostTopLeftToBottomRight,
                                          (void*)&dCostTopRightToBottomLeft,
                                          (void*)&dCostBottomLeftToTopRight,
                                          (void*)&dCostBottomRightToTopLeft,
                                          (void*)&dDirectionalCostSum,
                                          (void*)&dDisparityMapPtr,
                                          (void*)&outputWidth,
                                          (void*)&inputHeight,
                                          (void*)&inputWidth,
                                          (void*)&numDisparities,
                                          (void*)&numDirections,
                                          (void*)&uniquenessThreshold,
                                          (void*)&minDisparity};

        mw_ptx_utils::launchKernelWithCheck(kernels[POSTPROCESS], gridDimDisparity,
                                            blockDimDisparity, disparityMapKernelArgs);
    } else {
        void* disparityMapKernelArgs[] = {(void*)&memoryMode,
                                          (void*)&dCostLeftToRight,
                                          (void*)&dCostRightToLeft,
                                          (void*)&dCostTopToBottom,
                                          (void*)&dCostBottomToTop,
                                          (void*)&dCostTopLeftToBottomRight,
                                          (void*)&dCostTopRightToBottomLeft,
                                          (void*)&dCostBottomLeftToTopRight,
                                          (void*)&dCostBottomRightToTopLeft,
                                          (void*)&dDirectionalCostSum,
                                          (void*)&disparityMap,
                                          (void*)&outputWidth,
                                          (void*)&inputHeight,
                                          (void*)&inputWidth,
                                          (void*)&numDisparities,
                                          (void*)&numDirections,
                                          (void*)&uniquenessThreshold,
                                          (void*)&minDisparity};

        mw_ptx_utils::launchKernelWithCheck(kernels[POSTPROCESS], gridDimDisparity,
                                            blockDimDisparity, disparityMapKernelArgs);
    }

    dim3 gridDimPadding(inputHeight, 1);
    dim3 blockDimPadding(maxDisparity, 1);

    /* Padding the first maximum disparity columns with NaN */
    if (maxDisparity > 0) {
        void* padDisparityArgs[] = {&disparityMap, (void*)&inputWidth};
        mw_ptx_utils::launchKernelWithCheck(kernels[PADDISPARITY], gridDimPadding, blockDimPadding,
                                            padDisparityArgs);
    }

    if (minDisparity < 0) {
        gridDimPadding = dim3(inputHeight, 1);
        blockDimPadding = dim3(-minDisparity, 1);
        void* padDisparityLastArgs[] = {&disparityMap, (void*)&inputWidth};
        mw_ptx_utils::launchKernelWithCheck(kernels[PADDISPARITYLAST], gridDimPadding,
                                            blockDimPadding, padDisparityLastArgs);
    }
}
#endif