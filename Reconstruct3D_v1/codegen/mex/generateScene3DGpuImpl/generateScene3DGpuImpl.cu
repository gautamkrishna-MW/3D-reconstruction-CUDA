//
// Trial License - for use to evaluate programs for possible purchase as
// an end-user only.
//
// generateScene3DGpuImpl.cu
//
// Code generation for function 'generateScene3DGpuImpl'
//

// Include files
#include "generateScene3DGpuImpl.h"
#include "generateScene3DGpuImpl_data.h"
#include "rt_nonfinite.h"
#include "MWCudaDimUtility.hpp"
#include "MWCudaMemoryFunctions.hpp"
#include "MWPtxUtils.hpp"
#include "disparitySGMWrapperCuda.hpp"
#include "gpudisparitySGMConfig.hpp"
#include "gpudisparitySGMCostCuda.hpp"
#include "gpudisparitySGMCuda.hpp"
#include "math_constants.h"

// Variable Definitions
static boolean_T c_gpuConstsCopied_generateScene;

// Function Declarations
static __global__ void
generateScene3DGpuImpl_kernel1(const uint8_T rightImage[2073600],
                               const uint8_T leftImage[2073600],
                               uint8_T I2U8[2073600], uint8_T I1U8[2073600]);

static __global__ void generateScene3DGpuImpl_kernel10(
    const real32_T disparityMap[2073600],
    const real32_T pts3DHomogeneousReproject[8294400],
    real32_T pts3DOut[6220800]);

static __global__ void
generateScene3DGpuImpl_kernel11(boolean_T *globalConvergenceFlag,
                                real32_T disparityMap[2073600]);

static __global__ void generateScene3DGpuImpl_kernel2(
    const uint8_T I2U8[2073600], const uint8_T I1U8[2073600],
    uint8_T rightRect[2073600], uint8_T leftRect[2073600], real32_T a_dim0,
    real32_T a_dim1, real32_T a_dim2, real32_T a_dim3, real32_T a_dim4,
    real32_T a_dim5, real32_T a_dim6, real32_T a_dim7, real32_T a_dim8,
    real32_T b_a_dim0, real32_T b_a_dim1, real32_T b_a_dim2, real32_T b_a_dim3,
    real32_T b_a_dim4, real32_T b_a_dim5, real32_T b_a_dim6, real32_T b_a_dim7,
    real32_T b_a_dim8);

static __global__ void
generateScene3DGpuImpl_kernel3(const real32_T rightFiltered[2073600],
                               const real32_T leftFiltered[2073600],
                               uint8_T I2U8[2073600], uint8_T I1U8[2073600]);

static __global__ void
generateScene3DGpuImpl_kernel4(const uint8_T I2U8[2073600],
                               const uint8_T I1U8[2073600], uint8_T I4[2073600],
                               uint8_T I3[2073600]);

static __global__ void
generateScene3DGpuImpl_kernel5(const real32_T leftFiltered[2073600],
                               real32_T disparityMap[2073600]);

static __global__ void
generateScene3DGpuImpl_kernel6(real32_T disparityMap[2073600]);

static __global__ void generateScene3DGpuImpl_kernel7(int16_T yCoord[2073600],
                                                      int16_T xCoord[2073600]);

static __global__ void generateScene3DGpuImpl_kernel8(
    const real32_T disparityMap[2073600], const int16_T yCoord[2073600],
    const int16_T xCoord[2073600], real32_T pts3DHomogeneous[8294400]);

static __global__ void
generateScene3DGpuImpl_kernel9(const real32_T fv[16],
                               const real32_T pts3DHomogeneous[8294400],
                               real32_T pts3DHomogeneousReproject[8294400]);

static __global__ void stencilKernel(const uint8_T input[2073600],
                                     uint8_T paddingValue,
                                     real32_T output[2073600]);

