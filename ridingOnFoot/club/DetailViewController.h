//
//  DetailViewController.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController


@property(nonatomic,assign) NSInteger teamId;
@property(nonatomic,strong)UILabel *navtitle;
@property(nonatomic,strong)UIButton *backbtn;
@property(nonatomic,strong)UIView *navV;

@end
