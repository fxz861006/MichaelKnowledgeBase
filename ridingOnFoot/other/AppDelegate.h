//
//  AppDelegate.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/10.
//  Copyright © 2016年 刘京涛. All rights reserved.
//
//百度地图Ak   TfdSoky1l0ynztsaf5fgHS8w
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "leftState.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

