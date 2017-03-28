//
//  ListViewController.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/11.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController


@property(nonatomic,strong) UITableView * listTableView;
@property(nonatomic,strong) NSArray * arr;
@property(nonatomic,strong) UITableViewCell * cell;
@property(nonatomic,assign) NSInteger number;
@end
