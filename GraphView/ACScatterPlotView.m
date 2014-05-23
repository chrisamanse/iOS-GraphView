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
    __block UIImage *imageHolder;
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

- (NSNumber *)resolution {
    if (!_resolution) {
        _resolution = [NSNumber numberWithDouble:[UIScreen mainScreen].scale];
    }
    return _resolution;
}

- (NSNumber *)padding {
    if (!_padding) {
        _padding = [NSNumber numberWithInt:10];
    }
    return _padding;
}

- (NSNumber *)leftInset {
    if (!_leftInset) {
        _leftInset = [NSNumber numberWithDouble:20];
    }
    return _leftInset;
}

- (NSNumber *)bottomInset {
    if (!_bottomInset) {
        _bottomInset = [NSNumber numberWithDouble:20];
    }
    return _bottomInset;
}

- (NSNumber *)lineWidth {
    if (!_lineWidth) {
        _lineWidth = [NSNumber numberWithDouble:0.75];
    }
    return _lineWidth;
}

- (NSNumber *)stepSize {
    if (!_stepSize) {
        _stepSize = [NSNumber numberWithDouble:1];
    }
    return _stepSize;
}

- (NSNumber *)tiltedLabelAngleInRadians {
    if (!_tiltedLabelAngleInRadians) {
        _tiltedLabelAngleInRadians = [NSNumber numberWithDouble:0];
    }
    return _tiltedLabelAngleInRadians;
}

- (ACAxis *)xAxis {
    if (!_xAxis) {
        _xAxis = [[ACAxis alloc] init];
    }
    return _xAxis;
}

- (ACAxis *)yAxis {
    if (!_yAxis) {
        _yAxis = [[ACAxis alloc] init];
    }
    return _yAxis;
}

- (ACAxisRange *)xAxisRange {
    if (!_xAxisRange) {
        _xAxisRange = [ACAxisRange axisRangeWithMinimum:1 andMaximum:10];
    }
    return _xAxisRange;
}

- (ACAxisRange *)yAxisRange {
    if (!_yAxisRange) {
        NSLog(@"Initializing yAxisRange");
        // Generate minimum and maximum automatically using dataSource
        NSNumber *xValue = self.xAxisRange.minimumNumber;
        NSMutableArray *yValues = @[].mutableCopy;
        for (double i = xValue.doubleValue; i < self.xAxisRange.maximumNumber.doubleValue; i+=self.stepSize.doubleValue) {
            [yValues addObject:[self.dataSource scatterPlotView:self numberForValueUsingX:i]];
        }
        _yAxisRange = [ACAxisRange axisRangeGenerateMinimumAndMaximumUsingNumbersInArray:yValues];
    }
    return _yAxisRange;
}

#pragma mark - Instance Methods

- (void)regenerateMinimumAndMaximumValuesOfYAxisRange {
    self.yAxisRange = nil;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.imageViewScatterPlot];
    [self drawOverlayWithPoint:point];
    initialPoint = point;
    
    firstTimeOverlay = !firstTimeOverlay;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.imageViewScatterPlot];
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
        if ([self.delegate respondsToSelector:@selector(scatterPlotViewDidRemoveOverlay:)]) {
            [self.delegate scatterPlotViewDidRemoveOverlay:self];
        }
    }
    
    lastPoint = point;
}

#pragma mark - Draw scatter plot

- (void)drawScatterPlot {
    CGSize mySize = self.frame.size;
    double resolution = self.resolution.doubleValue;
    
//    // Single thread
//    UIGraphicsBeginImageContext(CGSizeMake(mySize.width*resolution,
//                                           mySize.height*resolution));
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    
//    double insetX = 20;
//    double plotWidth = (mySize.width-((2*self.padding.doubleValue)+insetX))*resolution;
//    double insetY = 20;
//    double plotHeight = (mySize.height-((2*self.padding.doubleValue)+insetY))*resolution;
//    
//    double plotOriginX = (self.padding.doubleValue+insetX)*resolution;
//    double plotOriginY = self.padding.doubleValue*resolution;
//    
//    NSLog(@"Origin (%0.2f, %0.2f)", plotOriginX, plotOriginY);
//    NSLog(@"Size (%0.2f, %0.2f)", plotWidth, plotHeight);
//    CGRect rect = CGRectMake(plotOriginX, plotOriginY, plotWidth, plotHeight);
//    
//    [self drawBoundsInContext:currentContext withRect:rect];
//    
////    [self drawLinesInContext:currentContext withSize:mySize andResolution:resolution];
//    [self drawLinesInContext:currentContext inRect:rect];
//    self.imageViewScatterPlot.image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
    
    // Multithread
    imageHolder = [[UIImage alloc] init];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContext(CGSizeMake(mySize.width*resolution,
                                               mySize.height*resolution));
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        
        double insetX = self.leftInset.doubleValue;
        double plotWidth = (mySize.width-((2*self.padding.doubleValue)+insetX))*resolution;
        double insetY = self.bottomInset.doubleValue;
        double plotHeight = (mySize.height-((2*self.padding.doubleValue)+insetY))*resolution;
        
        double plotOriginX = (self.padding.doubleValue+insetX)*resolution;
        double plotOriginY = self.padding.doubleValue*resolution;
        
        CGRect rect = CGRectMake(plotOriginX, plotOriginY, plotWidth, plotHeight);
        
        [self drawAxesInContext:currentContext inRect:rect];
        [self drawAxesTicksInContext:currentContext inRect:rect];
        [self drawLinesInContext:currentContext inRect:rect];
        
        imageHolder = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self performSelector:@selector(updateImage)];
        });
    });
}

