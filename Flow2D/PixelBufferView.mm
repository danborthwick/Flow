//
//  PixelBufferView.m
//  Flow2D
//
//  Created by Dan Borthwick on 04/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PixelBufferView.h"

#import "Renderable.h"

int frameCount = 0;

@interface PixelBufferView()
{
    Renderable* pRenderer;
    RGBABuffer rgbaBuffer;
}

- (void)allocateFrameBuffer;
- (void)initialiseAnimation;
- (void)tickAnimation;

@end

@implementation PixelBufferView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        rgbaBuffer.width = 160;
        rgbaBuffer.height = 80;
        [self allocateFrameBuffer];
        [self initialiseAnimation];
    }
    
    return self;
}

- (void)allocateFrameBuffer
{
    rgbaBuffer.buffer = (rgbaPixel*) malloc(rgbaBuffer.width * rgbaBuffer.height * sizeof(rgbaPixel));
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

- (void)addEffect:(Renderable*)effect
{
    pRenderer = effect;
}

- (void)drawRect:(CGRect)rect
{
    pRenderer->render(rgbaBuffer, frameCount);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       rgbaBuffer.buffer,
                                                       rgbaBuffer.width,
                                                       rgbaBuffer.height,
                                                       8, // bitsPerComponent
                                                       4 * rgbaBuffer.width, // bytesPerRow
                                                       colorSpace,
                                                       kCGImageAlphaNoneSkipLast);
    CFRelease(colorSpace);

    CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
    
    CGSize viewSize = self.bounds.size;
    CGContextDrawImage(context, CGRectMake(0, 0, viewSize.width, viewSize.height), image);
    CGImageRelease(image);
    CGContextRelease(bitmapContext);
    
    frameCount = (frameCount + 1) % 256;
}


@end
