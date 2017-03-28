//
//  MJRefreshTableV.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MJRefresh.h>
@interface MJRefreshTableV : NSObject
@property(nonatomic,strong)UITableView *tableV;
-(void)downTableV:(UITableView *)tableV;
-(void)upTableV:(UITableView *)tableV;
@end
