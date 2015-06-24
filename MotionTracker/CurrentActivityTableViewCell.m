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
    self.stepsCount = [stepsCount integerValue];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    NSUInteger maxStepsCount = 30000;
    NSInteger progressViewWidth = self.stepsCount * self.frame.size.width / maxStepsCount;
    self.progressView.frame = CGRectMake(0,
                                         0,
                                         progressViewWidth,
                                         self.frame.size.height);
    
    self.progressView.backgroundColor = [UIColor greenColor];
}

@end
