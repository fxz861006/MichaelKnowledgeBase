//
//  RequestUrl.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/15.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tool.h"

typedef NS_ENUM(NSInteger,requestUrlType){
    
    GET
};

typedef void(^successBlock)(id item);
typedef void(^faileBlock)(NSError * err);


@interface RequestUrl : NSObject

single_interface(RequestUrl)

+(void)requestWith:(requestUrlType)Type URL:(NSString *)URL condition:(NSDictionary *)condition SuccessBlock:(successBlock)successBlock failBlock:(faileBlock)failBlock;

@end
