//
//  MyViewController.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/25.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "MyViewController.h"
#import "FindModel.h"
#import "DataBase.h"
#import "tool.h"
#import "RequestUrl.h"
#import "FindTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "FindDetailViewController.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *arrAllData;
@property(nonatomic,strong)UITableView *tableV;
@property(nonatomic,strong)NSMutableArray *arrnew;
@end

@implementation MyViewController
-(void)viewWillAppear:(BOOL)animated{
    NSString*filepath=file;
    NSString *islogin=[NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    if ([islogin isEqualToString:@"登录"]) {
      [self setData];
    [self.tableV reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setData];
    NSString*filepath=file;
    NSString *islogin=[NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    if ([islogin isEqualToString:@"登录"]) {
        [self setViews];
        self.tableV.delegate=self;
        self.tableV.dataSource=self;
        
    }else{
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [self  presentViewController:alert animated:YES completion:^{
            
            sleep(1);
            alert.modalTransitionStyle=NO;
            [alert dismissViewControllerAnimated:YES completion:^{
               
            }];
            
            
        }];
        
    }

   
//      self.arrAllData = [NSMutableArray array];
//    self.arrnew=[NSMutableArray array];
}
-(void)setViews{
    self.tableV=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight-150) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableV];
     [self.tableV registerNib:[UINib nibWithNibName:@"FindTableViewCell" bundle:nil] forCellReuseIdentifier:@"myVCCell_id"];


}
-(void)setData{
      [self.arrnew removeAllObjects];
    [[DataBase startDB] openDB];
    NSString *username= [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
 self.arrAllData =[[DataBase startDB] selectFindActive:username];
    [[DataBase startDB] closeDB];
//    for (FindModel *model1 in arr) {
//    NSDictionary * findDetailDic = @{@"activityId":[NSString stringWithFormat:@"%ld",model1.activityId]};
//  
//    
//    __weak typeof(self) weakself=self;
//    [RequestUrl requestWith:GET URL:URLFINDDETAIL condition:findDetailDic SuccessBlock:^(id item) {
//      
//        if (item) {
//            
//            NSDictionary * dic = item[@"data"];
//           FindModel *model  = [[FindModel alloc]init];
//            [model setValuesForKeysWithDictionary:dic];
//            [weakself.arrAllData addObject:model];
//            
//            
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableV reloadData];
//        });
//    } failBlock:^(NSError *err) {
//        
//    }];
//
//
//    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.arrAllData.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myVCCell_id" forIndexPath:indexPath];
    
    FindModel * model = self.arrAllData[indexPath.row];
    [cell setmodel:model indexpath:indexPath];

    return cell;





}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FindDetailViewController *findDetailVC=[[FindDetailViewController alloc] init];
    FindModel * model = self.arrAllData[indexPath.row];
    findDetailVC.activityId=model.activityId;
    findDetailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:findDetailVC animated:YES];
    
    
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return YES;
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//-(void)deleteBarButtonItemaction:(UIButton *)sender{
//    ifEditing=!ifEditing;
//
//    
//    [self.tableV setEditing:ifEditing animated:YES];
//   
//    
//    
//    
//    
//}

@end