- (void)updateImage {
    self.imageViewScatterPlot.image = imageHolder;
}

#pragma mark *** Should be used only within drawScatterPlot: ***
- (void)drawAxesInContext:(CGContextRef)context inRect:(CGRect)rect {
    CGPoint *origin = &rect.origin;
    CGSize *size = &rect.size;
    CGContextMoveToPoint(context, origin->x, origin->y);
    CGContextAddLineToPoint(context, origin->x, origin->y+size->height);
    CGContextAddLineToPoint(context, origin->x+size->width, origin->y+size->height);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth.doubleValue*self.resolution.doubleValue);
    CGContextSetRGBStrokeColor(context, 0, 0, 1.0, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextStrokePath(context);
}

- (void)drawAxesTicksInContext:(CGContextRef)context inRect:(CGRect)rect {
    CGPoint *origin = &rect.origin;
    CGSize *size = &rect.size;
    double resolution = self.resolution.doubleValue;
    
    double xUnitLength = [self.xAxisRange getUnitLengthUsingPlotWidthOrHeight:size->width].doubleValue;
    double yUnitLength = [self.yAxisRange getUnitLengthUsingPlotWidthOrHeight:size->height].doubleValue;
    
    // X Axis Major Ticks Properties
    double majorIntervalLength = self.xAxis.majorIntervalLength.doubleValue;
    double majorTickLength = self.xAxis.majorTickLength.doubleValue*resolution;
    // X Axis Minor Ticks Properties
    int minorTicksBetweenMajorIntervals = self.xAxis.minorTicksBetweenMajorIntervals.intValue;
    double minorTickIntervalLength = majorIntervalLength/(minorTicksBetweenMajorIntervals+1);
    double minorTickLength = self.xAxis.minorTickLength.doubleValue*resolution;
    
    double xMax = origin->x+size->width + self.stepSize.doubleValue;
    double xAxisYPosition = origin->y+size->height;
    
    // !!! FIX THIS - instead of drawing ticks backward from a major tick, reverse it;
    // X - Draw Major Ticks
    for (double i = origin->x; i <= xMax; i = i + xUnitLength*majorIntervalLength) {
        // X - Draw Major Ticks INCLUDING ORIGIN
        CGContextMoveToPoint(context, i, xAxisYPosition);
        CGContextAddLineToPoint(context, i, xAxisYPosition+majorTickLength);
        
        // X - Draw Minor Ticks
        for (int j = 0; j < minorTicksBetweenMajorIntervals; j++) {
            double xPositionOfMinorTick = i+(j+1)*minorTickIntervalLength*xUnitLength;
            if (xPositionOfMinorTick > origin->x+size->width) {
                break;
            }
            CGContextMoveToPoint(context, xPositionOfMinorTick, xAxisYPosition);
            CGContextAddLineToPoint(context, xPositionOfMinorTick, xAxisYPosition+minorTickLength);
        }
        
        NSString *textLabel;
        double xValue = self.xAxisRange.minimumNumber.doubleValue + (i-origin->x)/xUnitLength;
        
        if ([self.dataSource respondsToSelector:@selector(scatterPlotView:stringForLabelBelowX:)]) {
            textLabel = [self.dataSource scatterPlotView:self stringForLabelBelowX:xValue];
        } else {
            textLabel = [NSString stringWithFormat:@"%.1f", xValue];
        }
        
        // Max font size
        double maxFontSize = 2*((self.padding.doubleValue+self.bottomInset.doubleValue) - majorTickLength/resolution)/textLabel.length;
        
        // Font size set by user or default
        double fontSize = self.xAxis.labelFontSize;
        
        // If greater than max font size, set to max
        if (fontSize > maxFontSize) {
            NSLog(@"X Axis: Font to big, adjusting to max possible font size");
            fontSize = maxFontSize;
        }
        
        BOOL tilted = NO;
        double angle = 0;
        
        // Check if there is a valid assigned angle
        if (self.tiltedLabelAngleInRadians && self.tiltedLabelAngleInRadians.doubleValue != 0) {
            tilted = YES;
            angle = self.tiltedLabelAngleInRadians.doubleValue;
        } else if (majorIntervalLength*xUnitLength <= textLabel.length*fontSize*resolution/2) {
            // If set/default to not tilt, automatic tilt if text is too wide
            NSLog(@"Text to compressed, tilting...");
            tilted = YES;
            angle = 3*M_PI/8;
        }
        
        double xOriginText = i;
        double yOriginText = xAxisYPosition+majorTickLength;
        
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
        
        // Handle tilted angles
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, xOriginText, yOriginText);
        
        double textOriginX = -(NSInteger)textLabel.length*fontSize*resolution/4;
        if (tilted) {
            CGContextRotateCTM(context, -angle);
            textOriginX *= 2;
        }
        double textOriginY = -fontSize*resolution/2;
        [textLabel drawAtPoint:CGPointMake(textOriginX, textOriginY) withFont:[UIFont fontWithName:@"Helvetica" size:fontSize*resolution]];
        CGContextRestoreGState(context);
    }
    
    // Y Axis Major Ticks Properties
    majorIntervalLength = self.yAxis.majorIntervalLength.doubleValue;
    majorTickLength = self.yAxis.majorTickLength.doubleValue*resolution;
    // Y Axis Minor Ticks Properties
    minorTicksBetweenMajorIntervals = self.yAxis.minorTicksBetweenMajorIntervals.intValue;
    minorTickIntervalLength = majorIntervalLength/(minorTicksBetweenMajorIntervals+1);
    minorTickLength = self.yAxis.minorTickLength.doubleValue*resolution;
    
    double yMin = origin->y;
    double yAxisXPosition = origin->x;
    
    // Y - Draw Major Ticks
    for (double i = origin->y+size->height; i >= yMin; i = i - yUnitLength*majorIntervalLength) {
        // Y - Draw Minor Ticks
        CGContextMoveToPoint(context, yAxisXPosition, i);
        CGContextAddLineToPoint(context, yAxisXPosition-majorTickLength, i);
        
        for (int j = 0; j < minorTicksBetweenMajorIntervals; j++) {
            double yPositionOfMinorTick = i-(j+1)*minorTickIntervalLength*yUnitLength;
            if (yPositionOfMinorTick < origin->y) {
                break;
            }
            CGContextMoveToPoint(context, yAxisXPosition, yPositionOfMinorTick);
            CGContextAddLineToPoint(context, yAxisXPosition-minorTickLength, yPositionOfMinorTick);
        }
        
        double yValue = self.yAxisRange.maximumNumber.doubleValue - (i-origin->y)/yUnitLength;
        NSString *textLabel = [NSString stringWithFormat:@"%.2f", yValue];
        
        
        // Max font size
        double maxFontSize = 2*((self.padding.doubleValue+self.leftInset.doubleValue) - majorTickLength/resolution)/textLabel.length;
        
        // Font size set by user or default
        double fontSize = self.yAxis.labelFontSize;
        
        // If greater than max font size, set to max
        if (fontSize > maxFontSize) {
            NSLog(@"Y Axis: Font to big, adjusting to max possible font size");
            fontSize = maxFontSize;
        }
        
        double xOriginText = yAxisXPosition-majorTickLength + fontSize*resolution/2;
        double yOriginText = i;
        
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, xOriginText, yOriginText);
        
        double textOriginX = -(NSInteger)textLabel.length*fontSize*resolution/2 - majorTickLength*fontSize/10;
        double textOriginY = -fontSize*resolution/2;
        
        [textLabel drawAtPoint:CGPointMake(textOriginX, textOriginY) withFont:[UIFont fontWithName:@"Helvetica" size:fontSize*resolution]];
        CGContextRestoreGState(context);
    }
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth.doubleValue*self.resolution.doubleValue);
    CGContextSetRGBStrokeColor(context, 0, 0, 1.0, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextStrokePath(context);
}

