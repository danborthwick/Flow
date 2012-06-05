//
//  PixelBufferView.h
//  Flow2D
//
//  Created by Dan Borthwick on 04/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef unsigned int rgbaPixel;
typedef unsigned char rgbaComponent;

@interface PixelBufferView : UIView

@property (readonly) rgbaPixel* rgbaPixels;
@property (readonly) rgbaComponent* rgbaComponents;
@property (readonly) int width;
@property (readonly) int height;

@end
