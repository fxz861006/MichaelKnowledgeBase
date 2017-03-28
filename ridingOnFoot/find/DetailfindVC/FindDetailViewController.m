//
//  FindDetailViewController.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/26.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "FindDetailViewController.h"
#import "tool.h"
#import "RequestUrl.h"
#import <UIImageView+WebCache.h>
#import "FindDetailTableViewCell.h"
#import "FindModel.h"
#import "CellViewTableViewCell.h"
#import "DataBase.h"
#import "loginViewController.h"
@interface FindDetailViewController ()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong) UITableView * findDetailTableView;
@property(nonatomic,strong) NSMutableArray * arrAllData;
@property(nonatomic,strong) NSArray * picArr;
@property(nonatomic,strong) NSArray * nameArray;
@property(nonatomic,strong) UIButton *shoucangbtn;
@property(nonatomic,strong)  UIButton *quxbtn;
@property(nonatomic,strong)  UIView *footview;
@property(nonatomic,strong) NSString * contextStr;
@property(nonatomic,strong) NSMutableDictionary * activityUsersDic;
@property(nonatomic,assign) BOOL shoucangBOOL;
@property(nonatomic,strong) FindModel *model;
//头视图
@property(nonatomic,strong) UIScrollView * headerScroll;
@property(nonatomic,strong) UIImageView * headerImageView;
@property(nonatomic,strong) NSArray * picArray;

@end

const static NSInteger scrollHigh = 200;

@implementation FindDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [self setData];
    [self.findDetailTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setData];
    [self setView];
//    [self setHeader];
    [self setDelegate];
}


-(void)setView{
    self.navtitle.text=@"详情";
    self.shoucangBOOL=NO;
    self.findDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kscreenWidth, kscreenHeight-64) style:(UITableViewStyleGrouped)];
    //tableView的cell的线
//    self.findDetailTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.findDetailTableView];
    [self.findDetailTableView registerNib:[UINib nibWithNibName:@"FindDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindDetailTableViewCell"];
//    //收藏按钮
//    UIButton *collectBtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
//    collectBtn.frame=CGRectMake(kscreenWidth-50, 22, 40, 40);
//    [collectBtn setImage:[UIImage imageNamed:@"xingzhe_determine@2x.png"] forState:(UIControlStateNormal)];
//    [collectBtn setTintColor:[UIColor whiteColor]];
//    [collectBtn addTarget:self action:@selector(collectBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.navV addSubview:collectBtn];
    self.footview=[[UIView alloc] init];
    self.quxbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.quxbtn.frame=CGRectMake(kscreenWidth-70,22, 60, 40);
//    self.quxbtn.backgroundColor=[UIColor redColor];
    [self.quxbtn setTitle:@"取消收藏" forState:(UIControlStateNormal)];
    [self.quxbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.quxbtn.layer.cornerRadius=5;
    self.quxbtn.layer.masksToBounds=YES;
    
    [self.quxbtn addTarget:self action:@selector(quxbtnaction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navV addSubview:self.quxbtn];
    self.shoucangbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.shoucangbtn.frame=CGRectMake(kscreenWidth-70,22, 60, 40);
    [self.shoucangbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.shoucangbtn setTitle:@"收藏" forState:(UIControlStateNormal)];
    self.shoucangbtn.layer.cornerRadius=5;
    self.shoucangbtn.layer.masksToBounds=YES;
    
    [self.shoucangbtn addTarget:self action:@selector(shoucangbtnaction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navV addSubview:self.shoucangbtn];
    
    
}


-(void)setDelegate{
    
    self.findDetailTableView.delegate = self;
    self.findDetailTableView.dataSource = self;
}

-(void)setData{
    //?activityId=19494
    NSDictionary * findDetailDic = @{@"activityId":[NSString stringWithFormat:@"%ld",self.activityId]};
    self.arrAllData = [NSMutableArray array];
    self.activityUsersDic=[NSMutableDictionary dictionary];
    __weak typeof(self) weakself=self;
    [RequestUrl requestWith:GET URL:URLFINDDETAIL condition:findDetailDic SuccessBlock:^(id item) {
        
        if (item) {
            NSDictionary * dic = item[@"data"];
            weakself.model = [[FindModel alloc]init];
            [weakself.model setValuesForKeysWithDictionary:dic];
            NSMutableArray * arr=[NSMutableArray array];
            arr=dic[@"activityUsers"];
            weakself.activityUsersDic=arr.lastObject;
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[DataBase startDB] openDB];
            NSString *username= [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            NSMutableArray *arr =[[DataBase startDB] selectFindActive:username];
            [[DataBase startDB] closeDB];
            if (arr.count<=0) {
                self.quxbtn.hidden=YES;
                self.shoucangbtn.hidden=NO;
            }else{
            for (FindModel *model1 in arr) {
                if (model1.activityId==self.model.activityId) {
                    
                    self.quxbtn.hidden=NO;
                    self.shoucangbtn.hidden=YES;
                }else{
                    
                    self.quxbtn.hidden=YES;
                    self.shoucangbtn.hidden=NO;
                }
                
            }}
            [self.findDetailTableView reloadData];
            });
        
    } failBlock:^(NSError *err) {
        
    }];
    
}


#pragma mark TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 6;
    }else{
        return 0;
    }
    
       
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 200;
    }else{
        
        return 60;
    }
    
}