- (void)drawAxesLabelsInContext:(CGContextRef)context withSize:(CGSize)mySize andResolution:(double)resolution {
    
}

- (void)drawLinesInContext:(CGContextRef)context inRect:(CGRect)rect {
    CGPoint *origin = &rect.origin;
    CGSize *size = &rect.size;
    
    // Unit length
    double xUnitLength = [self.xAxisRange getUnitLengthUsingPlotWidthOrHeight:size->width].doubleValue;
    double yUnitLength = [self.yAxisRange getUnitLengthUsingPlotWidthOrHeight:size->height].doubleValue;
    
    // Initial y
    double xInitial = self.xAxisRange.minimumNumber.doubleValue;
    double xInitialPositionInPlot = origin->x;
    double yInitial = [self.dataSource scatterPlotView:self numberForValueUsingX:xInitial].doubleValue*yUnitLength;
    double yInitialPositionInPlot = size->height+origin->y - yInitial + self.yAxisRange.minimumNumber.doubleValue*yUnitLength;
    
    // Initial point
    CGContextMoveToPoint(context, xInitialPositionInPlot, yInitialPositionInPlot);
    
    // Lines - Scatter Plot Graph
    double xMax = origin->x+size->width + self.stepSize.doubleValue;
    
    for (double i = xInitialPositionInPlot + xUnitLength*self.stepSize.doubleValue; i <= xMax; i = i + xUnitLength*self.stepSize.doubleValue) {
        double xValue = xInitial + (i-xInitialPositionInPlot)/xUnitLength;
        double yValue = [self.dataSource scatterPlotView:self numberForValueUsingX:xValue].doubleValue;
        
        double yPositionInPlot = size->height+origin->y - (yValue-self.yAxisRange.minimumNumber.doubleValue)*yUnitLength;
        CGContextAddLineToPoint(context, i, yPositionInPlot);
    }
    
    // Line properties - Scatter Plot Graph
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth.doubleValue*self.resolution.doubleValue);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextStrokePath(context);
}