// Function Definitions
static __global__ __launch_bounds__(512, 1) void generateScene3DGpuImpl_kernel1(
    const uint8_T rightImage[2073600], const uint8_T leftImage[2073600],
    uint8_T I2U8[2073600], uint8_T I1U8[2073600])
{
  uint64_T threadId;
  int32_T colIter;
  int32_T rowIter;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  rowIter = static_cast<int32_T>(threadId % 1080ULL);
  colIter = static_cast<int32_T>((threadId - static_cast<uint64_T>(rowIter)) /
                                 1080ULL);
  if ((colIter < 1920) && (rowIter < 1080)) {
    real32_T b_y;
    real32_T c_y;
    real32_T colIterR;
    real32_T dU;
    real32_T inpColR;
    real32_T inpRowR;
    real32_T outColL;
    real32_T r_2;
    real32_T radMultL;
    real32_T radMultR;
    real32_T rowIterL;
    real32_T rowIterR;
    real32_T sumIntensities;
    real32_T val;
    real32_T xy2;
    real32_T y;
    uint8_T i4L;
    //         %% Left Image
    sumIntensities =
        ((static_cast<real32_T>(colIter) + 1.0F) - 919.169312F) / 1266.84326F;
    rowIterL =
        ((static_cast<real32_T>(rowIter) + 1.0F) - 546.094849F) / 1267.10303F;
    //  r = sqrt(rowIter*rowIter + colIter*colIter);
    r_2 = rowIterL * rowIterL + sumIntensities * sumIntensities;
    val = r_2 * r_2;
    //  Radial
    radMultL = ((-0.136658221F * r_2 + 1.0F) + 0.168160394F * val) +
               -0.0391957462F * (val * r_2);
    //  Tangential
    xy2 = 2.0F * rowIterL * sumIntensities;
    dU = xy2 * -0.00227867416F;
    c_y = -0.00232284726F * (r_2 + 2.0F * rowIterL * rowIterL);
    inpColR = (rowIterL * radMultL + xy2 * -0.00227867416F) +
              -0.00232284726F * (r_2 + 2.0F * rowIterL * rowIterL);
    b_y = xy2 * -0.00232284726F;
    y = -0.00227867416F * (r_2 + 2.0F * sumIntensities * sumIntensities);
    inpRowR = (sumIntensities * radMultL + xy2 * -0.00232284726F) +
              -0.00227867416F * (r_2 + 2.0F * sumIntensities * sumIntensities);
    //         %% Right Image
    colIterR =
        ((static_cast<real32_T>(colIter) + 1.0F) - 1040.93506F) / 1272.84253F;
    rowIterR =
        ((static_cast<real32_T>(rowIter) + 1.0F) - 561.620178F) / 1272.45984F;
    //  r = sqrt(rowIter*rowIter + colIter*colIter);
    r_2 = rowIterR * rowIterR + colIterR * colIterR;
    val = r_2 * r_2;
    //  Radial
    radMultR = ((-0.131053701F * r_2 + 1.0F) + 0.161947727F * val) +
               -0.0327948183F * (val * r_2);
    //  Tangential
    xy2 = 2.0F * rowIterR * colIterR;
    //         %% Map back
    val = ((sumIntensities * radMultL + b_y) + y) * 1266.84326F;
    outColL = inpRowR * 1266.84326F + 919.169312F;
    c_y = ((rowIterL * radMultL + dU) + c_y) * 1267.10303F;
    inpColR = inpColR * 1267.10303F + 546.094849F;
    b_y = ((colIterR * radMultR + xy2 * 0.00366475782F) +
           0.000479186914F * (r_2 + 2.0F * colIterR * colIterR)) *
          1272.84253F;
    inpRowR = ((colIterR * radMultR + xy2 * 0.00366475782F) +
               0.000479186914F * (r_2 + 2.0F * colIterR * colIterR)) *
                  1272.84253F +
              1040.93506F;
    y = ((rowIterR * radMultR + xy2 * 0.000479186914F) +
         0.00366475782F * (r_2 + 2.0F * rowIterR * rowIterR)) *
        1272.45984F;
    sumIntensities = ((rowIterR * radMultR + xy2 * 0.000479186914F) +
                      0.00366475782F * (r_2 + 2.0F * rowIterR * rowIterR)) *
                         1272.45984F +
                     561.620178F;
    //  Interpolation
    if (c_y + 546.094849F >= 1080.0F) {
      inpColR = 1079.0F;
    } else if (c_y + 546.094849F < 1.0F) {
      inpColR = 1.0F;
    }
    if (y + 561.620178F >= 1080.0F) {
      sumIntensities = 1079.0F;
    } else if (y + 561.620178F < 1.0F) {
      sumIntensities = 1.0F;
    }
    if (val + 919.169312F >= 1920.0F) {
      outColL = 1919.0F;
    } else if (val + 919.169312F < 1.0F) {
      outColL = 1.0F;
    }
    if (b_y + 1040.93506F >= 1920.0F) {
      inpRowR = 1919.0F;
    } else if (b_y + 1040.93506F < 1.0F) {
      inpRowR = 1.0F;
    }
    //  Interpolation for left image
    dU = inpColR - floorf(inpColR);
    val = outColL - floorf(outColL);
    val = roundf(
        ((static_cast<real32_T>(
              leftImage[static_cast<int32_T>(floorf(inpColR) +
                                             1080.0 * (floorf(outColL) - 1.0)) -
                        1]) *
              (1.0F - dU) * (1.0F - val) +
          static_cast<real32_T>(leftImage[static_cast<int32_T>(
              floorf(inpColR) + 1080.0 * (floorf(outColL) - 1.0))]) *
              dU * (1.0F - val)) +
         static_cast<real32_T>(
             leftImage[static_cast<int32_T>(floorf(inpColR) +
                                            1080.0 * floorf(outColL)) -
                       1]) *
             (1.0F - dU) * val) +
        static_cast<real32_T>(leftImage[static_cast<int32_T>(
            floorf(inpColR) + 1080.0 * floorf(outColL))]) *
            dU * val);
    if (val < 256.0F) {
      if (val >= 0.0F) {
        i4L = static_cast<uint8_T>(val);
      } else {
        i4L = 0U;
      }
    } else {
      i4L = MAX_uint8_T;
    }
    I1U8[rowIter + 1080 * colIter] = i4L;
    //  Interpolation for right image
    dU = sumIntensities - floorf(sumIntensities);
    val = inpRowR - floorf(inpRowR);
    val = roundf(
        ((static_cast<real32_T>(
              rightImage[static_cast<int32_T>(floorf(sumIntensities) +
                                              1080.0 *
                                                  (floorf(inpRowR) - 1.0)) -
                         1]) *
              (1.0F - dU) * (1.0F - val) +
          static_cast<real32_T>(rightImage[static_cast<int32_T>(
              floorf(sumIntensities) + 1080.0 * (floorf(inpRowR) - 1.0))]) *
              dU * (1.0F - val)) +
         static_cast<real32_T>(
             rightImage[static_cast<int32_T>(floorf(sumIntensities) +
                                             1080.0 * floorf(inpRowR)) -
                        1]) *
             (1.0F - dU) * val) +
        static_cast<real32_T>(rightImage[static_cast<int32_T>(
            floorf(sumIntensities) + 1080.0 * floorf(inpRowR))]) *
            dU * val);
    if (val < 256.0F) {
      if (val >= 0.0F) {
        i4L = static_cast<uint8_T>(val);
      } else {
        i4L = 0U;
      }
    } else {
      i4L = MAX_uint8_T;
    }
    I2U8[rowIter + 1080 * colIter] = i4L;
  }
}

