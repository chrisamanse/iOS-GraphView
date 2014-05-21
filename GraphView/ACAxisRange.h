//
//  ACAxisRange.h
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACAxisRange : NSObject

@property (strong, nonatomic, readonly) NSNumber *minimumNumber;
@property (strong, nonatomic, readonly) NSNumber *maximumNumber;

// unit length = max-min/plotWidth

+ (instancetype)axisRangeWithMinimum:(double)minimmum andMaximum:(double)maximum;

@end
