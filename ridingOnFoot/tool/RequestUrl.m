//
//  RequestUrl.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/15.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "RequestUrl.h"

@implementation RequestUrl

+(void)requestWith:(requestUrlType)Type URL:(NSString *)URL condition:(NSDictionary *)condition SuccessBlock:(successBlock)successBlock failBlock:(faileBlock)failBlock{
    
    
    if (Type == GET) {
        
        RequestUrl * requestUrl = [[RequestUrl alloc]init];
        [requestUrl get:URL condition:condition success:successBlock faile:failBlock];
        
    }
    
}


//GET
-(void)get:(NSString *)url condition:(NSDictionary *)condition  success:(successBlock)success faile:(faileBlock)faile{
    
    NSURLSession * session = [NSURLSession sharedSession];
    __block NSMutableString * urlStr = [NSMutableString stringWithString:url];
    [urlStr appendString:@"?"];
    [condition enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        [urlStr appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
        
    }];
    
    [urlStr substringToIndex:[urlStr length] - 1];
    
    //转码
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:urlStr];
    NSString * urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    //设置Request
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"GET"];
    
    //请求头
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (data && !error) {
        
            id item = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (success) {
                
                success(item);
                return ;
            }else{
                
                return;
            }
        }
        
        if (faile) {
            
            faile(error);
        }
    }];
    
    [task resume];
}

single_implementation(RequestUrl)



@end
