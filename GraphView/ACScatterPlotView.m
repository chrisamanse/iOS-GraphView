//
//  ACGraphView.m
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import "ACScatterPlotView.h"

@interface ACScatterPlotView () {
    CGPoint initialPoint;
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

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.imageViewScatterPlot];
    NSLog(@"%0.2f, %0.2f", point.x, point.y);
    
    [self drawOverlayWithPoint:point];
    initialPoint = point;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.imageViewScatterPlot];
    NSLog(@"%0.2f, %0.2f", point.x, point.y);
    
    [self drawOverlayWithPoint:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.imageViewScatterPlot];
    
    if (point.x >= initialPoint.x-10 && point.x <= initialPoint.x+10 &&
        point.y >= initialPoint.y-10 && point.y <= initialPoint.y+10) {
        self.imageViewOverlay.image = nil;
    }
}

#pragma mark - Draw scatter plot

- (void)drawScatterPlot {
    CGSize mySize = self.frame.size;
    double resolution = 2;
    UIGraphicsBeginImageContext(CGSizeMake(mySize.width*resolution, mySize.width*resolution));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    [self drawLinesInContext:currentContext withSize:mySize andResolution:resolution];
    
    self.imageViewScatterPlot.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark *** Should be used only within drawScatterPlot: ***
- (void)drawAxesInContext:(CGContextRef)context withSize:(CGSize)mySize andResolution:(double)resolution {
    
}

- (void)drawAxesTicksInContext:(CGContextRef)context withSize:(CGSize)mySize andResolution:(double)resolution {
    
}

- (void)drawAxesLabelsInContext:(CGContextRef)context withSize:(CGSize)mySize andResolution:(double)resolution {
    
}

- (void)drawLinesInContext:(CGContextRef)context withSize:(CGSize)mySize andResolution:(double)resolution {
    int interval = 10;
    
    CGContextMoveToPoint(context, 0, mySize.height*resolution);
    for (int i = 0; i*interval <= mySize.width*resolution; i++) {
        CGContextAddLineToPoint(context, i*interval, mySize.height*resolution-(arc4random()%(int)(mySize.height*resolution)));
    }
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextStrokePath(context);
}

#pragma mark - Draw selection overlay

- (void)drawOverlayWithPoint:(CGPoint)point {
    CGSize mySize = self.frame.size;
    double resolution = 2;
    UIGraphicsBeginImageContext(CGSizeMake(mySize.width*resolution, mySize.width*resolution));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Draw vertical line as indicator of location
    CGContextMoveToPoint(currentContext, point.x*resolution, mySize.height*resolution);
    CGContextAddLineToPoint(currentContext, point.x*resolution, 0);
    
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetLineWidth(currentContext, 1.0*resolution);
    CGContextSetRGBStrokeColor(currentContext, 255.0, 0, 0, 1.0);
    CGContextSetBlendMode(currentContext, kCGBlendModeNormal);
    CGContextStrokePath(currentContext);
    
    self.imageViewOverlay.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
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
