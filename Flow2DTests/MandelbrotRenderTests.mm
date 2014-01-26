//
//  MandelbrotRenderTests.m
//  Flow2D
//
//  Created by Dan Borthwick on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MandelbrotRenderTests.h"

#import "MandelbrotRender.h"
#import "MandelbrotIterateValuesMatcher.h"
#import "MandelbrotRenderAssemblySingleIteration.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "Assembly.h"

@implementation MandelbrotRenderTests

-(MandelbrotRender&)createRender
{
    RGBABuffer* buffer = new RGBABuffer;
    LinearColourMapper* mapper = new GreyscaleColourMapper(128, 1);
    return *new MandelbrotRender(*buffer, MandelbrotRegion::unitRegion(), *mapper);
}

-(void)testGivenAnEscapePoint_thenIterationsAreCorrect
{
    MandelbrotRender& render = [self createRender];
    int actualIterations = render.iterationsForEscapeTimeOfPoint(-0.2, -0.2);
    
    assertThatInt(actualIterations, equalToInt(MandelbrotRender::cMaxIterations));
}

-(void)testGivenANonEscapePoint_thenIterationsAreCorrect
{
    MandelbrotRender& render = [self createRender];
    int actualIterations = render.iterationsForEscapeTimeOfPoint(-1.2, -1.14);
    
    assertThatInt(actualIterations, equalToInt(3));
}

// x, y, xSquared, ySquared, pointX, pointY
const int testValueCount = 6;
const tIterateParameters inputValues[testValueCount] = {
    {   2.0, 2.0, 0.0, 0.0, 1.0, 1.0    },
    {   -3.8, 0.7, 0.0, 0.0, -0.5, 1.3    },
    {   0.0, 0.0, 0.0, 0.0, 0.0, 0.0    },
    {   -4.1, 5.9, 0.0, 0.0, 0.1, 0.4    },
    {   2.468013579, -0.97538642, 0.0, 0.0, 0.123456789, -3.987654321    },
    {   -0.00000000004, 0.00000000007, 0.0,  0.0, 0.0000000003, -0.000000000002 }
};

// y = 2.0*x*y + pointY;        
// x = xSquared - ySquared + pointX;    
const int knownResultsCount = 1;
const tIterateParameters valuesAfterIterate[knownResultsCount] = {
    {   1.0, 9.0, 4.0, 4.0, 1.0, 1.0 }
};

-(void)testGivenAMatcher_whenExpectedAndActualAreTheSame_thenMatcherSucceeds
{
    tIterateParameters expected = inputValues[0];
    
    assertThatValues(inputValues[0], equalToValues(expected));
}

-(void)testGivenTestData_thenIterateUpdatesValuesCorrectly
{
    MandelbrotRender& render = [self createRender];
    tIterateParameters copy = inputValues[0];
    render.iterate(copy);
    
    assertThatValues(copy, equalToValues(valuesAfterIterate[0]));
}

#ifdef SUPPORT_ASM

-(MandelbrotRender&)createAssemblyRender
{
    RGBABuffer* buffer = new RGBABuffer;
    LinearColourMapper* mapper = new GreyscaleColourMapper(128, 1);
    return *new MandelbrotRenderAssemblySingleIteration(*buffer, MandelbrotRegion::unitRegion(), *mapper);
}

-(void)testGivenNormalAndAssemblyRender_whenIterateIsEvaluated_thenResultsAreTheSame
{
    MandelbrotRender& render = [self createRender];
    MandelbrotRender& assemblyRender = [self createAssemblyRender];

    for (int i=0; i<testValueCount; i++) {
        tIterateParameters normalCopy = inputValues[i];
        tIterateParameters assemblyCopy = inputValues[i];
        
        render.iterate(normalCopy);
        assemblyRender.iterate(assemblyCopy);
        
        assertThatValues(assemblyCopy, equalToValues(normalCopy));
    }
}

-(void)testGivenANonEscapePoint_thenAssemblyIterationsAreCorrect
{
	MandelbrotRender& render = [self createAssemblyRender];

    int actualIterations = render.iterationsForEscapeTimeOfPoint(-1.2, -1.14);
    
    assertThatInt(actualIterations, equalToInt(3));
}


-(void)testGivenAnEscapePoint_whenEscapeIterationsCalculatedWithAssembly_thenResultIsCorrect
{
	MandelbrotRender& render = [self createAssemblyRender];
	
    int actualIterations = render.iterationsForEscapeTimeOfPoint(-0.2, -0.2);
    
    assertThatInt(actualIterations, equalToInt(MandelbrotRender::cMaxIterations));
}

#endif

@end
