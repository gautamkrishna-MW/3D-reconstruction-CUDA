//
// Trial License - for use to evaluate programs for possible purchase as
// an end-user only.
//
// generateScene3DGpuImpl_terminate.cu
//
// Code generation for function 'generateScene3DGpuImpl_terminate'
//

// Include files
#include "generateScene3DGpuImpl_terminate.h"
#include "_coder_generateScene3DGpuImpl_mex.h"
#include "generateScene3DGpuImpl_data.h"
#include "rt_nonfinite.h"
#include "MWCudaMemoryFunctions.hpp"
#include "MWMemoryManager.hpp"

// Function Definitions
void generateScene3DGpuImpl_atexit()
{
  mexFunctionCreateRootTLS();
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
  mwCudaFree(&(*fv_gpu_clone)[0]);
}

void generateScene3DGpuImpl_terminate()
{
  cudaError_t errCode;
  errCode = cudaGetLastError();
  if (errCode != cudaSuccess) {
    emlrtThinCUDAError(static_cast<uint32_T>(errCode),
                       (char_T *)cudaGetErrorString(errCode),
                       (char_T *)cudaGetErrorName(errCode),
                       (char_T *)"SafeBuild", emlrtRootTLSGlobal);
  }
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  mwMemoryManagerTerminate();
}

// End of code generation (generateScene3DGpuImpl_terminate.cu)
