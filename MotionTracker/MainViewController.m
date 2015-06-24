//
//  MainViewController.m
//  MotionTracker
//
//  Created by maxim.makhun on 12/28/13.
//  Copyright (c) 2013 MMA. All rights reserved.
//

#import "MainViewController.h"
#import "DayActivityItem.h"
#import "CurrentActivityTableViewCell.h"

static int daysCounter = 8;

@interface MainViewController ()

@property (strong, nonatomic) NSMutableArray *activityHistoryArray;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.activityHistoryArray = [[NSMutableArray alloc] init];
    
    if ([CMPedometer isStepCountingAvailable])
    {
        self.pedometer = [[CMPedometer alloc] init];
        
        NSDate *currentDate = [NSDate date];
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:currentDate];
        [dateComponents setHour:0];
        [dateComponents setDay:dateComponents.day - daysCounter];
        currentDate = [gregorianCalendar dateFromComponents:dateComponents];
        
        for (int i = daysCounter; i >= 0; --i)
        {
            [dateComponents setDay:dateComponents.day + 1];
            NSDate *nextDate = [gregorianCalendar dateFromComponents:dateComponents];

            // NSLog(@"Date: %@", nextDate);

            [self.pedometer queryPedometerDataFromDate:currentDate toDate:nextDate withHandler:^(CMPedometerData *pedometerData, NSError *error)
            {
                DayActivityItem *item = [[DayActivityItem alloc] init];
                item.numberOfSteps = pedometerData.numberOfSteps;
                item.distance = pedometerData.distance;
                item.floorsAscended = pedometerData.floorsAscended;
                item.floorsDescended = pedometerData.floorsDescended;
                
                [self.activityHistoryArray addObject:item];
                
                NSLog(@"Steps count = %@, Distance = %@, Floors asc. = %@, Floors desc. = %@", pedometerData.numberOfSteps, pedometerData.distance, pedometerData.floorsAscended, pedometerData.floorsDescended);
                
                if (i == 0)
                {
                    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
                }
            }];
            
            currentDate = nextDate;
        }
    }
    else
    {
        NSLog(@"Data not available");
    }
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activityHistoryArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row == 0)
    {
        return self.tableView.frame.size.height - 64;
    }
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = self.activityHistoryArray.count - indexPath.row - 1;
    
    DayActivityItem *item = (DayActivityItem *)[self.activityHistoryArray objectAtIndex:row];
    
    NSString *cellIdentifier = @"CurrentActivityTableViewCell";
    
    CurrentActivityTableViewCell *cell = (CurrentActivityTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.numberOfStepsLabel.text = [NSString stringWithFormat:@"%@", item.numberOfSteps];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
