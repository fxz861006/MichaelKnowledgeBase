//
//  sportViewController.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/11.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "DataBase.h"
@interface sportViewController : UIViewController<BMKGeoCodeSearchDelegate>
@property(nonatomic,assign)BOOL isStartpoint;
@end
