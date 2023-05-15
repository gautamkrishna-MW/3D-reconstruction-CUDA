//
// Trial License - for use to evaluate programs for possible purchase as
// an end-user only.
//
// _coder_generateScene3DGpuImpl_mex.cu
//
// Code generation for function '_coder_generateScene3DGpuImpl_mex'
//

// Include files
#include "_coder_generateScene3DGpuImpl_mex.h"
#include "_coder_generateScene3DGpuImpl_api.h"
#include "generateScene3DGpuImpl_data.h"
#include "generateScene3DGpuImpl_initialize.h"
#include "generateScene3DGpuImpl_terminate.h"
#include "rt_nonfinite.h"
#include <stdexcept>

void emlrtExceptionBridge();
void emlrtExceptionBridge()
{
  throw std::runtime_error("");
}
// Function Definitions
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&generateScene3DGpuImpl_atexit);
  // Module initialization.
  generateScene3DGpuImpl_initialize();
  try {
    // Dispatch the entry-point.
    unsafe_generateScene3DGpuImpl_mexFunction(nlhs, plhs, nrhs, prhs);
    // Module termination.
    generateScene3DGpuImpl_terminate();
  } catch (...) {
    emlrtCleanupOnException((emlrtCTX *)emlrtRootTLSGlobal);
    throw;
  }
}

emlrtCTX mexFunctionCreateRootTLS()
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, nullptr, 1,
                           (void *)&emlrtExceptionBridge, "windows-1252", true);
  return emlrtRootTLSGlobal;
}

void unsafe_generateScene3DGpuImpl_mexFunction(int32_T nlhs, mxArray *plhs[4],
                                               int32_T nrhs,
                                               const mxArray *prhs[13])
{
  const mxArray *outputs[4];
  int32_T b;
  // Check for proper number of arguments.
  if (nrhs < 13) {
    emlrtErrMsgIdAndTxt(
        emlrtRootTLSGlobal, "EMLRT:runTime:TooFewInputsConstants", 9, 4, 22,
        "generateScene3DGpuImpl", 4, 22, "generateScene3DGpuImpl", 4, 22,
        "generateScene3DGpuImpl");
  }
  if (nrhs != 13) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal, "EMLRT:runTime:WrongNumberOfInputs",
                        5, 12, 13, 4, 22, "generateScene3DGpuImpl");
  }
  if (nlhs > 4) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal,
                        "EMLRT:runTime:TooManyOutputArguments", 3, 4, 22,
                        "generateScene3DGpuImpl");
  }
  // Call the function.
  generateScene3DGpuImpl_api(prhs, nlhs, outputs);
  // Copy over outputs to the caller.
  if (nlhs < 1) {
    b = 1;
  } else {
    b = nlhs;
  }
  emlrtReturnArrays(b, &plhs[0], &outputs[0]);
}

// End of code generation (_coder_generateScene3DGpuImpl_mex.cu)
