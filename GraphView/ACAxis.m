//
//  ACAxis.m
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import "ACAxis.h"

@implementation ACAxis

- (id)init
{
    self = [super init];
    if (self) {
        self.majorIntervalLength = [NSNumber numberWithDouble:5];
        self.minorTicksBetweenMajorIntervals = [NSNumber numberWithDouble:1];
        self.majorTickLength = [NSNumber numberWithDouble:7.0];
        self.minorTickLength = [NSNumber numberWithDouble:5.0];
    }
    return self;
}

@end
