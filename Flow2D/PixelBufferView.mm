//
//  PixelBufferView.m
//  Flow2D
//
//  Created by Dan Borthwick on 04/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PixelBufferView.h"

#import "PixelBufferProvider.h"
#import "Profiler.h"
#import "ProgressivePixelBufferProvider.h"
#import "Renderable.h"
#import "SimplePixelBufferProvider.h"

const int screenWidth = 960;
const int screenHeight = 640;
const int sampleSize = 16;

int frameCount = 0;

@interface PixelBufferView()
{
    Renderable* pRenderer;
}

@property ProgressivePixelBufferProvider* bufferProvider;

- (void)initialiseBufferProvider;
- (void)initialiseAnimation;
- (void)tickAnimation;

@end

@implementation PixelBufferView

@synthesize bufferProvider;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialiseBufferProvider];
        [self initialiseAnimation];
    }
    
    return self;
}

- (void)initialiseBufferProvider
{
//    bufferProvider = [[SimplePixelBufferProvider alloc] initWithScreenWidth:screenWidth andScreenHeight:screenHeight];
    
    bufferProvider = [[ProgressivePixelBufferProvider alloc] initWithScreenWidth:screenWidth andScreenHeight:screenHeight andMinimumDownsample:1 andMaximumDownsample:4];
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

    if ([bufferProvider hasLowerDownsampleLevel]) {
        [bufferProvider progressToNextDownsampleLevel];
        [super setNeedsDisplay];
    }
}

- (void)addEffect:(Renderable*)effect
{
    pRenderer = effect;
}

- (void)drawRect:(CGRect)rect
{
    Profiler* profiler = nil;
    if (![bufferProvider hasLowerDownsampleLevel]) {
        profiler = [[Profiler alloc] initWithName:@"PixelBufferView.drawRect"];
        [profiler start];
    }
    
    RGBABuffer const& buffer = [bufferProvider buffer];
    pRenderer->render(buffer, frameCount);
    
    if (profiler != nil) {
        [profiler finish];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       buffer.buffer,
                                                       buffer.width,
                                                       buffer.height,
                                                       8, // bitsPerComponent
                                                       4 * buffer.width, // bytesPerRow
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

-(void)setNeedsDisplay
{
    [bufferProvider setDownsamplingToMaximum];
    [super setNeedsDisplay];
}


@end
