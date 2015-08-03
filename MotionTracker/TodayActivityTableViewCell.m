//
//  TodayActivityTableViewCell.m
//  MotionTracker
//
//  Created by Maxim Makhun on 8/3/15.
//  Copyright (c) 2015 MMA. All rights reserved.
//

#import "TodayActivityTableViewCell.h"

@implementation TodayActivityTableViewCell

- (void)awakeFromNib
{
    self.activityProgressView.fillOnTouch = NO;
}

@end
