//
//  singleton.h
//  LO_MUSIC
//
//  Created by 杨少锋 on 16/2/29.
//  Copyright © 2016年 杨少锋. All rights reserved.
//

#ifndef singleton_h
#define singleton_h

#define single_interface(className)\
+ (instancetype)share##className;

#define single_implementation(className)\
static className *_instance = nil;\
+ (instancetype)share##className {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[[self class] alloc] init];\
    });\
    return _instance;\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\

#endif /* singleton_h */
