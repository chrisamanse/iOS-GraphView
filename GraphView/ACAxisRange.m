//
//  ACAxisRange.m
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import "ACAxisRange.h"

@interface ACAxisRange ()

@property (strong, nonatomic) NSNumber *minimumNumber;
@property (strong, nonatomic) NSNumber *maximumNumber;

@end

@implementation ACAxisRange

+ (instancetype)axisRangeWithMinimum:(double)minimmum andMaximum:(double)maximum {
    ACAxisRange *axisRange = [[ACAxisRange alloc] init];
    
    axisRange.minimumNumber = [NSNumber numberWithDouble:minimmum];
    axisRange.maximumNumber = [NSNumber numberWithDouble:maximum];
    
    return axisRange;
}

- (NSNumber *)getUnitLengthUsingPlotWidthOrHeight:(double)plotDimension {
    double unitLength = plotDimension/(self.maximumNumber.doubleValue-self.minimumNumber.doubleValue);
    return [NSNumber numberWithDouble:unitLength];
}

@end