-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *labeltype=[[UILabel alloc] initWithFrame:CGRectMake(10, 160, 34, 20)];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(54, 160, kscreenWidth-54, 20)];
    labeltype.layer.cornerRadius=5;
    labeltype.textColor=[UIColor whiteColor];
    labeltype.textAlignment=NSTextAlignmentCenter;
    labeltype.layer.masksToBounds=YES;
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    labeltype.font=[UIFont systemFontOfSize:14];
    label.text=self.model.activityTitle;
    if (self.model.activityType == 0) {
        labeltype.backgroundColor = kColor(26,0 ,255 ,1);
        labeltype.text = @"简单";
    }else if (self.model.activityType == 1){
        labeltype.backgroundColor = kColor(58, 255, 0, 1);
        labeltype.text = @"休闲";
    }else if (self.model.activityType == 2){
        labeltype.backgroundColor = kColor(245, 128, 2, 1);
        labeltype.text = @"困难";
    }else if (self.model.activityType == 3){
        labeltype.backgroundColor = kColor(243, 21, 3, 1);
        labeltype.text = @"疯狂";
    }else if (self.model.activityType == 4){
        labeltype.backgroundColor = [UIColor blackColor];
        labeltype.text = @"地狱";
    }

    
    if (section == 0) {
        
        UIView *headerV=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, 200)];
        
        self.headerScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, scrollHigh)];

        //每一页
        
        self.headerScroll.showsHorizontalScrollIndicator = NO;
        self.headerScroll.pagingEnabled = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        if (self.model.activityCoverPic.length == 0) {
            self.headerScroll.contentSize = CGSizeMake(kscreenWidth,0);
            self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, scrollHigh)];
            self.headerImageView.image = [UIImage imageNamed:@"placesuixing.jpg"];
            [self.headerScroll addSubview:self.headerImageView];
            
        }else{
//            self.headerScroll.contentSize = CGSizeMake(kscreenWidth * 3,0);
            self.picArray = [NSArray array];
            
            if (![self.model.activityCoverPic containsString:@";"]) {
                
                self.headerScroll.contentSize = CGSizeMake(kscreenWidth, 0);
                self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, scrollHigh)];
                [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.activityCoverPic]];
                [self.headerScroll addSubview:self.headerImageView];
            }else{
            
            do {
                
                self.picArray = [self.model.activityCoverPic componentsSeparatedByString:@";"];
                
            } while ([self.picArray.lastObject containsString:@";"]);
                
                self.headerScroll.contentSize = CGSizeMake(kscreenWidth * self.picArray.count, 0);
                for (int i = 0; i< self.picArray.count; i++) {
                    
                    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kscreenWidth * i, 0, kscreenWidth, scrollHigh)];
                    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.picArray[i]]];
                    [self.headerScroll addSubview:self.headerImageView];
                }
            
            }
            
            
        }
        [headerV addSubview:self.headerScroll];
        [headerV addSubview:labeltype];
        [headerV addSubview:label];
        return headerV;
    }
    
    
    if(section==1){

        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, 60)];
        headerView.backgroundColor = [UIColor lightGrayColor];
