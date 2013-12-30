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
                todayStepsCount += numberOfSteps;
                [self.totalSteps setText:[NSString stringWithFormat:@"Total steps today:%ld", (long)todayStepsCount]];
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
}

- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocation)
        return;
    
    MKCoordinateRegion region;
    region.center = userLocation.location.coordinate;
    region.span = MKCoordinateSpanMake(2.0, 2.0);
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
//    CGContextRef ctxt = UIGraphicsGetCurrentContext();
//    
//    CGContextSetStrokeColorWithColor(ctxt, [UIColor blueColor].CGColor);
//    CGContextSetRGBFillColor(ctxt, 0.0, 0.0, 1.0, 1.0);
//    CGContextSetAlpha(ctxt, 0.5);
//    
//    CGContextSetLineWidth(ctxt, 3);
//    
//    CGContextStrokePath(ctxt);
    
    if ([self.mapView showsUserLocation])
    {
        NSLog([NSString stringWithFormat:@"Latitude: %f, Longtitude: %f",
               self.mapView.userLocation.location.coordinate.latitude,
               self.mapView.userLocation.location.coordinate.longitude]);
        
//        CLLocation* location = self.mapView.userLocation.location;
//        CGPoint point = [_mapView convertCoordinate:location.coordinate toPointToView:self];
//        
//        if (totalPoints == 0)
//            CGContextMoveToPoint(ctxt, point.x, point.y);
//        else
//            CGContextAddLineToPoint(ctxt, point.x, point.y);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
