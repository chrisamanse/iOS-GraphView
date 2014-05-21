//
//  ACGraphView.m
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import "ACScatterPlotView.h"

#define kConstant self.resolution.doubleValue

@interface ACScatterPlotView () {
    CGPoint initialPoint;
    CGPoint lastPoint;
    BOOL firstTimeOverlay;
}

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
        _imageViewScatterPlot = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                              0,
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
        _imageViewOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
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

- (NSNumber *)padding {
    if (!_padding) {
        _padding = [NSNumber numberWithInt:10];
    }
    return _padding;
}

- (NSNumber *)resolution {
    if (!_resolution) {
        _resolution = [NSNumber numberWithInt:2];
    }
    return _resolution;
}

- (NSNumber *)lineWidth {
    if (!_lineWidth) {
        _lineWidth = [NSNumber numberWithDouble:0.75];
    }
    return _lineWidth;
}

- (ACAxisRange *)xAxisRange {
    if (!_xAxisRange) {
        _xAxisRange = [ACAxisRange axisRangeWithMinimum:0 andMaximum:10];
    }
    return _xAxisRange;
}

- (ACAxisRange *)yAxisRange {
    if (!_yAxisRange) {
        _yAxisRange = [ACAxisRange axisRangeWithMinimum:0 andMaximum:10];
    }
    return _yAxisRange;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.imageViewScatterPlot];
//    NSLog(@"%0.2f, %0.2f", point.x, point.y);
    
    [self drawOverlayWithPoint:point];
    initialPoint = point;
    
    firstTimeOverlay = !firstTimeOverlay;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.imageViewScatterPlot];
//    NSLog(@"%0.2f, %0.2f", point.x, point.y);
    [self drawOverlayWithPoint:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.imageViewScatterPlot];
    
    // If initially touched point is near point where touch lifted, remove overlay
    if (!firstTimeOverlay &&
        point.x >= initialPoint.x-5 && point.x <= initialPoint.x+5 &&
        point.y >= initialPoint.y-5 && point.y <= initialPoint.y+5 &&
        point.x >= lastPoint.x-5 && point.x <= lastPoint.x+5 &&
        point.y >= lastPoint.y-5 && point.y <= lastPoint.y+5
        ) {
        self.imageViewOverlay.image = nil;
    }
    
    lastPoint = point;
}

#pragma mark - Draw scatter plot

