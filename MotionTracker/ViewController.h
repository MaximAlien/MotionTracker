//
//  ViewController.h
//  MotionTracker
//
//  Created by maxim.makhun on 12/28/13.
//  Copyright (c) 2013 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController
{

}

@property (weak, nonatomic) IBOutlet UILabel *totalSteps;
@property (weak, nonatomic) IBOutlet UILabel *totalStepsYesterday;
@property (weak, nonatomic) IBOutlet UILabel *distanceTravelled;

@property (strong, nonatomic) CMMotionActivityManager *motionActivitiyManager;
@property (strong, nonatomic) CMPedometer *stepCounter;
@property (strong, nonatomic) CMMotionActivity *motionActivity;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *locationHistory;

@end