//        NSDictionary * dic = self.activityUsersArr[2];
        UIImageView * userIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        userIamgeView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"xing.jpg"]];
        userIamgeView.layer.cornerRadius = 20;
        userIamgeView.layer.masksToBounds = YES;
        
    
        [userIamgeView sd_setImageWithURL:[NSURL URLWithString:self.activityUsersDic[@"avatar"]]];
        
        [headerView addSubview:userIamgeView];
        UILabel * userLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userIamgeView.frame) + 10, 20, kscreenWidth - 50, 19)];
        userLabel.text = [NSString stringWithFormat:@"%@",self.activityUsersDic[@"username"]];
        [headerView addSubview:userLabel];
   
        return headerView;

    }
    return nil;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.section == 0) {
        CellViewTableViewCell * cell2 = [tableView dequeueReusableCellWithIdentifier:@"CellViewTableViewCell"];
            if (cell2==nil) {
                cell2=[[CellViewTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CellViewTableViewCell"];
            }
        cell2.cellImageView.image = [UIImage imageNamed:@"club_distance@2x.png"];
        cell2.cellLabel.text = [NSString stringWithFormat:@"%ldkm",self.model.activityMiles/1000];
        cell2.SecondImageView.image = [UIImage imageNamed:@"club_people_icon_blue@2x.png"];
        cell2.secondLabel.text = [NSString stringWithFormat:@"%ld/%ld人",self.model.activityUsersCount,self.model.activityUserMaxCount];
        return cell2;
    }
    
    if (indexPath.section==1){
        FindDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FindDetailTableViewCell" forIndexPath:indexPath];
        cell.picImageView.image = [UIImage imageNamed:self.picArr[indexPath.row]];
        cell.labelOrder.text = self.nameArray[indexPath.row];
        NSInteger str = indexPath.row;
        
        if (str == 0) {
            cell.labelContent.hidden = YES;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, kscreenWidth - 20, [FindDetailTableViewCell cellHightWithString:self.model.activityContent])];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            label.text = self.model.activityContent;
        }else if (str == 1){
            
            
            
            
            
        }else if (str == 2){
            cell.labelContent.text = self.model.activityAddress;
        }else if (str == 3){
            if (self.model.activityCost < 0) {
                cell.labelContent.text = [NSString stringWithFormat:@"----"];
            }else{
                   cell.labelContent.text = [NSString stringWithFormat:@"%ld元/人",self.model.activityCost];
            }
        }else if (str == 4){
            cell.labelContent.text = self.model.activityContactMobile;
        }else if (str == 5){
            cell.labelContent.text = [NSString stringWithFormat:@"%ld",self.model.activityId];
        }
        
        return cell;

    }
   
    return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 50;
    }else{
    
    if (indexPath.row == 0) {
        return [FindDetailTableViewCell cellHightWithString:self.model.activityContent] + 35;
    }else{
        return 35;
    }
   
    }

}

