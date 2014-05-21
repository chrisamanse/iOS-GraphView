//
//  ACGraphView.h
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ACAxis.h"
#import "ACAxisRange.h"

@protocol ACScatterPlotViewDataSource;

@interface ACScatterPlotView : UIView

@property (weak, nonatomic) id<ACScatterPlotViewDataSource>dataSource;

@property (strong, nonatomic, readonly) UIImageView *imageViewScatterPlot;

@property (strong, nonatomic) ACAxis *xAxis;
@property (strong, nonatomic) ACAxis *yAxis;

@property (strong, nonatomic) ACAxisRange *xRange;
@property (strong, nonatomic) ACAxisRange *yRange;

- (void)drawScatterPlot;

@end

@protocol ACScatterPlotViewDataSource <NSObject>

@end

