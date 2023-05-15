//
// Trial License - for use to evaluate programs for possible purchase as
// an end-user only.
// File: main.cu
//
// GPU Coder version                    : 2.4
// CUDA/C/C++ source code generated on  : 06-Mar-2023 18:52:57
//

/*************************************************************************/
/* This automatically generated example CUDA main file shows how to call */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

// Include Files
#include "main.h"
#include "generateScene3DGpuImpl.h"
#include "generateScene3DGpuImpl_terminate.h"
#include "rt_nonfinite.h"

// Function Declarations
static void argInit_1080x1920_uint8_T(unsigned char result[2073600]);

static unsigned char argInit_uint8_T();

// Function Definitions
//
// Arguments    : unsigned char result[2073600]
// Return Type  : void
//
static void argInit_1080x1920_uint8_T(unsigned char result[2073600])
{
  // Loop over the array to initialize each element.
  for (int i{0}; i < 2073600; i++) {
    // Set the value of the array element.
    // Change this value to the value that the application requires.
    result[i] = argInit_uint8_T();
  }
}

//
// Arguments    : void
// Return Type  : unsigned char
//
static unsigned char argInit_uint8_T()
{
  return (unsigned char)(rand()%256);
}

//
// Arguments    : int argc
//                char **argv
// Return Type  : int
//
int main(int, char **)
{
  // The initialize function is being called automatically from your entry-point
  // function. So, a call to initialize is not included here. Invoke the
  // entry-point functions.
  // You can call entry-point functions multiple times.
  main_generateScene3DGpuImpl();
  // Terminate the application.
  // You do not need to do this more than one time.
  generateScene3DGpuImpl_terminate();
  return 0;
}

//
// Arguments    : void
// Return Type  : void
//

#include <chrono>
#include <iostream>
using std::chrono::high_resolution_clock;
using std::chrono::duration_cast;
using std::chrono::duration;
using std::chrono::milliseconds;

void main_generateScene3DGpuImpl()
{
  static float pts3DOut[6220800];
  static unsigned char b[2073600];
  static unsigned char c[2073600];
  static unsigned char leftRect[2073600];
  static unsigned char rightRect[2073600];
  // Initialize function 'generateScene3DGpuImpl' input arguments.
  // Initialize function input argument 'leftImage'.
  // Initialize function input argument 'rightImage'.
  // Call the entry-point 'generateScene3DGpuImpl'.
  argInit_1080x1920_uint8_T(b);
  argInit_1080x1920_uint8_T(c);

  for (int i=0; i<1; i++)
  {
    auto tStart = high_resolution_clock::now();
    generateScene3DGpuImpl(b, c, leftRect, rightRect, pts3DOut);
    auto tStop = high_resolution_clock::now();
    auto totalTime = duration_cast<milliseconds>(tStop - tStart);
    std::cout << "Overall Total Time: " << totalTime.count() << "ms\n";
    std::cout << std::endl;
  }
}

//
// File trailer for main.cu
//
// [EOF]
//
