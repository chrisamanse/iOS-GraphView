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

@end
