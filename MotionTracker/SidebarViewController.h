//
//  SidebarViewController.h
//  MotionTracker
//
//  Created by Maxim Makhun on 6/29/15.
//  Copyright (c) 2015 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSegmentedControl.h"

@interface SidebarViewController : UIViewController

@property (weak, nonatomic) IBOutlet NYSegmentedControl *metricsSegmentedControl;

@end
