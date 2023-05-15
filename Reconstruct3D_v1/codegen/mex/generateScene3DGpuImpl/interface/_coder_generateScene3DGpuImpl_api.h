//
// Trial License - for use to evaluate programs for possible purchase as
// an end-user only.
//
// _coder_generateScene3DGpuImpl_api.h
//
// Code generation for function '_coder_generateScene3DGpuImpl_api'
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
void generateScene3DGpuImpl_api(const mxArray *const prhs[13], int32_T nlhs,
                                const mxArray *plhs[4]);

// End of code generation (_coder_generateScene3DGpuImpl_api.h)
