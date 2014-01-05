//
//  ViewController.m
//  MotionTracker
//
//  Created by maxim.makhun on 12/28/13.
//  Copyright (c) 2013 MMA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property BOOL firstTime;

@end

#define kDistanceCalculationInterval 10 // the interval (seconds) at which we calculate the user's distance
#define kNumLocationHistoriesToKeep 5 // the number of locations to store in history so that we can look back at them and determine which is most accurate
#define kValidLocationHistoryDeltaInterval 3 // the maximum valid age in seconds of a location stored in the location history
#define kMinLocationsNeededToUpdateDistance 3 // the number of locations needed in history before we will even update the current distance
#define kRequiredHorizontalAccuracy 40.0f // the required accuracy in meters for a location.  anything above this number will be discarded


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstTime = YES;
    
    if ([CMStepCounter isStepCountingAvailable])
    {
        self.stepCounter = [[CMStepCounter alloc] init];
        
        NSDate *now = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:
                                   NSCalendarUnitYear
                                   | NSCalendarUnitMonth
                                   | NSCalendarUnitDay
                                   | NSCalendarUnitHour fromDate:now];
        [comps setHour:0];
        
        NSDate *today = [gregorian dateFromComponents:comps];
        [self.stepCounter queryStepCountStartingFrom:today
                                                  to:now
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                             todayStepsCount = numberOfSteps;
                                             [self.totalSteps setText:[NSString stringWithFormat:@"Total steps today:%ld", (long)todayStepsCount]];
                                         }];
        
        [comps setDay:comps.day - 1];
        
        NSDate *yesterday = [gregorian dateFromComponents:comps];
        [self.stepCounter queryStepCountStartingFrom:yesterday
                                                  to:today
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                             [self.totalStepsYesterday setText:[NSString stringWithFormat:@"Total steps yesterday:%ld", (long)numberOfSteps]];
                                         }];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.name = @"Step Counter Queue";
        
        [self.stepCounter startStepCountingUpdatesToQueue:queue updateOn:1 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
            dispatch_async(dispatch_get_main_queue(),^{
                NSInteger stepsCount = todayStepsCount + numberOfSteps;
                [self.totalSteps setText:[NSString stringWithFormat:@"Total steps today:%ld", (long)stepsCount]];
            });
        }];
    }
    else
    {
        NSLog(@"Data not available");
    }
    
    [self.mapView setDelegate:self];
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.mapView.userLocation addObserver:self
                                forKeyPath:@"location"
                                   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                                   context:NULL];
    
    [self zoomToUserLocation:self.mapView.userLocation];
    
    self.locations = [NSMutableArray array];
    
    if (![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"location services are disabled");
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        NSLog(@"location services are blocked by the user");
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        NSLog(@"location services are enabled");
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        NSLog(@"about to show a dialog requesting permission");
    }
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    
    /* Pinpoint our location with the following accuracy:
     *
     *     kCLLocationAccuracyBestForNavigation  highest + sensor data
     *     kCLLocationAccuracyBest               highest
     *     kCLLocationAccuracyNearestTenMeters   10 meters
     *     kCLLocationAccuracyHundredMeters      100 meters
     *     kCLLocationAccuracyKilometer          1000 meters
     *     kCLLocationAccuracyThreeKilometers    3000 meters
     */
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    /* Notify changes when device has moved x meters.
     * Default value is kCLDistanceFilterNone: all movements are reported.
     */
    self.locationManager.distanceFilter = 5.0f;
    
    /* Notify heading changes when heading is > 5.
     * Default value is kCLHeadingFilterNone: all movements are reported.
     */
    self.locationManager.headingFilter = 5;
    
    if ([CLLocationManager locationServicesEnabled])
    {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self zoomToUserLocation:self.mapView.userLocation];
}

- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    //    if (!userLocation)
    //    {
    //        return;
    //    }
    //
    //    MKCoordinateRegion region;
    //    region.center = userLocation.location.coordinate;
    //    region.span = MKCoordinateSpanMake(1.0, 1.0);
    //    region = [self.mapView regionThatFits:region];
    //    [self.mapView setRegion:region animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([self.mapView showsUserLocation])
    {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)zoomBackToUserLocation:(id)sender
{
    if (!self.mapView.userLocation)
    {
        return;
    }
    
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.location.coordinate;
    region.span = MKCoordinateSpanMake(0.01, 0.01);
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation
//{
//    MKCoordinateRegion region = { { 0.0f, 0.0f }, { 0.0f, 0.0f } };
//    region.center = newLocation.coordinate;
//    region.span.longitudeDelta = 0.15f;
//    region.span.latitudeDelta = 0.15f;
//    [self.mapView setRegion:region animated:YES];
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (oldLocation == nil) return;
    //BOOL isStaleLocation = [oldLocation.timestamp compare:self.startTimestamp] == NSOrderedAscending;
    
    [self.distanceTravelled setText:[NSString stringWithFormat:@"accuracy: %.2f", newLocation.horizontalAccuracy]];
    
    if ( newLocation.horizontalAccuracy >= 0.0f && newLocation.horizontalAccuracy < kRequiredHorizontalAccuracy) {
        
        [self.locationHistory addObject:newLocation];
        if ([self.locationHistory count] > kNumLocationHistoriesToKeep) {
            [self.locationHistory removeObjectAtIndex:0];
        }
        
        BOOL canUpdateDistance = NO;
        if ([self.locationHistory count] >= kMinLocationsNeededToUpdateDistance) {
            canUpdateDistance = YES;
        }
        
        if ([NSDate timeIntervalSinceReferenceDate] - lastDistanceCalculation > kDistanceCalculationInterval) {
            lastDistanceCalculation = [NSDate timeIntervalSinceReferenceDate];
            
            CLLocation *lastLocation = (lastRecordedLocation != nil) ? lastRecordedLocation : oldLocation;
            
            CLLocation *bestLocation = nil;
            CGFloat bestAccuracy = kRequiredHorizontalAccuracy;
            for (CLLocation *location in self.locationHistory) {
                if ([NSDate timeIntervalSinceReferenceDate] - [location.timestamp timeIntervalSinceReferenceDate] <= kValidLocationHistoryDeltaInterval) {
                    if (location.horizontalAccuracy < bestAccuracy && location != lastLocation) {
                        bestAccuracy = location.horizontalAccuracy;
                        bestLocation = location;
                    }
                }
            }
            if (bestLocation == nil) bestLocation = newLocation;
            
            CLLocationDistance distance = [bestLocation distanceFromLocation:lastLocation];
            if (canUpdateDistance) totalDistance += distance;
            lastRecordedLocation = bestLocation;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self.firstTime)
    {
        startingLocation = [locations objectAtIndex:0];
        
        MKPointAnnotation *startingPointAnnotation = [[MKPointAnnotation alloc] init];
        startingPointAnnotation.title = @"Starting Point";
        startingPointAnnotation.coordinate = startingLocation.coordinate;
        
        [self.mapView addAnnotation:startingPointAnnotation];
        
        self.firstTime = false;
    }
    
    [self.locations addObject:[locations objectAtIndex:0]];
    
    CLLocationCoordinate2D coordinates[[self.locations count]];
    
    for (int i = 0; i < self.locations.count; i++)
    {
        lastRecordedLocation = [self.locations objectAtIndex:i];
        coordinates[i] = lastRecordedLocation.coordinate;
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    MKPolyline *pathPolyline = [MKPolyline polylineWithCoordinates:coordinates count:self.locations.count];
    [self.mapView addOverlay:pathPolyline];
//    totalDistance = [currentLocation distanceFromLocation:startingLocation];    //meters
    
//    [self.distanceTravelled setText:[NSString stringWithFormat:@"Distance travelled:%f", totalDistance]];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.fillColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        polylineRenderer.strokeColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
        polylineRenderer.lineWidth = 3.0;
        
        return polylineRenderer;
    }
    else
    {
        return  nil;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self zoomToUserLocation:userLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        NSLog(@"User has denied location services");
    }
    else
    {
        NSLog(@"Location manager did fail with error: %@", error.localizedFailureReason);
    }
}

@end
