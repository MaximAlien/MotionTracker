//
//  MainViewController.h
//  MotionTracker
//
//  Created by maxim.makhun on 12/28/13.
//  Copyright (c) 2013 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreData/CoreData.h>

#import "UIViewController+ScrollingNavbar.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{

}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftSidebarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CMMotionActivityManager *motionActivitiyManager;
@property (strong, nonatomic) CMPedometer *pedometer;
@property (strong, nonatomic) CMMotionActivity *motionActivity;

@end
