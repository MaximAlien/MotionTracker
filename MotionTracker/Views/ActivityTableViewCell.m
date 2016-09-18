//
//  ActivityTableViewCell.m
//  MotionTracker
//
//  Created by Maxim Makhun on 9/16/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

#import "ActivityTableViewCell.h"

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateDailyProgressWithStepsCount:(NSNumber *)stepsCount {
    NSUInteger maxStepsCount = 10000;
    NSInteger progressViewWidth = stepsCount.integerValue * self.frame.size.width / maxStepsCount;
    
    UIColor *currentColor;
    if (stepsCount.integerValue >= maxStepsCount) {
        currentColor = [UIColor greenColor];
    } else if (stepsCount.integerValue < maxStepsCount) {
        if (stepsCount.integerValue < maxStepsCount / 4) {
            currentColor = [UIColor redColor];
        } else {
            currentColor = [UIColor orangeColor];
        }
    }
    
    self.progressView.backgroundColor = currentColor;
    self.progressViewRightConstraint.constant = self.frame.size.width - progressViewWidth;
    
    [self.progressView setNeedsUpdateConstraints];
    [self.progressView layoutIfNeeded];
}

@end
