//
//  Profiler.m
//  Flow2D
//
//  Created by Dan Borthwick on 17/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Profiler.h"

#include <mach/mach.h>
#include <mach/mach_time.h>

@implementation Profiler

@synthesize name;
@synthesize startTime;

-(id)initWithName:(NSString*)aName
{
    self = [super init];
    if (self) {
        self.name = aName;
    }
    return self;
}

-(void)start
{
    startTime = mach_absolute_time();
}

-(void)finish
{
    static mach_timebase_info_data_t    sTimebaseInfo;

    if (sTimebaseInfo.denom == 0) {
        (void) mach_timebase_info(&sTimebaseInfo);
    }
    

    uint64_t endTime = mach_absolute_time();
    uint64_t elapsedTime = endTime - startTime;
    uint64_t elapsedNanoseconds = elapsedTime * sTimebaseInfo.numer / sTimebaseInfo.denom;
    uint64_t elapsedMilliseconds = elapsedNanoseconds / 1000000;
    NSLog(@"%@ %llums", name, elapsedMilliseconds);
}

@end
