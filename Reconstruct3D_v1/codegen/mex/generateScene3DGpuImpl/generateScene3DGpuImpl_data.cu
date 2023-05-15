//
// Trial License - for use to evaluate programs for possible purchase as
// an end-user only.
//
// generateScene3DGpuImpl_data.cu
//
// Code generation for function 'generateScene3DGpuImpl_data'
//

// Include files
#include "generateScene3DGpuImpl_data.h"
#include "rt_nonfinite.h"

// Variable Definitions
emlrtCTX emlrtRootTLSGlobal{nullptr};

emlrtContext emlrtContextGlobal{
    true,                                                 // bFirstTime
    false,                                                // bInitialized
    131627U,                                              // fVersionInfo
    nullptr,                                              // fErrorFunction
    "generateScene3DGpuImpl",                             // fFunctionName
    nullptr,                                              // fRTCallStack
    false,                                                // bDebugMode
    {1923742000U, 3061539680U, 1111991344U, 4173687913U}, // fSigWrd
    nullptr                                               // fSigMem
};

real32_T (*fv_gpu_clone)[16];

// End of code generation (generateScene3DGpuImpl_data.cu)
