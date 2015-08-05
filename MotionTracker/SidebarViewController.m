//
//  SidebarViewController.m
//  MotionTracker
//
//  Created by Maxim Makhun on 6/29/15.
//  Copyright (c) 2015 MMA. All rights reserved.
//

#import "SidebarViewController.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.metricsSegmentedControl insertSegmentWithTitle:@"Kilometers" atIndex:0];
    [self.metricsSegmentedControl insertSegmentWithTitle:@"Miles" atIndex:1];

    [self.metricsSegmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    
    self.metricsSegmentedControl.cornerRadius = 20.0f;
    self.metricsSegmentedControl.segmentIndicatorInset = 2.0f;
    self.metricsSegmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    self.metricsSegmentedControl.segmentIndicatorBackgroundColor = [UIColor greenColor];
    self.metricsSegmentedControl.segmentIndicatorAnimationDuration = 0.5f;
    self.metricsSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
}

- (void)segmentSelected
{
    
}

@end
