//
//  ACAxis.h
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACAxis : NSObject

@property (strong, nonatomic) NSNumber *majorIntervalLength;
@property (strong, nonatomic) NSNumber *minorTicksBetweenMajorIntervals;

// minorTicksLength = majorIntervalLength/minorTicksBetweenMajorIntervals
@property (strong, nonatomic) NSNumber *majorTickLength;
@property (strong, nonatomic) NSNumber *minorTickLength;

@end
