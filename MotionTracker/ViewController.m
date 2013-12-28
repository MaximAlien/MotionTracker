//
//  ViewController.m
//  MotionTracker
//
//  Created by maxim.makhun on 12/28/13.
//  Copyright (c) 2013 MMA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([CMStepCounter isStepCountingAvailable])
    {
        self.totalSteps.text = @"0";
        self.stepCounter = [[CMStepCounter alloc] init];
        
        NSDate *now = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:NSCalendarUnitYear
                                   | NSCalendarUnitMonth
                                   | NSCalendarUnitDay
                                   | NSCalendarUnitHour fromDate:now];
        [comps setHour:0];
        NSDate *today = [gregorian dateFromComponents:comps];
        
        [self.stepCounter queryStepCountStartingFrom:today
                                                  to:now
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                             self.totalSteps.text = [@(numberOfSteps) stringValue];
                                         }];
    }
    else
    {
        NSLog(@"Data not available");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
