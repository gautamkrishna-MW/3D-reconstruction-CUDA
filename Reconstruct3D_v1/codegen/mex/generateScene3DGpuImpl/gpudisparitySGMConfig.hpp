/* This file has the configuration(MACROS) parameters required for
 * the disparitySGM algorithm modules. */
// Copyright 2019 The MathWorks, Inc.

#ifndef SGM_CONFIG_HPP
#define SGM_CONFIG_HPP

#define WARP_SIZE 32     /* Thread Warp size in CUDA */
#define INVALID_VALUE -1 /* Value if invalid Disparities */

// Census Transform Kernel constants
#define CENSUS_HEIGHT 7 /* Census Transform Window Height */
#define CENSUS_WIDTH 9  /* Census Transform Window Width */
#define TILE_W                  \
    (WARP_SIZE + CENSUS_WIDTH - \
     1) /* The tile width for shared memory used in Census transform Kernel */
#define TILE_H                   \
    (WARP_SIZE + CENSUS_HEIGHT - \
     1) /* The tile height for shared memory used in Census transform Kernel */
#define WIN_H_RADIUS ((CENSUS_HEIGHT - 1) >> 1) /* Radius in terms of height for Census window */
#define WIN_W_RADIUS ((CENSUS_WIDTH - 1) >> 1)  /* Radius in terms of width for Census window */

#define DISP_SCALE 16

#endif