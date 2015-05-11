//
//  ACAxis.h
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACAxis : NSObject

@property (strong, nonatomic) NSNumber *majorIntervalLength; // Default is 5.0
@property (strong, nonatomic) NSNumber *minorTicksBetweenMajorIntervals; // Default is 4

@property (strong, nonatomic) NSNumber *majorTickLength; // Default is 10.0
@property (strong, nonatomic) NSNumber *minorTickLength; // Default is 5.0

@property (nonatomic) double labelFontSize; // Default is 10.0

@end