- (void)drawScatterPlot {
    CGSize mySize = self.frame.size;
    double resolution = self.resolution.doubleValue;
    
    UIGraphicsBeginImageContext(CGSizeMake(mySize.width*resolution,
                                           mySize.height*resolution));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    double insetX = 20;
    double plotWidth = (mySize.width-((2*self.padding.doubleValue)+insetX))*resolution;
    double insetY = 20;
    double plotHeight = (mySize.height-((2*self.padding.doubleValue)+insetY))*resolution;
    
    double plotOriginX = (self.padding.doubleValue+insetX)*resolution;
    double plotOriginY = self.padding.doubleValue*resolution;
    
    NSLog(@"Origin (%0.2f, %0.2f)", plotOriginX, plotOriginY);
    NSLog(@"Size (%0.2f, %0.2f)", plotWidth, plotHeight);
    CGRect rect = CGRectMake(plotOriginX, plotOriginY, plotWidth, plotHeight);
    
    [self drawBoundsInContext:currentContext withRect:rect];
    
//    [self drawLinesInContext:currentContext withSize:mySize andResolution:resolution];
    [self drawLinesInContext:currentContext inRect:rect];
    self.imageViewScatterPlot.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (void)drawBoundsInContext:(CGContextRef)context withRect:(CGRect)rect {
    CGPoint *origin = &rect.origin;
    CGSize *size = &rect.size;
    CGContextMoveToPoint(context, origin->x, origin->y);
    CGContextAddLineToPoint(context, origin->x, origin->y+size->height);
    CGContextAddLineToPoint(context, origin->x+size->width, origin->y+size->height);
//    CGContextAddLineToPoint(context, origin->x+size->width, origin->y);
//    CGContextAddLineToPoint(context, origin->x, origin->y);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth.doubleValue*self.resolution.doubleValue);
    CGContextSetRGBStrokeColor(context, 0, 0, 1.0, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextStrokePath(context);
}

#pragma mark *** Should be used only within drawScatterPlot: ***
- (void)drawAxesInContext:(CGContextRef)context withSize:(CGSize)mySize andResolution:(double)resolution {
    
}

- (void)drawAxesTicksInContext:(CGContextRef)context withSize:(CGSize)mySize andResolution:(double)resolution {
    
}

- (void)drawAxesLabelsInContext:(CGContextRef)context withSize:(CGSize)mySize andResolution:(double)resolution {
    
}

- (void)drawLinesInContext:(CGContextRef)context inRect:(CGRect)rect {
    int interval = 10;
    
    CGPoint *origin = &rect.origin;
    CGSize *size =&rect.size;
    
    // Unit length
    double unitLength = [self.xAxisRange getUnitLengthUsingPlotWidth:size->width].doubleValue;
    NSLog(@"Unit length: %0.2f", unitLength);
    // Initial y
    double yInitial = origin->y+size->height;
    
    // Initial point
    CGContextMoveToPoint(context, origin->x, yInitial);
    
    // Lines
    double xInitial = origin->x;
    double xMax = origin->x+size->width;
    
    for (double i = xInitial+unitLength; i <= xMax; i=i+unitLength) {
        double yValue = arc4random()%(int)size->height;
        double yPositionInPlot = size->height - yValue+origin->y;
        CGContextAddLineToPoint(context, i, yPositionInPlot);
        NSLog(@"%0.2f", yValue);
    }
    
    // Line properties
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth.doubleValue*self.resolution.doubleValue);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextStrokePath(context);
}

//- (void)drawLinesInContext:(CGContextRef)context withSize:(CGSize)mySize andResolution:(double)resolution {
//    int interval = 10;
//    
//    // Initial point
//    CGContextMoveToPoint(context, 0+self.padding.doubleValue*resolution,
//                         (mySize.height-self.padding.doubleValue)*resolution);
//    
//    // Lines
//    for (int i = 0; i*interval+self.padding.doubleValue*resolution <= (mySize.width-self.padding.doubleValue)*resolution; i++) {
//        double yValue = arc4random()%(int)((mySize.height-2*self.padding.doubleValue)*resolution);
////        yValue = 600;
//        yValue -= 2*self.padding.doubleValue;
//        CGContextAddLineToPoint(context, i*interval+self.padding.doubleValue*resolution,
//                                ((mySize.height-2*self.padding.doubleValue)*resolution)-
//                                yValue); // arc4random is y value
//    }
//    
//    // Line properties
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextSetLineWidth(context, self.lineWidth.doubleValue*resolution);
//    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
//    CGContextSetBlendMode(context, kCGBlendModeNormal);
//    CGContextStrokePath(context);
//}

#pragma mark - Draw selection overlay

- (void)drawOverlayWithPoint:(CGPoint)point {
    CGSize mySize = self.frame.size;
    double resolution = self.resolution.doubleValue;
    
    double insetX = 20;
    double plotWidth = (mySize.width-((2*self.padding.doubleValue)+insetX))*resolution;
    double insetY = 20;
    double plotHeight = (mySize.height-((2*self.padding.doubleValue)+insetY))*resolution*(mySize.width/mySize.height);
    
    double plotOriginX = (self.padding.doubleValue+insetX)*resolution;
    double plotOriginY = self.padding.doubleValue*resolution*(mySize.width/mySize.height);
    
    if (point.x*resolution >= plotOriginX && point.x*resolution <= plotOriginX+plotWidth) {
        UIGraphicsBeginImageContext(CGSizeMake(mySize.width*resolution,
                                               mySize.width*resolution));
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        
        // Draw vertical line as indicator of location
        //    CGContextMoveToPoint(currentContext, point.x*resolution, mySize.height*resolution);
        CGContextMoveToPoint(currentContext, point.x*resolution, plotOriginY+plotHeight);
        CGContextAddLineToPoint(currentContext, point.x*resolution, plotOriginY);
        
        CGContextSetLineCap(currentContext, kCGLineCapRound);
        CGContextSetLineWidth(currentContext, self.lineWidth.doubleValue*resolution);
        CGContextSetRGBStrokeColor(currentContext, 1.0, 0, 0, 1.0);
        CGContextSetBlendMode(currentContext, kCGBlendModeNormal);
        CGContextStrokePath(currentContext);
        
        self.imageViewOverlay.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
//    CGSize mySize = self.frame.size;
//    double resolution = self.resolution.doubleValue;
//    
//    double offsetX = 20;
//    double plotWidth = (mySize.width-((2*self.padding.doubleValue)+offsetX))*resolution;
//    double offsetY = 20;
//    double plotHeight = (mySize.height-((2*self.padding.doubleValue)+offsetY))*resolution;
//    
//    double plotOriginX = (self.padding.doubleValue+offsetX)*resolution;
//    double plotOriginY = self.padding.doubleValue*resolution;
//    
//    CGRect plotRect = CGRectMake(plotOriginX, plotOriginY, plotWidth, plotHeight);
//
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
