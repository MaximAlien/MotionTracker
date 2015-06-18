//
//  ViewController.m
//  MotionTracker
//
//  Created by maxim.makhun on 12/28/13.
//  Copyright (c) 2013 MMA. All rights reserved.
//

#import "ViewController.h"

static int daysCounter = 8;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([CMPedometer isStepCountingAvailable])
    {
        self.stepCounter = [[CMPedometer alloc] init];
        
        NSDate *currentDate = [NSDate date];
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:currentDate];
        [dateComponents setHour:0];
        [dateComponents setDay:dateComponents.day - daysCounter];
        currentDate = [gregorianCalendar dateFromComponents:dateComponents];
        
        for (int i = daysCounter; i >= 0; --i)
        {
            [dateComponents setDay:dateComponents.day + 1];
            NSDate *nextDate = [gregorianCalendar dateFromComponents:dateComponents];

            NSLog(@"Date: %@", nextDate);

            [self.stepCounter queryPedometerDataFromDate:currentDate toDate:nextDate withHandler:^(CMPedometerData *pedometerData, NSError *error)
            {
                NSLog(@"Steps count = %@", pedometerData.numberOfSteps);
            }];
            
            currentDate = nextDate;
        }
    }
    else
    {
        NSLog(@"Data not available");
    }
}

@end
