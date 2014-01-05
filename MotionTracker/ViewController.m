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

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totalPoints = 0;
    
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
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        
        [_locationManager startUpdatingLocation];
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(self.firstTime)
    {
        CLLocation *startingLocation = [locations objectAtIndex:0];
        
        MKPointAnnotation *startingPointAnnotation = [[MKPointAnnotation alloc] init];
        startingPointAnnotation.title = @"Starting Point";
        startingPointAnnotation.coordinate = startingLocation.coordinate;
        
        [self.mapView addAnnotation:startingPointAnnotation];
        
        self.firstTime = false;
    }
    
    [self.locations addObject:[locations objectAtIndex:0]];
    
    CLLocationCoordinate2D coordinates[[self.locations count]];
    for(int i = 0; i < self.locations.count; i++)
    {
        CLLocation *currentLocation = [self.locations objectAtIndex:i];
        coordinates[i] = currentLocation.coordinate;
    }
    [self.mapView removeOverlays:self.mapView.overlays];
    
    MKPolyline *pathPolyline = [MKPolyline polylineWithCoordinates:coordinates count:self.locations.count];
    [self.mapView addOverlay:pathPolyline];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        polylineRenderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        polylineRenderer.lineWidth = 2.0;
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
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied)
    {
        //you had denied
    }
    
    [manager stopUpdatingLocation];
}

@end
