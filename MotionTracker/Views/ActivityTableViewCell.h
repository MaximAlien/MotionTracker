//
//  ActivityTableViewCell.h
//  MotionTracker
//
//  Created by Maxim Makhun on 9/16/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

@import UIKit;

@interface ActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberOfStepsLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewRightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)updateDailyProgressWithStepsCount:(NSNumber *)stepsCount;

@end
