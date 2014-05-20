//
//  ACGraphView.m
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import "ACScatterPlotView.h"

@interface ACScatterPlotView ()

@property (strong, nonatomic) UIImageView *imageViewScatterPlot;
@property (strong, nonatomic) UIImageView *imageViewOverlay;

@end

@implementation ACScatterPlotView

@synthesize imageViewScatterPlot = _imageViewScatterPlot;
@synthesize imageViewOverlay = _imageViewOverlay;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Getters

- (UIImageView *)imageViewScatterPlot {
    if (!_imageViewScatterPlot) {
        CGSize myFrameSize = self.frame.size;
        _imageViewScatterPlot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                              myFrameSize.width,
                                                                              myFrameSize.height)];
        [self addSubview:_imageViewScatterPlot];
    }
    return _imageViewScatterPlot;
}

- (void)setImageViewScatterPlot:(UIImageView *)imageViewScatterPlot {
    if (!imageViewScatterPlot) {
        [_imageViewScatterPlot removeFromSuperview];
    }
    _imageViewScatterPlot = imageViewScatterPlot;
}

- (UIImageView *)imageViewOverlay {
    if (!_imageViewOverlay) {
        CGSize myFrameSize = self.frame.size;
        _imageViewOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                              myFrameSize.width,
                                                                              myFrameSize.height)];
        [self addSubview:_imageViewOverlay];
    }
    return _imageViewOverlay;
}

- (void)setImageViewOverlay:(UIImageView *)imageViewOverlay {
    if (!imageViewOverlay) {
        [_imageViewOverlay removeFromSuperview];
    }
    _imageViewOverlay = imageViewOverlay;
}


#pragma mark - Draw scatter plot

- (void)drawScatterPlot {
    
}

#pragma mark *** Should be used only within drawScatterPlot: ***
- (void)drawAxes {
    
}

- (void)drawAxesTicks {
    
}

- (void)drawAxesLabels {
    
}

#pragma mark - Draw selection overlay

- (void)drawOverlay {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