#pragma mark - Draw selection overlay

- (void)drawOverlayWithPoint:(CGPoint)point {
    CGSize mySize = self.frame.size;
    double resolution = self.resolution.doubleValue;
    
    double insetX = self.leftInset.doubleValue;
    double plotWidth = (mySize.width-((2*self.padding.doubleValue)+insetX))*resolution;
    double insetY = self.bottomInset.doubleValue;
    double plotHeight = (mySize.height-((2*self.padding.doubleValue)+insetY))*resolution;
    
    double plotOriginX = (self.padding.doubleValue+insetX)*resolution;
    double plotOriginY = self.padding.doubleValue*resolution;
    
    CGRect rect = CGRectMake(plotOriginX, plotOriginY, plotWidth, plotHeight);
    CGPoint *origin = &rect.origin;
    CGSize *size = &rect.size;
    
    if (point.x*resolution >= plotOriginX && point.x*resolution <= plotOriginX+plotWidth) {
        UIGraphicsBeginImageContext(CGSizeMake(mySize.width*resolution,
                                               mySize.height*resolution));
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        
        // Unit length
        double xUnitLength = [self.xAxisRange getUnitLengthUsingPlotWidthOrHeight:size->width].doubleValue;
        double yUnitLength = [self.yAxisRange getUnitLengthUsingPlotWidthOrHeight:size->height].doubleValue;
        
        double truePointX = point.x*resolution;
        int index = round(((truePointX-plotOriginX)/xUnitLength)/self.stepSize.doubleValue);
        double snappedPointX = origin->x+xUnitLength*self.stepSize.doubleValue*index;
        
        // Get x and y value
        double xValue = self.xAxisRange.minimumNumber.doubleValue+self.stepSize.doubleValue*index;
        double yValue = [self.dataSource scatterPlotView:self numberForValueUsingX:xValue].doubleValue;
        
        double yPositionInPlot = size->height+origin->y - (yValue-self.yAxisRange.minimumNumber.doubleValue)*yUnitLength;
        
        // Draw vertical line as indicator of location
        CGContextMoveToPoint(currentContext, snappedPointX, plotOriginY+plotHeight);
        CGContextAddLineToPoint(currentContext, snappedPointX, plotOriginY);
        
        
        CGContextSetLineCap(currentContext, kCGLineCapRound);
        CGContextSetLineWidth(currentContext, self.lineWidth.doubleValue*resolution);
        CGContextSetRGBStrokeColor(currentContext, 1.0, 0, 0, 1.0);
        CGContextSetBlendMode(currentContext, kCGBlendModeNormal);
        CGContextStrokePath(currentContext);
        
        // Dot indicator for position of y value
        CGRect yValueRect = CGRectMake(snappedPointX-3*resolution,
                                       yPositionInPlot-3*resolution,
                                       3*resolution*2, 3*resolution*2);
        CGContextSetRGBFillColor(currentContext, 1.0, 0, 0, 1.0);
        CGContextFillEllipseInRect(currentContext, yValueRect);
        
        self.imageViewOverlay.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if ([self.delegate respondsToSelector:@selector(scatterPlotView:didSelectXValue:withResultingYValue:)]) {
            [self.delegate scatterPlotView:self didSelectXValue:xValue withResultingYValue:yValue];
        }
    }
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
