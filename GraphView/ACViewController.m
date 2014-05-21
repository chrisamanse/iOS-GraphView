//
//  ACViewController.m
//  GraphView
//
//  Created by Chris Amanse on 5/20/14.
//  Copyright (c) 2014 Chris Amanse. All rights reserved.
//

#import "ACViewController.h"

#import "ACScatterPlotView.h"

@interface ACViewController ()

@property (strong, nonatomic) IBOutlet UIView *viewScatterPlotViewContainer;
@property (strong, nonatomic) ACScatterPlotView *scatterPlotView;

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
    [self.scatterPlotView drawScatterPlot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressSaveButton:(id)sender {
    UIImage *image = self.scatterPlotView.imageViewScatterPlot.image;
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmm";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"graph_%@.jpeg", dateString];
    NSURL *imageURL = [url URLByAppendingPathComponent:fileName];
    NSString *path = imageURL.path;
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:path atomically:YES];
}
@end
