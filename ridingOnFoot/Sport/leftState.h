//
//  leftState.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/13.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    biking,
    running,
    walking
} state;
@interface leftState : NSObject
@property(nonatomic,assign)state leftstate;
+(instancetype)shareleftstate;
@end
