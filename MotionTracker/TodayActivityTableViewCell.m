//
//  TodayActivityTableViewCell.m
//  MotionTracker
//
//  Created by Maxim Makhun on 8/3/15.
//  Copyright (c) 2015 MMA. All rights reserved.
//

#import "TodayActivityTableViewCell.h"
#import "MainApp.h"

@implementation TodayActivityTableViewCell

- (void)awakeFromNib
{
    self.activityProgressView.fillOnTouch = NO;
    self.activityProgressView.lineWidth = 6.0f;
    self.activityProgressView.borderWidth = 3.0f;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.activityProgressView.frame.origin.x,
                                                                self.activityProgressView.frame.origin.y,
                                                                self.activityProgressView.frame.size.width,
                                                                self.activityProgressView.frame.size.height)];
    
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.activityProgressView.centralView = self.titleLabel;
}

- (void)updateDailyProgressWithStepsCount:(NSNumber *)stepsCount
{
    NSUInteger maxStepsCount = [MainApp getDailyGoalStepsCounter];
    
    UIColor *currentColor;
    if (stepsCount.integerValue >= maxStepsCount)
    {
        currentColor = [UIColor greenColor];
    }
    else if (stepsCount.integerValue < maxStepsCount)
    {
        if (stepsCount.integerValue < maxStepsCount / 4)
        {
            currentColor = [UIColor redColor];
        }
        else
        {
            currentColor = [UIColor orangeColor];
        }
    }
    
    self.activityProgressView.tintColor = currentColor;
    self.titleLabel.textColor = self.activityProgressView.tintColor;
}

@end