static __global__
    __launch_bounds__(512, 1) void generateScene3DGpuImpl_kernel10(
        const real32_T disparityMap[2073600],
        const real32_T pts3DHomogeneousReproject[8294400],
        real32_T pts3DOut[6220800])
{
  uint64_T threadId;
  int32_T b_index;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  b_index = static_cast<int32_T>(threadId);
  if (b_index < 2073600) {
    real32_T val;
    val = pts3DHomogeneousReproject[b_index + 6220800];
    pts3DOut[b_index] = pts3DHomogeneousReproject[b_index] / val;
    pts3DOut[b_index + 2073600] =
        pts3DHomogeneousReproject[b_index + 2073600] / val;
    pts3DOut[b_index + 4147200] =
        pts3DHomogeneousReproject[b_index + 4147200] / val;
    if (disparityMap[b_index] == -3.402823466E+38F) {
      pts3DOut[b_index] = CUDART_NAN_F;
      pts3DOut[b_index + 2073600] = CUDART_NAN_F;
      pts3DOut[b_index + 4147200] = CUDART_NAN_F;
    }
  }
}

static __global__
    __launch_bounds__(512, 1) void generateScene3DGpuImpl_kernel11(
        boolean_T *globalConvergenceFlag, real32_T disparityMap[2073600])
{
  uint64_T threadId;
  int32_T colIter;
  int32_T rowIter;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  rowIter = static_cast<int32_T>(threadId % 1078ULL);
  colIter = static_cast<int32_T>((threadId - static_cast<uint64_T>(rowIter)) /
                                 1078ULL);
  if ((colIter < 1919) && (rowIter < 1078) &&
      isinf(disparityMap[(rowIter + 1080 * colIter) + 1])) {
    real_T countIntensities;
    real32_T sumIntensities;
    //  Thread checks for NaN in N-8 and if found one, runs the
    //  algorithm one more time.
    *globalConvergenceFlag = true;
    sumIntensities = 0.0F;
    countIntensities = 0.0;
    for (int32_T b_index{0}; b_index < 3; b_index++) {
      if (!isinf(disparityMap[rowIter + 1080 * ((colIter + b_index) - 1)])) {
        sumIntensities +=
            disparityMap[rowIter + 1080 * ((colIter + b_index) - 1)];
        countIntensities++;
      }
      if (!isinf(
              disparityMap[(rowIter + 1080 * ((colIter + b_index) - 1)) + 1])) {
        sumIntensities +=
            disparityMap[(rowIter + 1080 * ((colIter + b_index) - 1)) + 1];
        countIntensities++;
      }
      if (!isinf(
              disparityMap[(rowIter + 1080 * ((colIter + b_index) - 1)) + 2])) {
        sumIntensities +=
            disparityMap[(rowIter + 1080 * ((colIter + b_index) - 1)) + 2];
        countIntensities++;
      }
    }
    if (countIntensities > 0.0) {
      disparityMap[(rowIter + 1080 * colIter) + 1] =
          sumIntensities / static_cast<real32_T>(countIntensities);
    }
  }
}

