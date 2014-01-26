//
//  MandelbrotRenderAssemblySingleIteration.h
//  Flow2D
//
//  Created by Dan Borthwick on 26/01/2014.
//
//

#include "MandelbrotRenderAssemblySingleIteration.h"

#ifdef SUPPORT_ASM

MandelbrotRenderAssemblySingleIteration::MandelbrotRenderAssemblySingleIteration(RGBABuffer const& target, MandelbrotRegion const& regionToRender, LinearColourMapper const& colourMapper)
:	MandelbrotRender(target, regionToRender, colourMapper)
{
	
}

void MandelbrotRenderAssemblySingleIteration::iterate(tIterateParameters& parameters) const
{
    static const coord two = 2.0;
    
    asm volatile (
                  "vldmia.f64 %0, {d0-d5}  \n\t"
                  "vldmia.f64 %1, {d6}     \n\t"
				  
                  "fmuld d2, d0, d0     \n\t"   // xSquared = x*x;
                  "fmuld d3, d1, d1     \n\t"   // ySquared = y*y;
				  
				  // y = 2.0*x*y + pointY;
                  "fmuld d1, d0, d1     \n\t"   // y = x*y
                  "fmuld d1, d1, d6     \n\t"   // y = x*y*2
                  "faddd d1, d1, d5     \n\t"   // y = x*y*2 + pointY
                  
				  // x = xSquared - ySquared + pointX;
                  "fsubd d0, d2, d3     \n\t"   // x = xSqaured - ySquared
                  "faddd d0, d0, d4     \n\t"   // x = xSquared - ySquared + pointX
				  
                  "vstmia.f64 %0, {d0-d3}    \n\t"
                  :
                  : "r" (&parameters), "r" (&two)
                  :
	);
}

#endif //SUPPORT_ASM

