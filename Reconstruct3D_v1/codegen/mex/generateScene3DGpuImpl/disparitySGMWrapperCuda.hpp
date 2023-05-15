/* This file is the entry point file to CUDA code for disparitySGM
 * GPU code generation. */

// Copyright 2019 The MathWorks, Inc.

#ifndef DISPARITYSGMWRAPPERCUDA_HPP
#define DISPARITYSGMWRAPPERCUDA_HPP

#include "gpudisparitySGMCuda.hpp"
#include "gpudisparitySGMCostCuda.hpp"

/* Entry point function, which gets pointer of all intermediate variables
 * and invokes functions which computes disparity  */
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
                      uint8_T* gpuWorkspace);
#endif
