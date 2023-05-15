//
// Trial License - for use to evaluate programs for possible purchase as
// an end-user only.
//
// generateScene3DGpuImpl.h
//
// Code generation for function 'generateScene3DGpuImpl'
//

#pragma once

// Include files
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// Custom Header Code

#ifdef __CUDA_ARCH__
#undef printf
#endif

// Function Declarations
void generateScene3DGpuImpl(const uint8_T leftImage[2073600],
                            const uint8_T rightImage[2073600],
                            uint8_T leftRect[2073600],
                            uint8_T rightRect[2073600],
                            real32_T disparityMap[2073600],
                            real32_T pts3DOut[6220800]);

// End of code generation (generateScene3DGpuImpl.h)
