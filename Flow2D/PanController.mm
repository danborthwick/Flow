//
//  PanController.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 10/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PanController.h"

#import "FractalEffect.h"

@interface PanController() {
@private
    MandelbrotRegion mRegionAtAtStartOfPan;
}

-(void)setupPanRecognizerWithView:(UIView*)view;
-(void)handlePanBeganEvent:(UIPanGestureRecognizer*)recognizer;
-(void)handlePanChangedEvent:(UIPanGestureRecognizer*)recognizer;

@end

@implementation PanController

-(id)initWithView:(UIView *)view andEffect:(FractalEffect*)effect
{
    self = [super initWithView:view andEffect:effect];
    if (self)
    {
        [self setupPanRecognizerWithView:view];
    }
    return self;
}

-(void)setupPanRecognizerWithView:(UIView*)view
{
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanEvent:)];
    [panRecognizer setDelegate:self];
    [view addGestureRecognizer:panRecognizer];
}

-(void)handlePanEvent:(UIPanGestureRecognizer*)recognizer
{
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:
            [self handlePanBeganEvent:recognizer];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self handlePanChangedEvent:recognizer];
            break;
            
        default:
            break;
    }
}

-(void)handlePanBeganEvent:(UIPanGestureRecognizer*)recognizer
{
    mRegionAtAtStartOfPan = mEffect->visibleRegion();
}

-(void)handlePanChangedEvent:(UIPanGestureRecognizer*)recognizer
{
    MandelbrotRegion newVisibleRegion = mRegionAtAtStartOfPan;

    CGPoint translationInViewCoordinates = [recognizer translationInView:[self mView]];
    CGFloat viewToMandelbrotScaleFactor = [PanController scaleFactorFromView:[self mView] toMandelbrotRegion:newVisibleRegion];
    CGPoint translationInMandelbrotCoordinates = CGPointMake(-translationInViewCoordinates.x * viewToMandelbrotScaleFactor, translationInViewCoordinates.y * viewToMandelbrotScaleFactor);

/*    NSLog(@"Translate view(%.0f, %.0f) mandelbrot(%.4f, %.4f)",
          translationInViewCoordinates.x, translationInViewCoordinates.y,
          translationInMandelbrotCoordinates.x, translationInMandelbrotCoordinates.y
          );
 */
    [PanController panRegion:newVisibleRegion byTranslation:translationInMandelbrotCoordinates];
    
    mEffect->setVisibleRegion(newVisibleRegion);
    
    [self.mView setNeedsDisplay];
}

+(void)panRegion:(MandelbrotRegion&)region byTranslation:(CGPoint&)translation
{
    region.left += translation.x;
    region.right += translation.x;
    region.bottom += translation.y;
    region.top += translation.y;
}

+(float)scaleFactorFromView:(UIView*)view toMandelbrotRegion:(MandelbrotRegion const&)region
{
    float regionWidth = region.right - region.left;
    float viewWidth = view.frame.size.width;
    
    return regionWidth / viewWidth / 2.0f;
}

@end