//
//  CurrentActivityTableViewCell.h
//  MotionTracker
//
//  Created by Maxim Makhun on 6/24/15.
//  Copyright (c) 2015 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberOfStepsLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewRightConstraint;

- (void)updateDailyProgressWithStepsCount:(NSNumber *)stepsCount;

@end
