//
//  RoadbookModel.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/19.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoadbookModel : NSObject<NSCoding>

@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * user_name;
@property(nonatomic,assign) float distance;
@property(nonatomic,assign) NSInteger comment_num;
@property(nonatomic,assign) NSInteger download_time;
@property(nonatomic,strong) NSString * image;
@property(nonatomic,strong) NSString * user_pic;
@property(nonatomic,assign) NSInteger modelid;
@property(nonatomic,assign) float lng;
@property(nonatomic,assign) float end_lng;
@property(nonatomic,assign) float  lat;
@property(nonatomic,assign) float end_lat;


//收藏
@property(nonatomic,assign) BOOL is_collect;

@end