static __global__ __launch_bounds__(512, 1) void generateScene3DGpuImpl_kernel2(
    const uint8_T I2U8[2073600], const uint8_T I1U8[2073600],
    uint8_T rightRect[2073600], uint8_T leftRect[2073600], real32_T a_dim0,
    real32_T a_dim1, real32_T a_dim2, real32_T a_dim3, real32_T a_dim4,
    real32_T a_dim5, real32_T a_dim6, real32_T a_dim7, real32_T a_dim8,
    real32_T b_a_dim0, real32_T b_a_dim1, real32_T b_a_dim2, real32_T b_a_dim3,
    real32_T b_a_dim4, real32_T b_a_dim5, real32_T b_a_dim6, real32_T b_a_dim7,
    real32_T b_a_dim8)
{
  __shared__ real32_T a_shared[9];
  __shared__ real32_T b_a_shared[9];
  uint64_T threadId;
  int32_T colIter;
  int32_T rowIter;
  if (mwGetThreadIndexWithinBlock() == 0) {
    b_a_shared[0] = b_a_dim0;
    b_a_shared[1] = b_a_dim1;
    b_a_shared[2] = b_a_dim2;
    b_a_shared[3] = b_a_dim3;
    b_a_shared[4] = b_a_dim4;
    b_a_shared[5] = b_a_dim5;
    b_a_shared[6] = b_a_dim6;
    b_a_shared[7] = b_a_dim7;
    b_a_shared[8] = b_a_dim8;
  }
  __syncthreads();
  if (mwGetThreadIndexWithinBlock() == 0) {
    a_shared[0] = a_dim0;
    a_shared[1] = a_dim1;
    a_shared[2] = a_dim2;
    a_shared[3] = a_dim3;
    a_shared[4] = a_dim4;
    a_shared[5] = a_dim5;
    a_shared[6] = a_dim6;
    a_shared[7] = a_dim7;
    a_shared[8] = a_dim8;
  }
  __syncthreads();
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  colIter = static_cast<int32_T>(threadId % 1920ULL);
  rowIter = static_cast<int32_T>((threadId - static_cast<uint64_T>(colIter)) /
                                 1920ULL);
  if ((rowIter < 1080) && (colIter < 1920)) {
    real32_T inpPointL[3];
    real32_T dU;
    real32_T inpColR;
    real32_T inpRowR;
    real32_T sumIntensities;
    real32_T val;
    uint8_T i1L;
    uint8_T i1R;
    uint8_T i2L;
    uint8_T i2R;
    uint8_T i3L;
    uint8_T i3R;
    uint8_T i4L;
    uint8_T i4R;
    //  Left Image
    for (int32_T i{0}; i < 3; i++) {
      inpPointL[i] =
          (a_shared[i] * (static_cast<real32_T>(colIter) + 1.0F) +
           a_shared[i + 3] * (static_cast<real32_T>(rowIter) + 1.0F)) +
          a_shared[i + 6];
    }
    sumIntensities = inpPointL[0] / inpPointL[2];
    val = inpPointL[1] / inpPointL[2];
    //  Right Image
    for (int32_T i{0}; i < 3; i++) {
      inpPointL[i] =
          (b_a_shared[i] * (static_cast<real32_T>(colIter) + 1.0F) +
           b_a_shared[i + 3] * (static_cast<real32_T>(rowIter) + 1.0F)) +
          b_a_shared[i + 6];
    }
    inpColR = inpPointL[0] / inpPointL[2];
    inpRowR = inpPointL[1] / inpPointL[2];
    //  Bounds Check Left
    if ((val > 1.0F) && (val <= 1080.0F) && (sumIntensities > 1.0F) &&
        (sumIntensities <= 1920.0F)) {
      i1L = I1U8[static_cast<int32_T>(floorf(val) +
                                      1080.0 * (floorf(sumIntensities) - 1.0)) -
                 1];
    } else {
      i1L = 0U;
    }
    if ((val > 1.0F) && (val <= 1079.0F) && (sumIntensities > 1.0F) &&
        (sumIntensities <= 1920.0F)) {
      i2L = I1U8[static_cast<int32_T>(floorf(val) +
                                      1080.0 * (floorf(sumIntensities) - 1.0))];
    } else {
      i2L = 0U;
    }
    if ((val > 1.0F) && (val <= 1080.0F) && (sumIntensities > 1.0F) &&
        (sumIntensities <= 1919.0F)) {
      i3L = I1U8[static_cast<int32_T>(floorf(val) +
                                      1080.0 * floorf(sumIntensities)) -
                 1];
    } else {
      i3L = 0U;
    }
    if ((val > 1.0F) && (val <= 1079.0F) && (sumIntensities > 1.0F) &&
        (sumIntensities <= 1919.0F)) {
      i4L = I1U8[static_cast<int32_T>(floorf(val) +
                                      1080.0 * floorf(sumIntensities))];
    } else {
      i4L = 0U;
    }
    //  Bounds Check Right
    if ((inpRowR > 1.0F) && (inpRowR <= 1080.0F) && (inpColR > 1.0F) &&
        (inpColR <= 1920.0F)) {
      i1R = I2U8[static_cast<int32_T>(floorf(inpRowR) +
                                      1080.0 * (floorf(inpColR) - 1.0)) -
                 1];
    } else {
      i1R = 0U;
    }
    if ((inpRowR > 1.0F) && (inpRowR <= 1079.0F) && (inpColR > 1.0F) &&
        (inpColR <= 1920.0F)) {
      i2R = I2U8[static_cast<int32_T>(floorf(inpRowR) +
                                      1080.0 * (floorf(inpColR) - 1.0))];
    } else {
      i2R = 0U;
    }
    if ((inpRowR > 1.0F) && (inpRowR <= 1080.0F) && (inpColR > 1.0F) &&
        (inpColR <= 1919.0F)) {
      i3R = I2U8[static_cast<int32_T>(floorf(inpRowR) +
                                      1080.0 * floorf(inpColR)) -
                 1];
    } else {
      i3R = 0U;
    }
    if ((inpRowR > 1.0F) && (inpRowR <= 1079.0F) && (inpColR > 1.0F) &&
        (inpColR <= 1919.0F)) {
      i4R = I2U8[static_cast<int32_T>(floorf(inpRowR) +
                                      1080.0 * floorf(inpColR))];
    } else {
      i4R = 0U;
    }
    //  Interpolation for left image
    dU = val - floorf(val);
    val = sumIntensities - floorf(sumIntensities);
    val = roundf(((static_cast<real32_T>(i1L) * (1.0F - dU) * (1.0F - val) +
                   static_cast<real32_T>(i2L) * dU * (1.0F - val)) +
                  static_cast<real32_T>(i3L) * (1.0F - dU) * val) +
                 static_cast<real32_T>(i4L) * dU * val);
    if (val < 256.0F) {
      if (val >= 0.0F) {
        i4L = static_cast<uint8_T>(val);
      } else {
        i4L = 0U;
      }
    } else if (val >= 256.0F) {
      i4L = MAX_uint8_T;
    } else {
      i4L = 0U;
    }
    leftRect[rowIter + 1080 * colIter] = i4L;
    //  Interpolation for right image
    dU = inpRowR - floorf(inpRowR);
    val = inpColR - floorf(inpColR);
    val = roundf(((static_cast<real32_T>(i1R) * (1.0F - dU) * (1.0F - val) +
                   static_cast<real32_T>(i2R) * dU * (1.0F - val)) +
                  static_cast<real32_T>(i3R) * (1.0F - dU) * val) +
                 static_cast<real32_T>(i4R) * dU * val);
    if (val < 256.0F) {
      if (val >= 0.0F) {
        i4L = static_cast<uint8_T>(val);
      } else {
        i4L = 0U;
      }
    } else {
      i4L = MAX_uint8_T;
    }
    rightRect[rowIter + 1080 * colIter] = i4L;
  }
}

