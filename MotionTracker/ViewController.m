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
    
    if ([CMPedometer isStepCountingAvailable])
    {
        self.stepCounter = [[CMPedometer alloc] init];
        
        NSDate *currentDate = [NSDate date];
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:currentDate];
        [dateComponents setHour:0];
        NSDate *todayDate = [gregorianCalendar dateFromComponents:dateComponents];
        
        [self.stepCounter startPedometerUpdatesFromDate:todayDate withHandler:^(CMPedometerData *pedometerData, NSError *error)
        {
            [self.totalSteps setText:[NSString stringWithFormat:@"Total steps today: %@", pedometerData.numberOfSteps]];
        }];
        
        
        NSDate *currentD = [NSDate date];
        NSDateComponents *dateComponents1 = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:currentD];
        [dateComponents setDay:dateComponents1.day - 1];
        NSDate *prevDate = [gregorianCalendar dateFromComponents:dateComponents1];

        [self.stepCounter queryPedometerDataFromDate:currentD toDate:prevDate withHandler:^(CMPedometerData *pedometerData, NSError *error)
        {
            NSLog(@"Error: %@", error);
            [self.totalStepsYesterday setText:[NSString stringWithFormat:@"Total steps today: %@", pedometerData.numberOfSteps]];
        }];
        
        
//        for (int i = 1; i < 8; ++i)
//        {
//            NSLog(@"curr: %@", currentD);
//            NSDateComponents *dateComponents = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:currentD];
//            [dateComponents setDay:dateComponents.day - 1];
//            NSDate *prevDate = [gregorianCalendar dateFromComponents:dateComponents];
//            
//
//            NSLog(@"prev: %@", prevDate);
//            
//            [self.stepCounter queryPedometerDataFromDate:currentD toDate:prevDate withHandler:^(CMPedometerData *pedometerData, NSError *error) {
//                NSLog(@"i = %@", pedometerData.numberOfSteps);
//            }];
//            
//            currentD = prevDate;
//        }
        
        
//        NSDate *now = [NSDate date];
//        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDateComponents *comps = [gregorian components:
//                                   NSCalendarUnitYear
//                                   | NSCalendarUnitMonth
//                                   | NSCalendarUnitDay
//                                   | NSCalendarUnitHour fromDate:now];
//        [comps setHour:0];
//        
//        NSDate *today = [gregorian dateFromComponents:comps];
//        [self.stepCounter queryStepCountStartingFrom:today
//                                                  to:now
//                                             toQueue:[NSOperationQueue mainQueue]
//                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
//                                             todayStepsCount = numberOfSteps;
//                                             [self.totalSteps setText:[NSString stringWithFormat:@"Total steps today:%ld", (long)todayStepsCount]];
//                                         }];
//        
//        [comps setDay:comps.day - 1];
//        
//        NSDate *yesterday = [gregorian dateFromComponents:comps];
//        [self.stepCounter queryStepCountStartingFrom:yesterday
//                                                  to:today
//                                             toQueue:[NSOperationQueue mainQueue]
//                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
//                                             [self.totalStepsYesterday setText:[NSString stringWithFormat:@"Total steps yesterday:%ld", (long)numberOfSteps]];
//                                         }];
//        
//        NSOperationQueue *queue = [NSOperationQueue new];
//        queue.name = @"Step Counter Queue";
//        
//        [self.stepCounter startStepCountingUpdatesToQueue:queue updateOn:1 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
//            dispatch_async(dispatch_get_main_queue(),^{
//                NSInteger stepsCount = todayStepsCount + numberOfSteps;
//                [self.totalSteps setText:[NSString stringWithFormat:@"Total steps today:%ld", (long)stepsCount]];
//            });
//        }];
    }
    else
    {
        NSLog(@"Data not available");
    }
}

@end
