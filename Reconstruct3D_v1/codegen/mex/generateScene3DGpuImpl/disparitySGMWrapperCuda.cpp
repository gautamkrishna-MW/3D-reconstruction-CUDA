/* This file is the entry point file to CUDA code for disparitySGM
 * GPU code generation. */

// Copyright 2019 The MathWorks, Inc.

#include "disparitySGMWrapperCuda.hpp"

void computeDisparity(int32_T memoryMode,
                      const uint8_T penalty1,
                      const uint8_T penalty2,
                      int32_T inputHeight,
                      int32_T inputWidth,
                      int32_T numDirections,
                      int32_T minDisparity,
                      int32_T numDisparities,
                      int32_T uniquenessThreshold,
                      uint8_T const* leftImage,
                      uint8_T const* rightImage,
                      float* disparityMap,
                      uint8_T* gpuWorkspace) {

    /* Maximum Disparity */
    int32_T maxDisparity = minDisparity + numDisparities;

    /* Calculate the width of pixels for which Matching Cost and
     directional cost are calculated */
    int32_T outputWidth = 0;
    if (minDisparity < 0) {
        outputWidth = inputWidth - numDisparities;
        if (maxDisparity < 0) {
            outputWidth = inputWidth + minDisparity;
        }
    } else {
        outputWidth = inputWidth - maxDisparity;
    }

    /* Census and Matching cost image sizes */
    size_t censusTransformSize = inputWidth * inputHeight;
    size_t costImageSize = outputWidth * inputHeight * numDisparities;

    /* Census transform and Matching cost image pointers */
    uint32_T* dLeftCensusTransform = NULL;
    uint32_T* dRightCensusTransform = NULL;
    uint8_T* dMatchingCost = NULL;

    /* Directional cost pointer variables */
    uint8_T* dCostLeftToRight = NULL;
    uint8_T* dCostTopLeftToBottomRight = NULL;
    uint8_T* dCostTopToBottom = NULL;
    uint8_T* dCostTopRightToBottomLeft = NULL;
    uint8_T* dCostRightToLeft = NULL;
    uint8_T* dCostBottomRightToTopLeft = NULL;
    uint8_T* dCostBottomToTop = NULL;
    uint8_T* dCostBottomLeftToTopRight = NULL;
    uint16_T* dDirectionalCostSum = NULL;

    /* Left Census Transform buffer */
    dLeftCensusTransform = (uint32_T*)(gpuWorkspace);

    /* Right Census Transform buffer */
    dRightCensusTransform = dLeftCensusTransform + censusTransformSize;

    /* Matching cost buffer - hamming distance */
    dMatchingCost = gpuWorkspace + censusTransformSize * sizeof(uint32_T) * 2;

    if (memoryMode) // High memory
    {
        /* leftToRight directional cost buffer */
        dCostLeftToRight = dMatchingCost + costImageSize;

        if (numDirections >= 2) {
            /* topLeftToBottomRight directional cost buffer */
            dCostTopLeftToBottomRight = dCostLeftToRight + costImageSize;
        }

        if (numDirections >= 3) {
            /* topToBottom directional cost buffer */
            dCostTopToBottom = dCostTopLeftToBottomRight + costImageSize;
        }

        if (numDirections >= 4) {
            /* topRightToBottomLeft directional cost buffer */
            dCostTopRightToBottomLeft = dCostTopToBottom + costImageSize;
        }

        if (numDirections >= 5) {
            /* rightToLeft directional cost buffer */
            dCostRightToLeft = dCostTopRightToBottomLeft + costImageSize;
        }

        if (numDirections >= 6) {
            /* bottomRightToTopLeft directional cost buffer */
            dCostBottomRightToTopLeft = dCostRightToLeft + costImageSize;
        }

        if (numDirections >= 7) {
            /* bottomToTop directional cost buffer */
            dCostBottomToTop = dCostBottomRightToTopLeft + costImageSize;
        }

        if (numDirections == 8) {
            /* bottomLeftToTopRight
           directional cost buffer */
            dCostBottomLeftToTopRight = dCostBottomToTop + costImageSize;
        }
    } else // low memory
    {
        dDirectionalCostSum = (uint16_t*)(dMatchingCost + costImageSize);
    }

    computeCensusMatchingCost(inputHeight, inputWidth, outputWidth, maxDisparity, numDisparities,
                              leftImage, rightImage, disparityMap, dMatchingCost,
                              dLeftCensusTransform, dRightCensusTransform);

    computeDirectionalCost(memoryMode, penalty1, penalty2, inputHeight, inputWidth, outputWidth,
                           numDirections, minDisparity, numDisparities, uniquenessThreshold,
                           disparityMap, dMatchingCost, dCostLeftToRight, dCostTopLeftToBottomRight,
                           dCostTopToBottom, dCostTopRightToBottomLeft, dCostRightToLeft,
                           dCostBottomRightToTopLeft, dCostBottomToTop, dCostBottomLeftToTopRight,
                           dDirectionalCostSum);
}
