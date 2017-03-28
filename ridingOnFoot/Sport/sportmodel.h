//
//  sportmodel.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/22.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sportmodel : NSObject
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *timeDate;
@property(nonatomic,strong)NSString *startpoint;
@property(nonatomic,strong)NSString *stoppoint;
@property(nonatomic,assign)NSInteger distance;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,assign)NSInteger type;

@end
