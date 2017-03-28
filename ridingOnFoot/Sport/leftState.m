//
//  leftState.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/13.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "leftState.h"
static leftState *leftstate=nil;
@implementation leftState

+(instancetype)shareleftstate{
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
leftstate =[[leftState alloc] init];
});
return leftstate;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{\
@synchronized(self) {
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
leftstate=[super allocWithZone:zone];
});
return leftstate;
}
}





@end