static __global__ __launch_bounds__(512, 1) void generateScene3DGpuImpl_kernel3(
    const real32_T rightFiltered[2073600], const real32_T leftFiltered[2073600],
    uint8_T I2U8[2073600], uint8_T I1U8[2073600])
{
  uint64_T threadId;
  int32_T b_index;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  b_index = static_cast<int32_T>(threadId);
  if (b_index < 2073600) {
    real32_T val;
    //  Compute disparity
    val = leftFiltered[b_index] * 255.0F;
    if (val < 0.0F) {
      I1U8[b_index] = 0U;
    } else if (val > 255.0F) {
      I1U8[b_index] = MAX_uint8_T;
    } else {
      I1U8[b_index] = static_cast<uint8_T>(val + 0.5F);
    }
    val = rightFiltered[b_index] * 255.0F;
    if (val < 0.0F) {
      I2U8[b_index] = 0U;
    } else if (val > 255.0F) {
      I2U8[b_index] = MAX_uint8_T;
    } else {
      I2U8[b_index] = static_cast<uint8_T>(val + 0.5F);
    }
  }
}

static __global__ __launch_bounds__(512, 1) void generateScene3DGpuImpl_kernel4(
    const uint8_T I2U8[2073600], const uint8_T I1U8[2073600],
    uint8_T I4[2073600], uint8_T I3[2073600])
{
  uint64_T threadId;
  int32_T b_index;
  int32_T i;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  b_index = static_cast<int32_T>(threadId % 1920ULL);
  i = static_cast<int32_T>((threadId - static_cast<uint64_T>(b_index)) /
                           1920ULL);
  if ((i < 1080) && (b_index < 1920)) {
    I3[b_index + 1920 * i] = I1U8[i + 1080 * b_index];
    I4[b_index + 1920 * i] = I2U8[i + 1080 * b_index];
  }
}

