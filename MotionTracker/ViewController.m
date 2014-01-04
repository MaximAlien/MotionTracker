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
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.mapView.userLocation addObserver:self
                                forKeyPath:@"location"
                                   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                                   context:NULL];
    
    [self zoomToUserLocation:self.mapView.userLocation];
    
//    if (!_locationManager) {
//        _locationManager = [[CLLocationManager alloc] init];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self zoomToUserLocation:self.mapView.userLocation];
}

- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocation)
    {
        return;
    }
    
    MKCoordinateRegion region;
    region.center = userLocation.location.coordinate;
    region.span = MKCoordinateSpanMake(1.0, 1.0);
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([self.mapView showsUserLocation])
    {
        NSLog([NSString stringWithFormat:@"Latitude: %f, Longtitude: %f",
               self.mapView.userLocation.location.coordinate.latitude,
               self.mapView.userLocation.location.coordinate.longitude]);
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
    CLLocation *newLocation = [locations objectAtIndex:locations.count - 1];
    CLLocation *oldLocation = nil;
    
    if (locations.count > 1)
    {
        oldLocation = [locations objectAtIndex:locations.count - 2];
    }
    
    MKMapPoint * pointsArray = malloc(sizeof(CLLocationCoordinate2D)*2);
    pointsArray[0]= MKMapPointForCoordinate(oldLocation.coordinate);
    pointsArray[1]= MKMapPointForCoordinate(newLocation.coordinate);
    
    _routeLine = [MKPolyline polylineWithPoints:pointsArray count:2];
    free(pointsArray);
    
    if (newLocation.coordinate.latitude - oldLocation.coordinate.latitude < 1)
    {
        [[self mapView] addOverlay:_routeLine];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    self.routeLineView = [[MKPolylineView alloc] initWithPolyline:[self routeLine]];
    [[self routeLineView] setFillColor:[UIColor colorWithRed:167/255.0f green:210/255.0f blue:244/255.0f alpha:1.0]];
    [[self routeLineView] setStrokeColor:[UIColor colorWithRed:106/255.0f green:151/255.0f blue:232/255.0f alpha:1.0]];
    [[self routeLineView] setLineWidth:15.0];
    [[self routeLineView] setLineCap:kCGLineCapRound];
    overlayView = [self routeLineView];
    return overlayView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self zoomToUserLocation:userLocation];
}

@end
