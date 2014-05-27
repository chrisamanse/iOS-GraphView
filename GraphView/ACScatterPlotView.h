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
@protocol ACScatterPlotViewDelegate;

@interface ACScatterPlotView : UIView

@property (weak, nonatomic) id<ACScatterPlotViewDataSource>dataSource;
@property (weak, nonatomic) id<ACScatterPlotViewDelegate>delegate;

@property (strong, nonatomic, readonly) UIImageView *imageViewScatterPlot;
@property (strong, nonatomic) NSNumber *resolution; // Sets image resolution scale from container view size. If not set, default is set to screen's scale ([UIScreen mainScreen].scale), results to same size of container in pixels
@property (strong, nonatomic) NSNumber *padding; // Top, right, bottom, left padding of graph (including axes and labels)
@property (strong, nonatomic) NSNumber *leftInset; // Left inset - serves as a space for y axis labels
@property (strong, nonatomic) NSNumber *bottomInset; // Bottom inset - space for x axis labels

// Line Widths
@property (strong, nonatomic) NSNumber *lineWidth;
@property (strong, nonatomic) NSNumber *overlayLineWidth;
@property (strong, nonatomic) NSNumber *overlayIndicatorRadius;
@property (strong, nonatomic) NSNumber *axesLineWidth;

// Colors
@property (strong, nonatomic) UIColor *lineColor;
@property (strong, nonatomic) UIColor *overlayLineColor;
@property (strong, nonatomic) UIColor *overlayIndicatorColor;
@property (strong, nonatomic) UIColor *axesLineColor;

@property (strong, nonatomic) NSNumber *stepSize; // Determines x values to be passed to dataSource

@property (strong, nonatomic) NSNumber *rotationAngleOfLabels; // Tilt x axis labels. If not set, or set to 0, labels will not be tilted

// Properties for axes (ticks, label font size)
@property (strong, nonatomic) ACAxis *xAxis;
@property (strong, nonatomic) ACAxis *yAxis;

// Range of axes - if y axis range is not set, its min and max are generated automatically based on dataSource
@property (strong, nonatomic) ACAxisRange *xAxisRange;
@property (strong, nonatomic) ACAxisRange *yAxisRange;

- (void)regenerateMinimumAndMaximumValuesOfYAxisRange;
- (void)drawScatterPlot;

@end

// Data source provides data - y values
@protocol ACScatterPlotViewDataSource <NSObject>

@required
- (NSNumber *)scatterPlotView:(ACScatterPlotView *)scatterPlotView numberForValueUsingX:(double)xValue;

@optional
- (NSString *)scatterPlotView:(ACScatterPlotView *)scatterPlotView stringForLabelBelowX:(double)xValue;

@end

// Send messages to delegate when selection occurs
@protocol ACScatterPlotViewDelegate <NSObject>

@optional

- (void)scatterPlotView:(ACScatterPlotView *)scatterPlotView didSelectXValue:(double)xValue withResultingYValue:(double)yValue;
- (void)scatterPlotViewDidRemoveOverlay:(ACScatterPlotView *)scatterPlotView;

@end