static __global__ __launch_bounds__(512, 1) void generateScene3DGpuImpl_kernel5(
    const real32_T leftFiltered[2073600], real32_T disparityMap[2073600])
{
  uint64_T threadId;
  int32_T b_index;
  int32_T i;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  b_index = static_cast<int32_T>(threadId % 1080ULL);
  i = static_cast<int32_T>((threadId - static_cast<uint64_T>(b_index)) /
                           1080ULL);
  if ((i < 1920) && (b_index < 1080)) {
    disparityMap[b_index + 1080 * i] = leftFiltered[i + 1920 * b_index];
  }
}

static __global__ __launch_bounds__(512, 1) void generateScene3DGpuImpl_kernel6(
    real32_T disparityMap[2073600])
{
  uint64_T threadId;
  int32_T b_index;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  b_index = static_cast<int32_T>(threadId);
  if (b_index < 2073600) {
    real32_T val;
    val = disparityMap[b_index];
    if (val == 0.0F) {
      disparityMap[b_index] = -CUDART_INF_F;
    } else if (val == 39.0F) {
      disparityMap[b_index] = CUDART_INF_F;
    }
  }
}

static __global__ __launch_bounds__(512, 1) void generateScene3DGpuImpl_kernel7(
    int16_T yCoord[2073600], int16_T xCoord[2073600])
{
  uint64_T threadId;
  int32_T b_index;
  int32_T colIter;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  colIter = static_cast<int32_T>(threadId % 1080ULL);
  b_index = static_cast<int32_T>((threadId - static_cast<uint64_T>(colIter)) /
                                 1080ULL);
  if ((b_index < 1920) && (colIter < 1080)) {
    xCoord[colIter + 1080 * b_index] = static_cast<int16_T>(b_index + 1);
    yCoord[colIter + 1080 * b_index] = static_cast<int16_T>(colIter + 1);
  }
}

static __global__ __launch_bounds__(512, 1) void generateScene3DGpuImpl_kernel8(
    const real32_T disparityMap[2073600], const int16_T yCoord[2073600],
    const int16_T xCoord[2073600], real32_T pts3DHomogeneous[8294400])
{
  uint64_T threadId;
  int32_T b_index;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  b_index = static_cast<int32_T>(threadId);
  if (b_index < 2073600) {
    //  Stack points
    pts3DHomogeneous[b_index] = xCoord[b_index];
    pts3DHomogeneous[b_index + 2073600] = yCoord[b_index];
    pts3DHomogeneous[b_index + 4147200] = disparityMap[b_index];
    pts3DHomogeneous[b_index + 6220800] = 1.0F;
  }
}

static __global__ __launch_bounds__(512, 1) void generateScene3DGpuImpl_kernel9(
    const real32_T fv[16], const real32_T pts3DHomogeneous[8294400],
    real32_T pts3DHomogeneousReproject[8294400])
{
  uint64_T threadId;
  int32_T b_index;
  int32_T i;
  threadId = static_cast<uint64_T>(mwGetGlobalThreadIndexInXDimension());
  b_index = static_cast<int32_T>(threadId % 4ULL);
  i = static_cast<int32_T>((threadId - static_cast<uint64_T>(b_index)) / 4ULL);
  if ((i < 2073600) && (b_index < 4)) {
    pts3DHomogeneousReproject[i + 2073600 * b_index] =
        ((pts3DHomogeneous[i] * fv[b_index << 2] +
          pts3DHomogeneous[i + 2073600] * fv[(b_index << 2) + 1]) +
         pts3DHomogeneous[i + 4147200] * fv[(b_index << 2) + 2]) +
        pts3DHomogeneous[i + 6220800] * fv[(b_index << 2) + 3];
  }
}

static __global__
    __launch_bounds__(256, 1) void stencilKernel(const uint8_T input[2073600],
                                                 uint8_T paddingValue,
                                                 real32_T output[2073600])
{
  int32_T b_workItemGlobalOutputElemDimId;
  int32_T sum;
  int32_T workGroupIdTmp;
  int32_T workItemGlobalOutputElemDimIdx;
  sum = mwGetThreadIndexWithinBlock();
  workGroupIdTmp = mwGetBlockIndex();
  workItemGlobalOutputElemDimIdx = sum % 16 + ((workGroupIdTmp % 68) << 4);
  workGroupIdTmp /= 68;
  b_workItemGlobalOutputElemDimId = sum / 16 + (workGroupIdTmp << 4);
  if ((workItemGlobalOutputElemDimIdx < 1080) &&
      (b_workItemGlobalOutputElemDimId < 1920)) {
    uint8_T window[121];
    for (int32_T windowIdx{0}; windowIdx < 11; windowIdx++) {
      workGroupIdTmp = (b_workItemGlobalOutputElemDimId + windowIdx) - 5;
      for (int32_T b_windowIdx{0}; b_windowIdx < 11; b_windowIdx++) {
        sum = (workItemGlobalOutputElemDimIdx + b_windowIdx) - 5;
        if ((sum >= 0) && (sum < 1080) && (workGroupIdTmp >= 0) &&
            (workGroupIdTmp < 1920)) {
          window[b_windowIdx + 11 * windowIdx] =
              input[sum + 1080 * workGroupIdTmp];
        } else {
          window[b_windowIdx + 11 * windowIdx] = paddingValue;
        }
      }
    }
    sum = 0;
    for (workGroupIdTmp = 0; workGroupIdTmp < 121; workGroupIdTmp++) {
      sum += window[workGroupIdTmp];
    }
    output[workItemGlobalOutputElemDimIdx +
           1080 * b_workItemGlobalOutputElemDimId] =
        static_cast<real32_T>(sum) / 30855.0F;
  }
}

