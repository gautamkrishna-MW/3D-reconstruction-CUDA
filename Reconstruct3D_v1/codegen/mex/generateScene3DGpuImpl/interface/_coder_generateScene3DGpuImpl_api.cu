//
// Trial License - for use to evaluate programs for possible purchase as
// an end-user only.
//
// _coder_generateScene3DGpuImpl_api.cu
//
// Code generation for function '_coder_generateScene3DGpuImpl_api'
//

// Include files
#include "_coder_generateScene3DGpuImpl_api.h"
#include "generateScene3DGpuImpl.h"
#include "generateScene3DGpuImpl_data.h"
#include "rt_nonfinite.h"

// Function Declarations
static uint8_T (*b_emlrt_marshallIn(const mxArray *src,
                                    const emlrtMsgIdentifier *msgId))[2073600];

static const mxArray *b_emlrt_marshallOut(const real32_T u[6220800]);

static uint8_T (*emlrt_marshallIn(const mxArray *leftImage,
                                  const char_T *identifier))[2073600];

static uint8_T (*emlrt_marshallIn(const mxArray *u,
                                  const emlrtMsgIdentifier *parentId))[2073600];

static const mxArray *emlrt_marshallOut(const uint8_T u[2073600]);

static const mxArray *emlrt_marshallOut(const real32_T u[2073600]);

// Function Definitions
static uint8_T (*b_emlrt_marshallIn(const mxArray *src,
                                    const emlrtMsgIdentifier *msgId))[2073600]
{
  static const int32_T dims[2]{1080, 1920};
  uint8_T(*ret)[2073600];
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "uint8", false, 2U,
                          (const void *)&dims[0]);
  ret = (uint8_T(*)[2073600])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static const mxArray *b_emlrt_marshallOut(const real32_T u[6220800])
{
  static const int32_T iv[3]{0, 0, 0};
  static const int32_T iv1[3]{1080, 1920, 3};
  const mxArray *m;
  const mxArray *y;
  y = nullptr;
  m = emlrtCreateNumericArray(3, (const void *)&iv[0], mxSINGLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 3);
  emlrtAssign(&y, m);
  return y;
}

static uint8_T (*emlrt_marshallIn(const mxArray *leftImage,
                                  const char_T *identifier))[2073600]
{
  emlrtMsgIdentifier thisId;
  uint8_T(*y)[2073600];
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  y = emlrt_marshallIn(emlrtAlias(leftImage), &thisId);
  emlrtDestroyArray(&leftImage);
  return y;
}

static uint8_T (*emlrt_marshallIn(const mxArray *u,
                                  const emlrtMsgIdentifier *parentId))[2073600]
{
  uint8_T(*y)[2073600];
  y = b_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static const mxArray *emlrt_marshallOut(const uint8_T u[2073600])
{
  static const int32_T iv[2]{0, 0};
  static const int32_T iv1[2]{1080, 1920};
  const mxArray *m;
  const mxArray *y;
  y = nullptr;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxUINT8_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 2);
  emlrtAssign(&y, m);
  return y;
}

static const mxArray *emlrt_marshallOut(const real32_T u[2073600])
{
  static const int32_T iv[2]{0, 0};
  static const int32_T iv1[2]{1080, 1920};
  const mxArray *m;
  const mxArray *y;
  y = nullptr;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxSINGLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 2);
  emlrtAssign(&y, m);
  return y;
}

