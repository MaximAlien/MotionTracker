//
//  MotionTracker_Tests.m
//  MotionTracker Tests
//
//  Created by Maxim Makhun on 8/30/15.
//  Copyright (c) 2015 MMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface MotionTracker_Tests : XCTestCase

@end

@implementation MotionTracker_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
