//
// Trial License - for use to evaluate programs for possible purchase as
// an end-user only.
//
// generateScene3DGpuImpl_initialize.cu
//
// Code generation for function 'generateScene3DGpuImpl_initialize'
//

// Include files
#include "generateScene3DGpuImpl_initialize.h"
#include "_coder_generateScene3DGpuImpl_mex.h"
#include "generateScene3DGpuImpl_data.h"
#include "rt_nonfinite.h"
#include "MWCudaMemoryFunctions.hpp"
#include "MWMemoryManager.hpp"

// Function Declarations
static void generateScene3DGpuImpl_once();

// Function Definitions
static void generateScene3DGpuImpl_once()
{
  mwMemoryManagerInit(256U, 0U, 8U, 2048U);
  mwCudaMalloc(&fv_gpu_clone, static_cast<uint64_T>(sizeof(real32_T[16])));
}

void generateScene3DGpuImpl_initialize()
{
  mex_InitInfAndNan();
  mexFunctionCreateRootTLS();
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, false, 0U, nullptr);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLicenseCheckR2022a(emlrtRootTLSGlobal,
                          "EMLRT:runTime:MexFunctionNeedsLicense",
                          "distrib_computing_toolbox", 2);
  emlrtLicenseCheckR2022a(emlrtRootTLSGlobal,
                          "EMLRT:runTime:MexFunctionNeedsLicense",
                          "video_and_image_blockset", 2);
  emlrtLicenseCheckR2022a(emlrtRootTLSGlobal,
                          "EMLRT:runTime:MexFunctionNeedsLicense",
                          "image_toolbox", 2);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    generateScene3DGpuImpl_once();
  }
  emlrtInitGPU(emlrtRootTLSGlobal);
  cudaGetLastError();
}

// End of code generation (generateScene3DGpuImpl_initialize.cu)