void generateScene3DGpuImpl(const uint8_T leftImage[2073600],
                            const uint8_T rightImage[2073600],
                            uint8_T leftRect[2073600],
                            uint8_T rightRect[2073600],
                            real32_T disparityMap[2073600],
                            real32_T pts3DOut[6220800])
{
  static const real32_T fv[16]{
      1.0F, 0.0F, 0.0F, -919.169312F, 0.0F, 1.0F, 0.0F,         -546.094849F,
      0.0F, 0.0F, 0.0F, 1266.84326F,  0.0F, 0.0F, 0.220501065F, 26.8494778F};
  real32_T(*gpu_pts3DHomogeneous)[8294400];
  real32_T(*gpu_pts3DHomogeneousReproject)[8294400];
  real32_T(*gpu_pts3DOut)[6220800];
  real32_T(*gpu_disparityMap)[2073600];
  real32_T(*gpu_leftFiltered)[2073600];
  real32_T(*gpu_rightFiltered)[2073600];
  int16_T(*gpu_xCoord)[2073600];
  int16_T(*gpu_yCoord)[2073600];
  uint8_T(*gpu_gpuWorkspace)[503884800];
  uint8_T(*gpu_I1U8)[2073600];
  uint8_T(*gpu_I2U8)[2073600];
  uint8_T(*gpu_I3)[2073600];
  uint8_T(*gpu_I4)[2073600];
  uint8_T(*gpu_leftImage)[2073600];
  uint8_T(*gpu_leftRect)[2073600];
  uint8_T(*gpu_rightImage)[2073600];
  uint8_T(*gpu_rightRect)[2073600];
  boolean_T globalConvergenceFlag;
  boolean_T *gpu_globalConvergenceFlag;
  if (!c_gpuConstsCopied_generateScene) {
    c_gpuConstsCopied_generateScene = true;
    cudaMemcpy(*fv_gpu_clone, fv, sizeof(real32_T[16]), cudaMemcpyHostToDevice);
  }
  mwCudaMalloc(&gpu_pts3DOut, 24883200ULL);
  mwCudaMalloc(&gpu_pts3DHomogeneousReproject, 33177600ULL);
  mwCudaMalloc(&gpu_pts3DHomogeneous, 33177600ULL);
  mwCudaMalloc(&gpu_xCoord, 4147200ULL);
  mwCudaMalloc(&gpu_yCoord, 4147200ULL);
  mwCudaMalloc(&gpu_globalConvergenceFlag, 1ULL);
  mwCudaMalloc(&gpu_disparityMap, 8294400ULL);
  mwCudaMalloc(&gpu_gpuWorkspace, 503884800ULL);
  mwCudaMalloc(&gpu_I3, 2073600ULL);
  mwCudaMalloc(&gpu_I4, 2073600ULL);
  mwCudaMalloc(&gpu_rightFiltered, 8294400ULL);
  mwCudaMalloc(&gpu_leftFiltered, 8294400ULL);
  mwCudaMalloc(&gpu_leftRect, 2073600ULL);
  mwCudaMalloc(&gpu_rightRect, 2073600ULL);
  mwCudaMalloc(&gpu_I1U8, 2073600ULL);
  mwCudaMalloc(&gpu_I2U8, 2073600ULL);
  mwCudaMalloc(&gpu_leftImage, 2073600ULL);
  mwCudaMalloc(&gpu_rightImage, 2073600ULL);
  //  Undistort Image
  //  Simple forward undistortion implementation (may contain holes)
  //  Input sizes
  //  Allocate output matrices
  //  Apply Radial and Tangential Coeffs
  cudaMemcpy(*gpu_rightImage, rightImage, 2073600ULL, cudaMemcpyHostToDevice);
  cudaMemcpy(*gpu_leftImage, leftImage, 2073600ULL, cudaMemcpyHostToDevice);
  generateScene3DGpuImpl_kernel1<<<dim3(4050U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
      *gpu_rightImage, *gpu_leftImage, *gpu_I2U8, *gpu_I1U8);
  //  Rectify Images
  //  Performing inverse mapping and bilinear interpolation
  generateScene3DGpuImpl_kernel2<<<dim3(4050U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
      *gpu_I2U8, *gpu_I1U8, *gpu_rightRect, *gpu_leftRect, 0.990029752F,
      -0.00356712751F, -1.07433525E-5F, -0.00229903217F, 0.999997377F,
      -1.36175793E-16F, 27.5765533F, 3.26931334F, 1.00978231F, 0.998733819F,
      0.000572044635F, -5.7333632E-6F, 0.0028441071F, 1.00773752F,
      6.31935836E-6F, 130.598694F, 0.587008119F, 1.00176048F);
  //  Preprocessing Image
  stencilKernel<<<8160U, 256U>>>(*gpu_leftRect, 0U, *gpu_leftFiltered);
  stencilKernel<<<8160U, 256U>>>(*gpu_rightRect, 0U, *gpu_rightFiltered);
  //  Compute disparity
  generateScene3DGpuImpl_kernel3<<<dim3(4050U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
      *gpu_rightFiltered, *gpu_leftFiltered, *gpu_I2U8, *gpu_I1U8);
  generateScene3DGpuImpl_kernel4<<<dim3(4050U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
      *gpu_I2U8, *gpu_I1U8, *gpu_I4, *gpu_I3);
  computeDisparity(1, 15, 200, 1080, 1920, 5, 0, 40, 0, &(*gpu_I3)[0],
                   &(*gpu_I4)[0], &(*gpu_leftFiltered)[0],
                   &(*gpu_gpuWorkspace)[0]);
  generateScene3DGpuImpl_kernel5<<<dim3(4050U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
      *gpu_leftFiltered, *gpu_disparityMap);
  //  Post processing
  globalConvergenceFlag = true;
  generateScene3DGpuImpl_kernel6<<<dim3(4050U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
      *gpu_disparityMap);
  while (globalConvergenceFlag) {
    globalConvergenceFlag = false;
    cudaMemcpy(gpu_globalConvergenceFlag, &globalConvergenceFlag, 1ULL,
               cudaMemcpyHostToDevice);
    generateScene3DGpuImpl_kernel11<<<dim3(4041U, 1U, 1U),
                                      dim3(512U, 1U, 1U)>>>(
        gpu_globalConvergenceFlag, *gpu_disparityMap);
    cudaMemcpy(&globalConvergenceFlag, gpu_globalConvergenceFlag, 1ULL,
               cudaMemcpyDeviceToHost);
  }
  //  Reprojection
  //  Generate Meshgrids
  generateScene3DGpuImpl_kernel7<<<dim3(4050U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
      *gpu_yCoord, *gpu_xCoord);
  //  Stack points
  generateScene3DGpuImpl_kernel8<<<dim3(4050U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
      *gpu_disparityMap, *gpu_yCoord, *gpu_xCoord, *gpu_pts3DHomogeneous);
  //  Reprojection
  generateScene3DGpuImpl_kernel9<<<dim3(16200U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
      *fv_gpu_clone, *gpu_pts3DHomogeneous, *gpu_pts3DHomogeneousReproject);
  generateScene3DGpuImpl_kernel10<<<dim3(4050U, 1U, 1U), dim3(512U, 1U, 1U)>>>(
      *gpu_disparityMap, *gpu_pts3DHomogeneousReproject, *gpu_pts3DOut);
  //  Points of Cloud
  cudaMemcpy(leftRect, *gpu_leftRect, 2073600ULL, cudaMemcpyDeviceToHost);
  cudaMemcpy(rightRect, *gpu_rightRect, 2073600ULL, cudaMemcpyDeviceToHost);
  cudaMemcpy(disparityMap, *gpu_disparityMap, 8294400ULL,
             cudaMemcpyDeviceToHost);
  cudaMemcpy(pts3DOut, *gpu_pts3DOut, 24883200ULL, cudaMemcpyDeviceToHost);
  mwCudaFree(&(*gpu_rightImage)[0]);
  mwCudaFree(&(*gpu_leftImage)[0]);
  mwCudaFree(&(*gpu_I2U8)[0]);
  mwCudaFree(&(*gpu_I1U8)[0]);
  mwCudaFree(&(*gpu_rightRect)[0]);
  mwCudaFree(&(*gpu_leftRect)[0]);
  mwCudaFree(&(*gpu_leftFiltered)[0]);
  mwCudaFree(&(*gpu_rightFiltered)[0]);
  mwCudaFree(&(*gpu_I4)[0]);
  mwCudaFree(&(*gpu_I3)[0]);
  mwCudaFree(&(*gpu_gpuWorkspace)[0]);
  mwCudaFree(&(*gpu_disparityMap)[0]);
  mwCudaFree(gpu_globalConvergenceFlag);
  mwCudaFree(&(*gpu_yCoord)[0]);
  mwCudaFree(&(*gpu_xCoord)[0]);
  mwCudaFree(&(*gpu_pts3DHomogeneous)[0]);
  mwCudaFree(&(*gpu_pts3DHomogeneousReproject)[0]);
  mwCudaFree(&(*gpu_pts3DOut)[0]);
}

// End of code generation (generateScene3DGpuImpl.cu)
