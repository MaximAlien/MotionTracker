//
//  ViewController.h
//  MotionTracker
//
//  Created by maxim.makhun on 12/28/13.
//  Copyright (c) 2013 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>
{
    NSInteger todayStepsCount;
    NSInteger totalPoints;
}

@property (weak, nonatomic) IBOutlet UILabel *totalSteps;
@property (strong, nonatomic) CMMotionActivityManager *motionActivitiyManager;
@property (strong, nonatomic) CMStepCounter *stepCounter;
@property (strong, nonatomic) CMMotionActivity *motionActivity;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *totalStepsYesterday;

@end
