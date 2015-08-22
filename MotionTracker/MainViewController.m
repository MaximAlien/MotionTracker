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
#import "SWRevealViewController.h"
#import "TodayActivityTableViewCell.h"
#import "MainApp.h"

static int daysCounter = 8;

@interface MainViewController ()

@property (strong, nonatomic) NSMutableArray *activityHistoryArray;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
}

- (void)dealloc
{
    [self stopFollowingScrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self followScrollView:self.tableView usingTopConstraint:self.topConstraint];
    
    self.title = @"MotionTracker";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.leftSidebarButtonItem setTarget: self.revealViewController];
        [self.leftSidebarButtonItem setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
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
                item.date = currentDate;
                
                [self.activityHistoryArray addObject:item];
                
                [self saveDay:item];
                
                // NSLog(@"Steps count = %@, Distance = %@, Floors asc. = %@, Floors desc. = %@", pedometerData.numberOfSteps, pedometerData.distance, pedometerData.floorsAscended, pedometerData.floorsDescended);
                
                if (i == 0)
                {
                    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
                }
            }];
            
            currentDate = nextDate;
        }
        
        NSDate *todayDate = [NSDate date];
        dateComponents = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:todayDate];
        [dateComponents setHour:0];
        todayDate = [gregorianCalendar dateFromComponents:dateComponents];
        
        [self.pedometer startPedometerUpdatesFromDate:todayDate withHandler:^(CMPedometerData *pedometerData, NSError *error)
         {
             DayActivityItem *item = [[DayActivityItem alloc] init];
             item.numberOfSteps = pedometerData.numberOfSteps;
             item.distance = pedometerData.distance;
             item.floorsAscended = pedometerData.floorsAscended;
             item.floorsDescended = pedometerData.floorsDescended;
//             item.date = todayDate;
             
             if (self.activityHistoryArray.count != 0)
             {
                 [self.activityHistoryArray replaceObjectAtIndex:self.activityHistoryArray.count - 1 withObject:item];
             }

             NSLog(@"Steps count = %@, Distance = %@, Floors asc. = %@, Floors desc. = %@", pedometerData.numberOfSteps, pedometerData.distance, pedometerData.floorsAscended, pedometerData.floorsDescended);
             
             
             [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
         }];
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
    
    return (self.tableView.frame.size.height - 64) / 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = self.activityHistoryArray.count - indexPath.row - 1;
    DayActivityItem *item = (DayActivityItem *)[self.activityHistoryArray objectAtIndex:row];
    
    if (indexPath.row == 0)
    {
        NSString *cellIdentifier = @"TodayActivityTableViewCell";
        
        TodayActivityTableViewCell *cell = (TodayActivityTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        CGFloat res =  (item.numberOfSteps.floatValue * 100.0f) / [MainApp getDailyGoalStepsCounter];
        [cell.activityProgressView setProgress:res / 100.f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateDailyProgressWithStepsCount:item.numberOfSteps];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ steps", item.numberOfSteps];
        
        return cell;
    }
    else
    {
        NSString *cellIdentifier = @"CurrentActivityTableViewCell";
        
        CurrentActivityTableViewCell *cell = (CurrentActivityTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.numberOfStepsLabel.text = [NSString stringWithFormat:@"%@", item.numberOfSteps];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row != 0)
        {
            [cell updateDailyProgressWithStepsCount:item.numberOfSteps];
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

// CoreData

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (void)saveDay:(DayActivityItem *)item
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:context];
    [day setValue:item.distance forKey:@"distance"];
    [day setValue:item.numberOfSteps forKey:@"steps"];
    [day setValue:item.date forKey:@"date"];
    
    NSError *error = nil;

    if (![context save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

@end
