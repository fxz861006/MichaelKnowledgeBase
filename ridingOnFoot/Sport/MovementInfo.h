//
//  MovementInfo.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/17.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MovementInfo : NSObject<NSCoding>
//记录总的路程
@property(assign,nonatomic)CGFloat totleDistance;
//记录上一个点的定位状态
@property(assign,nonatomic)CLLocationCoordinate2D coorRecord;
//当前速度
@property(assign,nonatomic)CGFloat currentSpeed;
//该点的运动开始时间
@property(strong,nonatomic)NSDate *timeDate;
//海拔
@property(assign,nonatomic)CGFloat height;
@end
