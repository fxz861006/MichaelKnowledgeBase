//
//  userLocationSingleton.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/19.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKUserLocation.h>
#import "contactmodel.h"
@interface userLocationSingleton : NSObject
//single_interface(userLocationSingleton);
+ (instancetype)shareuserLocationSingleton;
@property(nonatomic,assign)BOOL islogin;
@property (nonatomic, strong) BMKUserLocation *userlocation;
@property(nonatomic,strong)contactmodel *model;
@property(nonatomic,assign)BOOL isnetwork;
@end
