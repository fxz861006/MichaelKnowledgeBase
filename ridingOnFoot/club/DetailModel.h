//
//  DetailModel.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property(nonatomic,strong) NSString * teamTitle;
@property(nonatomic,strong) NSString * teamAvatar;
@property(nonatomic,assign) NSInteger teamTotalMiles;
@property(nonatomic,assign) NSInteger teamMonthMiles;
@property(nonatomic,strong) NSString * username;
@property(nonatomic,strong) NSString * avatar;
@property(nonatomic,strong) NSString * teamDesc;
@property(nonatomic,assign) NSInteger teamId;
@property(nonatomic,strong) NSString * city;


@end
