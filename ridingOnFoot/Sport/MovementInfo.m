//
//  MovementInfo.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/17.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "MovementInfo.h"

@implementation MovementInfo
-(id)mutableCopy
{
    MovementInfo *movementInfo = [[MovementInfo alloc]init];
    
    movementInfo.totleDistance = _totleDistance;
    movementInfo.coorRecord = _coorRecord;
    movementInfo.currentSpeed = _currentSpeed;
    movementInfo.timeDate = _timeDate;
    movementInfo.height = _height;
    
    return movementInfo;
}
//反编码
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _timeDate = [aDecoder decodeObjectForKey:@"timeDate"];
        
        _currentSpeed = [aDecoder decodeFloatForKey:@"currentSpeed"];
        _coorRecord.latitude = [aDecoder decodeDoubleForKey:@"coorRecord.latitude"];
        _coorRecord.longitude = [aDecoder decodeDoubleForKey:@"coorRecord.longitude"];
        //_coorRecord = [aDecoder decodeObjectForKey:@"coorRecord"];
        _totleDistance = [aDecoder decodeFloatForKey:@"totleDistance"];
        _height = [aDecoder decodeFloatForKey:@"height"];
    }
    
    return self;
}
//编码
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_timeDate forKey:@"timeDate"];
    [aCoder encodeFloat:_currentSpeed forKey:@"currentSpeed"];
    [aCoder encodeFloat:_totleDistance forKey:@"totleDistance"];
    [aCoder encodeFloat:_height forKey:@"height"];
    [aCoder encodeDouble:_coorRecord.longitude forKey:@"coorRecord.longitude"];
    [aCoder encodeDouble:_coorRecord.latitude forKey:@"coorRecord.latitude"];
    
}


@end
