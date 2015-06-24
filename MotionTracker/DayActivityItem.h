//
//  DayActivityItem.h
//  MotionTracker
//
//  Created by Maxim Makhun on 6/24/15.
//  Copyright (c) 2015 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayActivityItem : NSObject

@property(nonatomic, strong) NSNumber *numberOfSteps;
@property(nonatomic, strong) NSNumber *distance;
@property(nonatomic, strong) NSNumber *floorsAscended;
@property(nonatomic, strong) NSNumber *floorsDescended;

@end
