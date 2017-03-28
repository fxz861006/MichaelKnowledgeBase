//
//  MJRefreshTableV.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "MJRefreshTableV.h"
static const CGFloat MJDuration = 1.0;
@implementation MJRefreshTableV
-(void)downTableV:(UITableView *)tableV{
  self.tableV=tableV;
    
        __weak __typeof(self) weakSelf = self;
        tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        
        //设置回调(一旦进入刷新状态,也就是调用self的loadNewData方法)
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        //设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        //隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        
        //设置文字
        [header setTitle:@"加载完成" forState:MJRefreshStateIdle];
        [header setTitle:@"请稍后...." forState:MJRefreshStatePulling];
        [header setTitle:@"加载中...." forState:MJRefreshStateRefreshing];
        
        //设置字体
        header.stateLabel.font = [UIFont systemFontOfSize:15];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:15];
        
        //设置颜色
        header.stateLabel.textColor = [UIColor blueColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor redColor];
        
        
        //设置header
        tableV.mj_header = header;
        //马上进入刷新状态
        [tableV.mj_header beginRefreshing];
        



}
-(void)loadNewData{
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableV.mj_header endRefreshing];
     });
    
}

-(void)upTableV:(UITableView *)tableV{
    self.tableV=tableV;
    
        [self downTableV:tableV];
        __weak __typeof(self) weakSelf = self;
        
        //设置回调(一旦进入刷新状态,就调用target的action,也就是调用self的loadingMoreData方法)
        self.tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
        
        
        //设置回调()
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        //禁止自动加载
        footer.automaticallyRefresh = NO;
        
        //当上拉刷新控件出现50%时(出现一半),就会自动刷新.这个值默认是1.0(也就是上拉刷新100%出现时,才会自动刷新)
        footer.triggerAutomaticallyRefreshPercent = 0.5;
        
        //设置文字
        [footer setTitle:@"加载数据" forState:MJRefreshStateIdle];
        [footer setTitle:@"加载中...." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"已加载全部数据" forState:MJRefreshStateNoMoreData];
        //设置字体
        footer.stateLabel.font = [UIFont systemFontOfSize:17];
        //设置颜色
        footer.stateLabel.textColor = [UIColor blueColor];
        
        //设置footer
        self.tableV.mj_footer = footer;
        self.tableV.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableV.mj_footer endRefreshing];
        });



}

-(void)loadMoreData{
        // 拿到当前的上拉刷新控件，结束刷新状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableV.mj_header endRefreshing];
    });
    
    
}


@end
