//
//  ActivityViewController.m
//  MotionTracker
//
//  Created by Maxim Makhun on 9/16/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

@import CoreMotion;
@import CoreData;

#import "ActivityViewController.h"
#import "Activity.h"
#import "ActivityTableViewCell.h"
#import "ActivityDataManager.h"

@interface ActivityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *activityTableView;
@property (nonatomic, strong) CMMotionActivityManager *motionActivitiyManager;
@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) CMMotionActivity *motionActivity;
@property (nonatomic, strong) NSMutableArray<Activity *> *activityArray;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupActivityTableView];
    
    if ([CMPedometer isStepCountingAvailable]) {
        self.pedometer = [CMPedometer new];
        [self loadAndSubmitHistoryToDatabaseWithDaysCount:7 andDate:[NSDate date]];
    } else {
        NSLog(@"CMPedometer data is not available.");
    }
}

- (void)setupActivityTableView {
    UINib *activityNib = [UINib nibWithNibName:NSStringFromClass([ActivityTableViewCell class]) bundle:nil];
    [self.activityTableView registerNib:activityNib forCellReuseIdentifier:NSStringFromClass([ActivityTableViewCell class])];
    
    self.activityTableView.delegate = self;
    self.activityTableView.dataSource = self;
    
    self.activityArray = [NSMutableArray new];
}

- (void)loadAndSubmitHistoryToDatabaseWithDaysCount:(long)daysCounter andDate:(NSDate *)date {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [dateComponents setDay:dateComponents.day - daysCounter];
    date = [gregorianCalendar dateFromComponents:dateComponents];
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    for (long i = 0; i < daysCounter; ++i) {
        [dateComponents setDay:dateComponents.day + 1];
        NSDate *nextDate = [gregorianCalendar dateFromComponents:dateComponents];
        
        [self.pedometer queryPedometerDataFromDate:date
                                            toDate:nextDate
                                       withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                                           Activity *activity = [Activity new];
                                           activity.distance = pedometerData.distance;
                                           activity.numberOfSteps = pedometerData.numberOfSteps;
                                           activity.endDate = pedometerData.endDate;
                                           
                                           NSLog(@"%@ - %@", pedometerData.numberOfSteps, pedometerData.endDate);
                                           
                                           [self.activityArray addObject:activity];
                                           
                                           dispatch_semaphore_signal(sem);
                                       }];
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
        date = nextDate;
    }
    
    [self.activityTableView reloadData];
}

#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    Activity *activity = self.activityArray[row];
    
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityTableViewCell class])];
    
    cell.numberOfStepsLabel.text = [NSString stringWithFormat:@"%@", activity.numberOfSteps];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDate *date = activity.endDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    cell.dateLabel.text = [formatter stringFromDate:date];
    
    [cell updateDailyProgressWithStepsCount:activity.numberOfSteps];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

@end
