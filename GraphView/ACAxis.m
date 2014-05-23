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
        self.labelFontSize = 10.0;
    }
    return self;
}

- (NSNumber *)majorIntervalLength {
    if (!_majorIntervalLength) {
        _majorIntervalLength = [NSNumber numberWithDouble:5];
    }
    return _majorIntervalLength;
}

- (NSNumber *)minorTicksBetweenMajorIntervals {
    if (!_minorTicksBetweenMajorIntervals) {
        _minorTicksBetweenMajorIntervals = [NSNumber numberWithInt:4];
    }
    return _minorTicksBetweenMajorIntervals;
}

- (NSNumber *)majorTickLength {
    if (!_majorTickLength) {
        _majorTickLength = [NSNumber numberWithDouble:10.0];
    }
    return _majorTickLength;
}

- (NSNumber *)minorTickLength {
    if (!_minorTickLength) {
        _minorTickLength = [NSNumber numberWithDouble:5.0];
    }
    return _minorTickLength;
}

@end
