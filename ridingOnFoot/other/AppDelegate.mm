//
//  AppDelegate.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/10.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "AppDelegate.h"
#import "mineViewController.h"
#import "sportViewController.h"
#import "findViewController.h"
#import "roadBookViewController.h"
#import "clubViewController.h"
#import "UMSocialQQHandler.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface AppDelegate ()<UITabBarControllerDelegate>
@property(nonatomic,strong)UITabBarController  *tabbarC;
@property(nonatomic,strong)UIImageView *launchImaViewT;
@property(nonatomic,strong)UIImageView *launchImaViewO;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setview];
 
    // 要使用百度地图，请先启动BaiduMapManagerTfdSoky1l0ynztsaf5fgHS8w
   BMKMapManager * mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:@"a7asSIp9z99WMsMhM9qYyM8gZtaIEXn0" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    [UMSocialData setAppKey:@"56de35c8e0f55a75a90029f5"];
    [UMSocialQQHandler setQQWithAppId:@"1105237522" appKey:@"SxkTdjMCVP51LKpu" url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2281875775"
                                              secret:@"95ccecc14a9aa8c4d9a6797f24eeda13"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialWechatHandler setWXAppId:@"wxfe5db3c2392fdda7" appSecret:@"d47e7ebf9f00110deae13b53b918a262" url:@"http://www.umeng.com/social"];

    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
//        //如果授权状态不是在前台使用
//        if ([CLLocationManager  authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse) {
//            //请求前台使用定位
//            CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
//            //获取授权认证
//            //            [locationManager requestAlwaysAuthorization];
//            [locationManager requestWhenInUseAuthorization];
//        }
//    }
//  
    
    
    return YES;
}
-(void)setview{

    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UITabBarController *tabBarc=[[UITabBarController alloc] init];
    tabBarc.tabBar.barTintColor=[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    tabBarc.tabBar.tintColor=[UIColor whiteColor];
    self.window.rootViewController=tabBarc;
    
    sportViewController *sportVC=[[sportViewController alloc] init];
    UINavigationController *sportNVC=[[UINavigationController alloc] initWithRootViewController:sportVC];
    sportVC.tabBarItem.title=@"运动";
    [leftState shareleftstate].leftstate=biking;
    sportVC.tabBarItem.image=[UIImage imageNamed:@"tabbar1_cycling_inactive"];
    sportNVC.navigationBar.hidden=YES;
    sportNVC.navigationBar.barTintColor =[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    mineViewController *mineVC=[[mineViewController alloc] init];
    sportNVC.navigationBar.translucent=NO;
    UINavigationController *mineNVC=[[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNVC.tabBarItem.title=@"我的";
    mineNVC.tabBarItem.image=[UIImage imageNamed:@"tabbar2_inactive@2x.png"];
    findViewController *findVC=[[findViewController alloc] init];
    UINavigationController *findNVC=[[UINavigationController alloc] initWithRootViewController:findVC];
    findNVC.tabBarItem.title=@"发现";
    findNVC.tabBarItem.image=[UIImage imageNamed:@"tabbar3_inactive@2x.png"];
    roadBookViewController *roadBookVC=[[roadBookViewController alloc] init];
    UINavigationController *roadBookNVC=[[UINavigationController alloc] initWithRootViewController:roadBookVC];
    roadBookNVC.tabBarItem.title=@"路书";
    roadBookNVC.navigationBar.hidden=YES;
    roadBookNVC.tabBarItem.image=[UIImage imageNamed:@"tabbar4_inactive@2x.png"];
    roadBookNVC.navigationBar.barTintColor =[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    clubViewController *clubVC=[[clubViewController alloc] init];
    UINavigationController *clubNVC=[[UINavigationController alloc] initWithRootViewController:clubVC];
    clubNVC.tabBarItem.title=@"俱乐部";
    clubNVC.tabBarItem.image=[UIImage imageNamed:@"tabbar5_inactive@2x.png"];
    tabBarc.tabBar.translucent=NO;
    tabBarc.delegate=self;
    tabBarc.viewControllers=@[sportNVC,mineNVC,findNVC,roadBookNVC,clubNVC];
    [self setLauchView];


}
- (void)setLauchView {
    self.window.userInteractionEnabled=NO;
    _launchImaViewT = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _launchImaViewT.contentMode = UIViewContentModeScaleAspectFill;
    [self.window addSubview:_launchImaViewT];
    
    _launchImaViewO = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _launchImaViewO.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"suixing" ofType:@"png"]];
    _launchImaViewO.backgroundColor=[UIColor blackColor];
    [self.window addSubview:_launchImaViewO];
    _launchImaViewT.image=[UIImage imageNamed:@"launchimg2.jpg"];
    [UIView animateWithDuration:2 animations:^{
        _launchImaViewO.backgroundColor=[UIColor clearColor];
       
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            _launchImaViewO.alpha = 0;
            _launchImaViewT.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            //成功后删除两个imv
            
            self.window.userInteractionEnabled=YES;
            [_launchImaViewO removeFromSuperview];
            [_launchImaViewT removeFromSuperview];
            
        }];

    }];

    
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.liujingtao.ridingOnFoot" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ridingOnFoot" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ridingOnFoot.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


@end