-(UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

//    NSString*filepath=file;
//    NSString * islogin=[NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];

    
//   
        if (section==1) {
//
//            if (self.shoucangBOOL==YES && [islogin isEqualToString:@"登录"]) {
//                self.quxbtn.hidden=NO;
//                self.shoucangbtn.hidden=YES;
//            }else{
//                self.quxbtn.hidden=YES;
//                self.shoucangbtn.hidden=NO;
//            
//            }
            return self.footview;
//
        }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        
            return 50;
      
        
    }

    return 0.000000001;
}
-(void)quxbtnaction{
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"已取消收藏" preferredStyle:(UIAlertControllerStyleAlert)];
    [self presentViewController:alertC animated:YES completion:^{
        sleep(2);
        NSString *username= [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        self.model.username=username;
        [[DataBase startDB] openDB];
        [[DataBase startDB] deleteFindActive:self.model];
        [[DataBase startDB] closeDB];
        
        alertC.modalTransitionStyle=NO;
        [alertC dismissViewControllerAnimated:YES completion:^{
            self.shoucangBOOL=NO;
            self.shoucangbtn.hidden=NO;
            self.quxbtn.hidden=YES;
            [self.findDetailTableView reloadData];
        }];
    }];
    
 
}
-(void)shoucangbtnaction{
    
//    [[DataBase startDB] openDB];
//    NSString *username= [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//    NSMutableArray  *arr =[[DataBase startDB] selectFindActive:username];
//    [[DataBase startDB] closeDB];
//    int i=0;
//    for (FindModel *model1 in arr) {
//        if (model1.activityId==self.model.activityId) {
//            i=1;
//        }
//        
//    }
//    //    if (i==1) {
//    //        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"收藏过" preferredStyle:(UIAlertControllerStyleAlert)];
//    //        [self presentViewController:alertC animated:YES completion:^{
//    //            sleep(2);
//    //
//    //            alertC.modalTransitionStyle=NO;
//    //            [alertC dismissViewControllerAnimated:YES completion:nil];
//    //        }];
//    //    }
//    
//    
    NSString*filepath=file;
    NSString * islogin=[NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    if ([islogin isEqualToString:@"登录"]) {
//        if (i==1) {
//            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"收藏过" preferredStyle:(UIAlertControllerStyleAlert)];
//            [self presentViewController:alertC animated:YES completion:^{
//                sleep(2);
//                
//                alertC.modalTransitionStyle=NO;
//                [alertC dismissViewControllerAnimated:YES completion:nil];
//            }];
//        }if (i==0) {
    
            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"收藏成功" preferredStyle:(UIAlertControllerStyleAlert)];
            [self presentViewController:alertC animated:YES completion:^{
                sleep(2);
                [[DataBase startDB] openDB];
                NSString *username= [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
                self.model.username=username;
                [[DataBase startDB] addFindActive:self.model];
                [[DataBase startDB] closeDB];
               
                alertC.modalTransitionStyle=NO;
                [alertC dismissViewControllerAnimated:YES completion:^{
                    self.shoucangBOOL=YES;
                    self.quxbtn.hidden=NO;
                    self.shoucangbtn.hidden=YES;
                     [self.findDetailTableView reloadData];
                }];
            }];
            
            
        }
//    }
 
    if (![islogin isEqualToString:@"登录"]) {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [self  presentViewController:alert animated:YES completion:^{
            
            sleep(1);
            alert.modalTransitionStyle=NO;
            [alert dismissViewControllerAnimated:YES completion:^{
                loginViewController *loginVC=[[loginViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }];
            
            
        }];
        
    }
    
    
    



}
#pragma mark 懒加载


-(NSArray *)picArr{
    if (!_picArr) {
        
        _picArr = @[@"discriptionicon@2x.png",@"time_table@2x.png",@"club_location@2x.png",@"act_money@2x.png",@"act_phone@2x.png",@"act_id@2x.png"];
    }
    return _picArr;
}

-(NSArray *)nameArray{
    if (!_nameArray) {
        _nameArray = @[@"描述",@"时间",@"集合地",@"费用",@"电话",@"编号"];
    }
    return _nameArray;
}


//-(void)collectBtnAction{
//    
//    [[DataBase startDB] openDB];
//    NSString *username= [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//    NSMutableArray  *arr =[[DataBase startDB] selectFindActive:username];
//    [[DataBase startDB] closeDB];
//    int i=0;
//    for (FindModel *model1 in arr) {
//        if (model1.activityId==self.model.activityId) {
//            i=1;
//        }
//        
//    }
////    if (i==1) {
////        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"收藏过" preferredStyle:(UIAlertControllerStyleAlert)];
////        [self presentViewController:alertC animated:YES completion:^{
////            sleep(2);
////            
////            alertC.modalTransitionStyle=NO;
////            [alertC dismissViewControllerAnimated:YES completion:nil];
////        }];
////    }
//   
//   
//        NSString*filepath=file;
//      NSString * islogin=[NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
//    if ([islogin isEqualToString:@"登录"]) {
//        if (i==1) {
//            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"收藏过" preferredStyle:(UIAlertControllerStyleAlert)];
//            [self presentViewController:alertC animated:YES completion:^{
//                sleep(2);
//                
//                alertC.modalTransitionStyle=NO;
//                [alertC dismissViewControllerAnimated:YES completion:nil];
//            }];
//        }if (i==0) {
//   
//        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"收藏成功" preferredStyle:(UIAlertControllerStyleAlert)];
//        [self presentViewController:alertC animated:YES completion:^{
//            sleep(2);
//            [[DataBase startDB] openDB];
//            NSString *username= [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//            self.model.username=username;
//             [[DataBase startDB] addFindActive:self.model];
//            [[DataBase startDB] closeDB];
//            alertC.modalTransitionStyle=NO;
//            [alertC dismissViewControllerAnimated:YES completion:nil];
//        }];
//        
//        
//    }
//    }
//        
//        if (![islogin isEqualToString:@"登录"]) {
//       
//        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
//        [self  presentViewController:alert animated:YES completion:^{
//            
//            sleep(1);
//            alert.modalTransitionStyle=NO;
//            [alert dismissViewControllerAnimated:YES completion:^{
//                loginViewController *loginVC=[[loginViewController alloc] init];
//                [self.navigationController pushViewController:loginVC animated:YES];
//            }];
//            
//            
//        }];
//        
//    }
//    
//    
//
//   
//}





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
