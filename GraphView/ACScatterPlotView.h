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
@property (strong, nonatomic) NSNumber *resolution;
@property (strong, nonatomic) NSNumber *padding;
@property (strong, nonatomic) NSNumber *xInset;
@property (strong, nonatomic) NSNumber *yInset;
@property (strong, nonatomic) NSNumber *lineWidth;

@property (strong, nonatomic) NSNumber *stepSize;

@property (strong, nonatomic) ACAxis *xAxis;
@property (strong, nonatomic) ACAxis *yAxis;

@property (strong, nonatomic) ACAxisRange *xAxisRange;
@property (strong, nonatomic) ACAxisRange *yAxisRange;

- (void)drawScatterPlot;

@end

// Data source provides data - y values
@protocol ACScatterPlotViewDataSource <NSObject>

@required
- (NSNumber *)scatterPlotView:(ACScatterPlotView *)scatterPlotView numberForValueUsingX:(double)xValue;

@end

// Send messages to delegate when selection occurs
@protocol ACScatterPlotViewDelegate <NSObject>

@optional

- (void)scatterPlotView:(ACScatterPlotView *)scatterPlotView didSelectXValue:(double)xValue withResultingYValue:(double)yValue;
- (void)scatterPlotViewDidRemoveOverlay:(ACScatterPlotView *)scatterPlotView;

@end