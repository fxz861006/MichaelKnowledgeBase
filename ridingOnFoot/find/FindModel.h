//
//  FindModel.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/25.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindModel : NSObject
@property(nonatomic,strong) NSString *username;
@property(nonatomic,assign) NSInteger activityType;
@property(nonatomic,strong) NSString * activityTitle;
@property(nonatomic,strong) NSString * activityAddress;
@property(nonatomic,assign) NSInteger activityStartTime;
@property(nonatomic,assign) NSInteger activityEndTime;
@property(nonatomic,assign) NSInteger activityUsersCount;
@property(nonatomic,assign) NSInteger activityUserMaxCount;
@property(nonatomic,assign) NSInteger activityMiles;
@property(nonatomic,strong) NSString * activityCoverPic;
@property(nonatomic,strong) NSString *activityContent;


@property(nonatomic,assign) NSInteger activityId;
@property(nonatomic,assign) NSInteger activityCost;
@property(nonatomic,strong) NSString * activityContactMobile;



@end
