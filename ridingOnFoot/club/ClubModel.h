//
//  ClubModel.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/15.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClubModel : NSObject

//队名
@property(nonatomic,strong) NSString * teamTitle;
//骑行千米数
@property(nonatomic,assign) NSInteger teamMiles;
//人数
@property(nonatomic,assign) NSInteger teamUserCounts;
//城市
@property(nonatomic,strong) NSString * teamCityName;
//头像
@property(nonatomic,strong) NSString * teamAvatar;
//排名
@property(nonatomic,assign) NSInteger teamId;



@end
