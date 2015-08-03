//
//  CurrentActivityTableViewCell.m
//  MotionTracker
//
//  Created by Maxim Makhun on 6/24/15.
//  Copyright (c) 2015 MMA. All rights reserved.
//

#import "CurrentActivityTableViewCell.h"
#import "MainApp.h"

@implementation CurrentActivityTableViewCell

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)updateDailyProgressWithStepsCount:(NSNumber *)stepsCount
{
    NSUInteger maxStepsCount = [MainApp getDailyGoalStepsCounter];
    NSInteger progressViewWidth = stepsCount.integerValue * self.frame.size.width / maxStepsCount;
    
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
    
    self.progressView.backgroundColor = currentColor;
    self.progressViewRightConstraint.constant = self.frame.size.width - progressViewWidth;
    
    [self.progressView setNeedsUpdateConstraints];
    [self.progressView layoutIfNeeded];
}

@end
