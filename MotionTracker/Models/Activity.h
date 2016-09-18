//
//  Activity.h
//  MotionTracker
//
//  Created by Maxim Makhun on 9/16/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface Activity : NSObject

@property(strong, nonatomic) NSNumber *distance;
@property(strong, nonatomic) NSDate *endDate;
@property(strong, nonatomic) NSNumber *numberOfSteps;

@end
