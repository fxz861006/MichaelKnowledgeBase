//
//  NaBasicViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "NaBasicViewController.h"
#import "tool.h"
@interface NaBasicViewController ()

@end

@implementation NaBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navV=[[UIView alloc] initWithFrame:CGRectMake(0, 0,kscreenWidth,64)];
    self.navV.backgroundColor =[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    [self.view addSubview:self.navV];
   self.backbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backbtn.frame=CGRectMake(10, 22, 40, 40);
    self.backbtn.tintColor=[UIColor whiteColor];
    [self.backbtn setImage:[UIImage imageNamed:@"icon_nav_back@2x.png"] forState:(UIControlStateNormal)];
    [self.backbtn addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navV addSubview:self.backbtn];
    self.navtitle=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-80, 22, 160, 40)];
    self.navtitle.text=@"分享";
    self.navtitle.textAlignment=NSTextAlignmentCenter;
    self.navtitle.textColor=[UIColor whiteColor];
    [self.navV addSubview:self.navtitle];
}
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
