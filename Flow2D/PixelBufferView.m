//
//  PixelBufferView.m
//  Flow2D
//
//  Created by Dan Borthwick on 04/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PixelBufferView.h"

const CGFloat cGrey[4] = {0.7f, 0.7f, 0.7f, 1.0f};
const CGFloat cGreen[4] = {0.0f, 1.0f, 0.0f, 1.0f};
const CGFloat cBlack[4] = {0.0f, 0.0f, 0.0f, 1.0f};

int frameCount = 0;

@interface PixelBufferView()

- (void)allocateFrameBuffer;
- (void)initialiseAnimation;
- (void)tickAnimation;

@end

@implementation PixelBufferView

@synthesize rgbaPixels;
@synthesize rgbaComponents;
@synthesize width;
@synthesize height;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        width = 256;
        height = 256;
        [self allocateFrameBuffer];
        [self initialiseAnimation];
    }
    
    return self;
}

- (void)allocateFrameBuffer
{
    rgbaPixels = malloc(width * height * sizeof(rgbaPixel));
    rgbaComponents = (rgbaComponent*) rgbaPixels;
}

- (void)initialiseAnimation
{
//    NSLog(@"initialiseAnimation");
    NSTimeInterval frameInterval = 1 / 60.0;
    [NSTimer scheduledTimerWithTimeInterval:frameInterval target:self selector:@selector(tickAnimation) userInfo:nil repeats:YES];
}

- (void)tickAnimation
{
//    NSLog(@"tickAnimation");
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"Drawing!!");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(int i=0; i < width*height; ++i) {
        rgbaComponents[4*i] = i%width;
        rgbaComponents[4*i+1] = i/width;
        rgbaComponents[4*i+2] = 255;
        rgbaComponents[4*i+3] = 0;
    }

    for (int row = 0; row < height; row++) {
        for (int column = 0; column < width; column+=16) {
            rgbaComponents[(4 * ((row * width) + column)) + 0] = frameCount;
            rgbaComponents[(4 * ((row * width) + column)) + 1] = frameCount;
            rgbaComponents[(4 * ((row * width) + column)) + 2] = frameCount;
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       rgbaPixels,
                                                       width,
                                                       height,
                                                       8, // bitsPerComponent
                                                       4*width, // bytesPerRow
                                                       colorSpace,
                                                       kCGImageAlphaNoneSkipLast);
    CFRelease(colorSpace);

    CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
                                     
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    
    frameCount = (frameCount + 1) % 256;
}


@end
