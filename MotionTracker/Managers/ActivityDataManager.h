//
//  ActivityDataManager.h
//  MotionTracker
//
//  Created by Maxim Makhun on 9/16/16.
//  Copyright © 2016 Maxim Makhun. All rights reserved.
//

@import Foundation;

@interface ActivityDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
