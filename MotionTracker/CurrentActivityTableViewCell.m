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
    NSUInteger maxStepsCount = 20000;
    NSInteger progressViewWidth = stepsCount.integerValue * self.frame.size.width / maxStepsCount;
    
    self.progressView.backgroundColor = [UIColor greenColor];
    
    self.progressViewRightConstraint.constant = self.frame.size.width - progressViewWidth;
    [self.progressView setNeedsUpdateConstraints];
    [self.progressView layoutIfNeeded];
}

@end
