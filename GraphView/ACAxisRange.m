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

+ (instancetype)axisRangeWithMinimum:(double)minimum andMaximum:(double)maximum {
    ACAxisRange *axisRange = [[ACAxisRange alloc] init];
    
    if (minimum >= maximum) {
        return nil;
    }
    
    axisRange.minimumNumber = [NSNumber numberWithDouble:minimum];
    axisRange.maximumNumber = [NSNumber numberWithDouble:maximum];
    
    return axisRange;
}

+ (instancetype)axisRangeGenerateMinimumAndMaximumUsingNumbersInArray:(NSArray *)values {
    if (values.count > 0 && [[values firstObject] isKindOfClass:[NSNumber class]]) {
        NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"doubleValue" ascending:YES];
        NSArray *sortedArray = [values sortedArrayUsingDescriptors:@[sort1]];
        NSNumber *minimum = (NSNumber *)[sortedArray firstObject];
        NSNumber *maximum = (NSNumber *)[sortedArray lastObject];
        
        NSLog(@"%0.2f", minimum.doubleValue);
        NSLog(@"%0.2f", maximum.doubleValue);
        ACAxisRange *axisRange = [[ACAxisRange alloc] init];
        axisRange.minimumNumber = minimum;
        axisRange.maximumNumber = maximum;
        return axisRange;
    }
    return nil;
}

- (NSNumber *)getUnitLengthUsingPlotWidthOrHeight:(double)plotDimension {
    double unitLength = plotDimension/(self.maximumNumber.doubleValue-self.minimumNumber.doubleValue);
    return [NSNumber numberWithDouble:unitLength];
}

@end
