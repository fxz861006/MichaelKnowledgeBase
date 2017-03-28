//
//  shareRecommendViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "shareRecommendViewController.h"
#import "shareViewController.h"
#import "recommendedViewController.h"
#import "tool.h"
@interface shareRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableV;
@end

@implementation shareRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navtitle.text=@"分享";
    self.tableV =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kscreenWidth, kscreenHeight-64) style:(UITableViewStylePlain)];
    self.tableV.delegate=self;
    self.tableV.dataSource=self;
    [self.view addSubview:self.tableV];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return kscreenHeight/50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"sharecell_id"];

    if (indexPath.row==0) {
        cell.textLabel.text=@"推荐给好友";
    }
    if (indexPath.row==1) {
        
   cell.textLabel.text=@"位置分享";
    }


    return cell;


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        recommendedViewController *recommendVC=[[recommendedViewController alloc] init];

        [self.navigationController pushViewController:recommendVC animated:YES];
    }
    if (indexPath.row==1) {
        shareViewController *shareVC=[[shareViewController alloc] init];

        [self.navigationController pushViewController:shareVC animated:YES];
        
        
    }


}

-(void)backAction{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

@end
