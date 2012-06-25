//
//  Assembly.h
//  Flow2D
//
//  Created by Dan Borthwick on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_Assembly_h
#define Flow2D_Assembly_h

#include <TargetConditionals.h>
#if (TARGET_IPHONE_SIMULATOR == 0) && (TARGET_OS_IPHONE == 1)
#define SUPPORT_ASM
#endif

#ifndef NO_THUMB
//#warning "Compiling in Thumb Mode. Mode switches activated."
#else
//#warning "Compiling in ARM mode. Mode switches deactivated."
#endif

// Switches to from THUMB to ARM mode.
#ifndef NO_THUMB
#define SWITCH_TO_ARM ".align 4               \n\t" \
"mov     r0, pc         \n\t" \
"bx      r0             \n\t" \
".arm                   \n\t" 
#else
#define SWITCH_TO_ARM
#endif

// Switches from ARM to THUMB mode.
#ifndef NO_THUMB
#define SWITCH_TO_THUMB "add     r0, pc, #1     \n\t" \
"bx      r0             \n\t" \
".thumb                 \n\t" 
#else
#define SWITCH_TO_THUMB
#endif

#define VECTOR_LENGTH_ZERO "fmrx    r0, fpscr            \n\t" \
"bic     r0, r0, #0x00370000  \n\t" \
"fmxr    fpscr, r0            \n\t" 

// Set vector length. VEC_LENGTH has to be bitween 0 for length 1 and 3 for length 4.
#define VECTOR_LENGTH(VEC_LENGTH) "fmrx    r0, fpscr                         \n\t" \
"bic     r0, r0, #0x00370000               \n\t" \
"orr     r0, r0, #0x000" #VEC_LENGTH "0000 \n\t" \
"fmxr    fpscr, r0                         \n\t"




#endif
