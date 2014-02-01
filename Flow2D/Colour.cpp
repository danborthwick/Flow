//
//  Colour.c
//  Flow2D
//
//  Created by Dan Borthwick on 29/01/2014.
//
//

#include "Colour.h"

rgbaPixel interpolateColour(rgbaPixel colourOne, rgbaPixel colourTwo, float interpolationFactor)
{
	rgbaPixel result;
	
	result.components.red = ((float)colourOne.components.red * (1.0 - interpolationFactor))
								+ ((float) colourTwo.components.red * interpolationFactor);
	result.components.green = ((float)colourOne.components.green * (1.0 - interpolationFactor))
								+ ((float) colourTwo.components.green * interpolationFactor);
	result.components.blue = ((float)colourOne.components.blue * (1.0 - interpolationFactor))
								+ ((float) colourTwo.components.blue * interpolationFactor);
	result.components.alpha = ((float)colourOne.components.alpha * (1.0 - interpolationFactor))
								+ ((float) colourTwo.components.alpha * interpolationFactor);
	
	return result;
}