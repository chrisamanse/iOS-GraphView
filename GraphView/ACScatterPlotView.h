//
//  ACGraphView.h
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ACAxis.h"

@interface ACScatterPlotView : UIView

@property (strong, nonatomic) ACAxis *xAxis;
@property (strong, nonatomic) ACAxis *yAxis;

@end
