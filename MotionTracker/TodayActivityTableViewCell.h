//
//  TodayActivityTableViewCell.h
//  MotionTracker
//
//  Created by Maxim Makhun on 8/3/15.
//  Copyright (c) 2015 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UAProgressView.h>

@interface TodayActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UAProgressView *activityProgressView;
@property (nonatomic) UILabel *titleLabel;

- (void)updateDailyProgressWithStepsCount:(NSNumber *)stepsCount;

@end
