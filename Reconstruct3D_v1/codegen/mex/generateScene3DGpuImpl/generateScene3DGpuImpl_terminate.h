//
// Trial License - for use to evaluate programs for possible purchase as
// an end-user only.
//
// generateScene3DGpuImpl_terminate.h
//
// Code generation for function 'generateScene3DGpuImpl_terminate'
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
void generateScene3DGpuImpl_atexit();

void generateScene3DGpuImpl_terminate();

// End of code generation (generateScene3DGpuImpl_terminate.h)
