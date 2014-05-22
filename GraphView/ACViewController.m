//
//  ACViewController.m
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import "ACViewController.h"

#import "ACScatterPlotView.h"

@interface ACViewController () <ACScatterPlotViewDataSource, ACScatterPlotViewDelegate> {
}

@property (strong, nonatomic) IBOutlet UIView *viewScatterPlotViewContainer;
@property (strong, nonatomic) ACScatterPlotView *scatterPlotView;

@property (strong, nonatomic) IBOutlet UILabel *labelXValue;
@property (strong, nonatomic) IBOutlet UILabel *labelYValue;

@property (strong, nonatomic) NSMutableArray *yValues;

@end

@implementation ACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.scatterPlotView = [[ACScatterPlotView alloc]
                            initWithFrame:CGRectMake(0, 0,
                                                     self.viewScatterPlotViewContainer.frame.size.width,
                                                     self.viewScatterPlotViewContainer.frame.size.height)];
    [self.viewScatterPlotViewContainer addSubview:self.scatterPlotView];
    
    self.scatterPlotView.dataSource = self;
    self.scatterPlotView.delegate = self;
    
    ACAxisRange *xAxisRange = [ACAxisRange axisRangeWithMinimum:1 andMaximum:30];
    self.scatterPlotView.xAxisRange = xAxisRange;
    
    double values[30] = {44.0, 43.5, 45.0, 45.1, 45.0, 44.87,
        45.0, 46, 44.0, 45.8, 44, 43.7,
        43.0, 44.5, 43.2, 45.1, 46.0, 44.9,
        45.5, 46.0, 45.8, 46.0, 43.8, 43.21,
        44.5, 43.5, 45.7, 43.1, 43.9, 45.9};
    self.yValues = @[].mutableCopy;
    for (int i = 0; i < 30; i++) {
        [self.yValues addObject:[NSNumber numberWithDouble:values[i]]];
    }
//    ACAxisRange *yAxisRange = [ACAxisRange axisRangeGenerateMinimumAndMaximumUsingNumbersInArray:self.yValues];
//    self.scatterPlotView.yAxisRange = yAxisRange;
    
//    ACAxisRange *yAxisRange = [ACAxisRange axisRangeWithMinimum:0 andMaximum:10];
//    self.scatterPlotView.yAxisRange = yAxisRange;
    self.scatterPlotView.stepSize = [NSNumber numberWithDouble:1];
    
    [self.scatterPlotView drawScatterPlot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressSaveButton:(id)sender {
//    UIImage *image = self.scatterPlotView.imageViewScatterPlot.image;
//    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyyMMddHHmm";
//    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//    NSString *fileName = [NSString stringWithFormat:@"graph_%@.jpeg", dateString];
//    NSURL *imageURL = [url URLByAppendingPathComponent:fileName];
//    NSString *path = imageURL.path;
//    
//    [UIImageJPEGRepresentation(image, 1.0) writeToFile:path atomically:YES];
    
    [self.scatterPlotView regenerateMinimumAndMaximumValuesOfYAxisRange];
    [self.scatterPlotView drawScatterPlot];
}

#pragma mark - ACScatterPlotViewDataSource

- (NSNumber *)scatterPlotView:(ACScatterPlotView *)scatterPlotView numberForValueUsingX:(double)xValue {
    if (scatterPlotView == self.scatterPlotView) {
        return (NSNumber *)self.yValues[(int)xValue-1];
//        return [NSNumber numberWithDouble:xValue];
    }
    return [NSNumber numberWithInt:0];
}

#pragma mark - ACScatterPlotViewDelegate

- (void)scatterPlotView:(ACScatterPlotView *)scatterPlotView didSelectXValue:(double)xValue withResultingYValue:(double)yValue {
    self.labelXValue.text = [NSString stringWithFormat:@"%.3f", xValue];
    self.labelYValue.text = [NSString stringWithFormat:@"%.3f", yValue];
}

- (void)scatterPlotViewDidRemoveOverlay:(ACScatterPlotView *)scatterPlotView {
    self.labelXValue.text = @"";
    self.labelYValue.text = @"";
}
@end
