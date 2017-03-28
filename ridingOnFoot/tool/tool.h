//
//  tool.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/11.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#ifndef tool_h
#define tool_h
#define readBookModelFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"readBookModel.plist"];
#define file [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"islogin.txt"];
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
//颜色
#define kColor(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define URLYEAR @"http://www.imxingzhe.com/api/v4/team_rank"
#define URLMONTH @"http://www.imxingzhe.com/api/v4/team_rank"
#define URLNEARBY @"http://www.imxingzhe.com/api/v4/search_teams"
#define URLLUSHU @"http://www.imxingzhe.com/api/v4/lushu_search"
#define URLCLUBDETAIL @"http://www.imxingzhe.com/api/v4/team_detail"
#define URLTEAMMATE @"http://www.imxingzhe.com/api/v4/team_user_rank"
#define URLFIND @"http://www.imxingzhe.com/api/v4/get_near_by_activity"
#define URLFINDDETAIL @"http://www.imxingzhe.com/api/v4/get_activity_detail"
#define URLFINDSEARCH @"http://www.imxingzhe.com/api/v4/search_activity"



#define single_interface(className)\
+(instancetype)share##className;\


#define single_implementation(className)\
static className * _instance = nil;\
+(instancetype)share##className{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[[self class] alloc]init];\
});\
return _instance;\
}\
+(instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\



#endif /* tool_h */
