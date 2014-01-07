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

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    NSInteger todayStepsCount;
    CLLocation *currentLocation;
    CLLocation *oldLocation;
    CLLocationDistance totalDistance;
    NSTimeInterval lastDistanceCalculation;
    CLLocation *bestEffortAtLocation;
}

@property (weak, nonatomic) IBOutlet UILabel *totalSteps;
@property (strong, nonatomic) CMMotionActivityManager *motionActivitiyManager;
@property (strong, nonatomic) CMStepCounter *stepCounter;
@property (strong, nonatomic) CMMotionActivity *motionActivity;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *totalStepsYesterday;
- (IBAction)zoomBackToUserLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *distanceTravelled;

@property (strong, nonatomic) MKPolylineView* routeLineView;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *locationHistory;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, readwrite) MKMapRect routeRect;
@property (strong, nonatomic) MKPolyline* routeLine;

@end