void generateScene3DGpuImpl_api(const mxArray *const prhs[13], int32_T nlhs,
                                const mxArray *plhs[4])
{
  static const uint32_T uv1[4]{2902902013U, 440260521U, 1207011630U,
                               1554532146U};
  static const uint32_T uv11[4]{1182631007U, 2791773850U, 496723319U,
                                3154053528U};
  static const uint32_T uv13[4]{3425405359U, 2503334435U, 945288240U,
                                3292270457U};
  static const uint32_T uv15[4]{3861420659U, 2921858623U, 1643526758U,
                                3272944120U};
  static const uint32_T uv17[4]{2295876266U, 2148151928U, 3667144742U,
                                715754532U};
  static const uint32_T uv19[4]{777175535U, 776037139U, 3450180320U,
                                2614592457U};
  static const uint32_T uv21[4]{700202811U, 3999016738U, 3911390484U,
                                1243484637U};
  static const uint32_T uv3[4]{2594244472U, 4013964953U, 2897031972U,
                               1353424296U};
  static const uint32_T uv5[4]{710879675U, 1834416960U, 3370220506U,
                               1153951692U};
  static const uint32_T uv7[4]{267770951U, 4235693121U, 3117484991U,
                               1740472386U};
  static const uint32_T uv9[4]{2080774649U, 3838581520U, 198443418U,
                               3685903281U};
  static const char_T *sv1[1]{"HLeftInv"};
  static const char_T *sv11[1]{"RCamRadCoeff"};
  static const char_T *sv13[1]{"RCamTanCoeff"};
  static const char_T *sv15[1]{"LCamFocalLength"};
  static const char_T *sv17[1]{"RCamFocalLength"};
  static const char_T *sv19[1]{"LCamPrinPoint"};
  static const char_T *sv21[1]{"RCamPrinPoint"};
  static const char_T *sv3[1]{"HRightInv"};
  static const char_T *sv5[1]{"reprojMat"};
  static const char_T *sv7[1]{"LCamRadCoeff"};
  static const char_T *sv9[1]{"LCamTanCoeff"};
  int32_T iv[1];
  real32_T(*pts3DOut)[6220800];
  real32_T(*disparityMap)[2073600];
  uint8_T(*leftImage)[2073600];
  uint8_T(*leftRect)[2073600];
  uint8_T(*rightImage)[2073600];
  uint8_T(*rightRect)[2073600];
  leftRect = (uint8_T(*)[2073600])mxMalloc(sizeof(uint8_T[2073600]));
  rightRect = (uint8_T(*)[2073600])mxMalloc(sizeof(uint8_T[2073600]));
  disparityMap = (real32_T(*)[2073600])mxMalloc(sizeof(real32_T[2073600]));
  pts3DOut = (real32_T(*)[6220800])mxMalloc(sizeof(real32_T[6220800]));
  // Check constant function inputs
  iv[0] = 4;
  emlrtCheckArrayChecksumR2018b(emlrtRootTLSGlobal, prhs[2], false, &iv[0],
                                (const char_T **)&sv1[0], &uv1[0]);
  iv[0] = 4;
  emlrtCheckArrayChecksumR2018b(emlrtRootTLSGlobal, prhs[3], false, &iv[0],
                                (const char_T **)&sv3[0], &uv3[0]);
  iv[0] = 4;
  emlrtCheckArrayChecksumR2018b(emlrtRootTLSGlobal, prhs[4], false, &iv[0],
                                (const char_T **)&sv5[0], &uv5[0]);
  iv[0] = 4;
  emlrtCheckArrayChecksumR2018b(emlrtRootTLSGlobal, prhs[5], false, &iv[0],
                                (const char_T **)&sv7[0], &uv7[0]);
  iv[0] = 4;
  emlrtCheckArrayChecksumR2018b(emlrtRootTLSGlobal, prhs[6], false, &iv[0],
                                (const char_T **)&sv9[0], &uv9[0]);
  iv[0] = 4;
  emlrtCheckArrayChecksumR2018b(emlrtRootTLSGlobal, prhs[7], false, &iv[0],
                                (const char_T **)&sv11[0], &uv11[0]);
  iv[0] = 4;
  emlrtCheckArrayChecksumR2018b(emlrtRootTLSGlobal, prhs[8], false, &iv[0],
                                (const char_T **)&sv13[0], &uv13[0]);
  iv[0] = 4;
  emlrtCheckArrayChecksumR2018b(emlrtRootTLSGlobal, prhs[9], false, &iv[0],
                                (const char_T **)&sv15[0], &uv15[0]);
  iv[0] = 4;
  emlrtCheckArrayChecksumR2018b(emlrtRootTLSGlobal, prhs[10], false, &iv[0],
                                (const char_T **)&sv17[0], &uv17[0]);
  iv[0] = 4;
  emlrtCheckArrayChecksumR2018b(emlrtRootTLSGlobal, prhs[11], false, &iv[0],
                                (const char_T **)&sv19[0], &uv19[0]);
  iv[0] = 4;
  emlrtCheckArrayChecksumR2018b(emlrtRootTLSGlobal, prhs[12], false, &iv[0],
                                (const char_T **)&sv21[0], &uv21[0]);
  // Marshall function inputs
  leftImage = emlrt_marshallIn(emlrtAlias(prhs[0]), "leftImage");
  rightImage = emlrt_marshallIn(emlrtAlias(prhs[1]), "rightImage");
  // Invoke the target function
  generateScene3DGpuImpl(*leftImage, *rightImage, *leftRect, *rightRect,
                         *disparityMap, *pts3DOut);
  // Marshall function outputs
  plhs[0] = emlrt_marshallOut(*leftRect);
  if (nlhs > 1) {
    plhs[1] = emlrt_marshallOut(*rightRect);
  }
  if (nlhs > 2) {
    plhs[2] = emlrt_marshallOut(*disparityMap);
  }
  if (nlhs > 3) {
    plhs[3] = b_emlrt_marshallOut(*pts3DOut);
  }
}

// End of code generation (_coder_generateScene3DGpuImpl_api.cu)
