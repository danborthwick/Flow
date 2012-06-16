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

-(void)mapStatesToSelectors;
-(void)handlePanBeganEvent:(UIPanGestureRecognizer*)recognizer;
-(void)handlePanChangedEvent:(UIPanGestureRecognizer*)recognizer;

@end

@implementation PanController

-(id)initWithView:(UIView *)view andEffect:(FractalEffect*)effect
{
    self = [super initWithView:view andEffect:effect andRecognizerClass:[UIPanGestureRecognizer class]];
    if (self)
    {
        [self mapStatesToSelectors];
    }
    return self;
}


-(void)mapStatesToSelectors
{
    [self mapGestureState:UIGestureRecognizerStateBegan toSelector:@selector(handlePanBeganEvent:)];
    [self mapGestureState:UIGestureRecognizerStateChanged toSelector:@selector(handlePanChangedEvent:)];
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
    CGPoint translationInMandelbrotCoordinates = CGPointMake(-translationInViewCoordinates.x * viewToMandelbrotScaleFactor, -translationInViewCoordinates.y * viewToMandelbrotScaleFactor);

    NSLog(@"Translate view(%.0f, %.0f) mandelbrot(%.4f, %.4f)",
          translationInViewCoordinates.x, translationInViewCoordinates.y,
          translationInMandelbrotCoordinates.x, translationInMandelbrotCoordinates.y
          );
 
    newVisibleRegion.translate(translationInMandelbrotCoordinates);
    mEffect->setVisibleRegion(newVisibleRegion);
    
    [self.mView setNeedsDisplay];
}

@end