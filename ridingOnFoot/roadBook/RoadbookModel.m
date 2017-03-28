//
//  RoadbookModel.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/19.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "RoadbookModel.h"

@implementation RoadbookModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _modelid=(long)value;
    }
    
}



//归档
-(void)encodeWithCoder:(NSCoder *)aCoder{
 
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeFloat:self.distance forKey:@"distance"];
    [aCoder encodeFloat:self.lat forKey:@"lat"];
    [aCoder encodeFloat:self.end_lat forKey:@"end_lat"];
    [aCoder encodeFloat:self.lng forKey:@"lng"];
    [aCoder encodeFloat:self.end_lng forKey:@"end_lng"];
    [aCoder encodeInteger:self.comment_num forKey:@"comment_num"];
    [aCoder encodeInteger:self.download_time forKey:@"download_time"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.user_pic forKey:@"user_pic"];
    [aCoder encodeInteger:self.modelid forKey:@"modelid"];


}
////反归档
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.user_name=[aDecoder decodeObjectForKey:@"user_name"];
        self.lat=[aDecoder decodeFloatForKey:@"lat"];
        self.end_lat=[aDecoder decodeFloatForKey:@"end_lat"];
        self.distance=[aDecoder decodeFloatForKey:@"distance"];
        self.comment_num=[aDecoder decodeIntegerForKey:@"comment_num"];
        self.download_time=[aDecoder decodeIntegerForKey:@"download_time"];
        self.image=[aDecoder decodeObjectForKey:@"image"];
        self.user_pic=[aDecoder decodeObjectForKey:@"user_pic"];
        self.modelid=[aDecoder decodeIntegerForKey:@"modelid"];
        self.lng=[aDecoder decodeFloatForKey:@"lng"];
        self.end_lng=[aDecoder decodeFloatForKey:@"end_lng"];
    }


    return self;

}

@end
