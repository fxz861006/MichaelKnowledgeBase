//
//  userLocationSingleton.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/19.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "userLocationSingleton.h"
static userLocationSingleton *_instance = nil;
@implementation userLocationSingleton

+ (instancetype)shareuserLocationSingleton {
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
_instance = [[[self class] alloc] init];
});
return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
_instance = [super allocWithZone:zone];
});
return _instance;
}


@end
