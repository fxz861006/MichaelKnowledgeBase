//
//  RankViewController.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/11.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "RankViewController.h"
#import "tool.h"
#import "ListViewController.h"
#import "RequestUrl.h"
#import "ClubModel.h"
#import "ClubTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <MJRefresh.h>
#import "DetailViewController.h"






static const CGFloat MJDuration = 1.0;
static NSInteger monthStr = 0;
static NSInteger yearStr = 0;


@interface RankViewController ()<UITableViewDataSource,UITableViewDelegate>



//标题视图
//@property(nonatomic,strong) UIView * titleView;
//标题文字
@property(nonatomic,strong) UILabel * titleLabel;
//标题图标
@property(nonatomic,strong) UIImageView * titleImage;

//选择
@property(nonatomic,strong) ListViewController * listVC;
//数据
@property(nonatomic,strong) NSMutableArray * monthArrAllData;
@property(nonatomic,strong) NSMutableArray * yearArrAllData;
//列表
@property(nonatomic,strong) UITableView * rankListTableView;

@property(nonatomic,strong) NSMutableDictionary * monthDic;
@property(nonatomic,strong) NSMutableDictionary * yearDic;



@end

@implementation RankViewController
-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor cyanColor];
    [self setView];
    
     self.monthArrAllData = [NSMutableArray array];
     self.yearArrAllData = [NSMutableArray array];
    
    self.monthDic = [NSMutableDictionary dictionaryWithDictionary:@{@"limit":@"20",@"page":@0,@"timeType":@"1"}];
    self.yearDic = [NSMutableDictionary dictionaryWithDictionary:@{@"limit":@"20",@"page":@0,@"timeType":@"0"}];
    
    [self setDataWithUrl:URLMONTH Dictionary:self.monthDic];
    [self setDelegate];
    [self setGesture];

    [self example01];
    
    [self example11];

   
   
}



//左边返回键的方法
-(void)backAction{
    self.titleView.hidden=YES;
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)setView{
    
    //左边返回键
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_nav_back@2x.png"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backAction)];
    //标题处
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(40, 0, kscreenWidth-80, 44)];
    self.titleView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth-80, 44)];
    self.titleLabel.text = @"俱乐部月度榜";
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.textColor=[UIColor whiteColor];
    [self.titleView addSubview:self.titleLabel];
    self.titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(kscreenWidth/2 + 12,15, 20, 20)];
    self.titleImage.image = [UIImage imageNamed:@"down.png"];
    [self.titleView addSubview:self.titleImage];
    [self.navigationController.navigationBar addSubview:self.titleView];
    //列表
    self.rankListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight - 108) style:(UITableViewStylePlain)];
    [self.view addSubview:self.rankListTableView];
    self.rankListTableView.rowHeight = 84;
    
    //注册cell
    [self.rankListTableView registerNib:[UINib nibWithNibName:@"ClubTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClubTableViewCell"];
    
    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAction) name:@"number" object:@"change"];
    //子视图
    self.listVC = [[ListViewController alloc]init];
    self.listVC.view.frame = CGRectMake(0, -70, kscreenWidth, kscreenHeight - 64);
    [self addChildViewController: self.listVC];
    
}

//代理
-(void)setDelegate{
    
    self.rankListTableView.delegate = self;
    self.rankListTableView.dataSource = self;
    
}

//手势
-(void)setGesture{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.titleView addGestureRecognizer:tap];
}

//点击手势
-(void)tapAction{
    if ([self.view.subviews containsObject:self.listVC.view]) {
        [UIView animateWithDuration:0.4 animations:^{
            self.listVC.view.frame = CGRectMake(0,-100, kscreenWidth,64 );
             self.titleImage.center = CGPointMake(kscreenWidth/2 + 20, 25);
            self.titleImage.transform = CGAffineTransformRotate(_titleImage.transform, M_PI);
        } completion:^(BOOL finished) {
            [self.listVC.view removeFromSuperview];
            
            
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            [self.view addSubview:self.listVC.view];
            self.listVC.view.frame = CGRectMake(0, 0, kscreenWidth, kscreenHeight);
            self.titleImage.transform = CGAffineTransformRotate(_titleImage.transform,M_PI);
        }];
    }
    
    
}


//请求数据
-(void)setData{
   
    if (self.listVC.number == 0) {
        [self.monthDic setValue:@0 forKey:@"page"];
        [RequestUrl requestWith:GET URL:URLMONTH condition:self.monthDic SuccessBlock:^(id item) {
            
            self.monthArrAllData = [ NSMutableArray array];
            if (item) {
                NSArray * arrData = [item objectForKey:@"data"];
                for (NSDictionary * dic in arrData) {
                    ClubModel * model = [[ClubModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.monthArrAllData addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.rankListTableView reloadData];
                    
                });
            }
            
        } failBlock:^(NSError *err) {
            
        }];
    }else if (self.listVC.number == 1){
        
        [self.yearDic setValue:@0 forKey:@"page"];
        [RequestUrl requestWith:GET URL:URLYEAR condition:self.yearDic SuccessBlock:^(id item) {
            
            self.yearArrAllData = [NSMutableArray array];
            if (item) {
                NSArray * arrData = [item objectForKey:@"data"];
                for (NSDictionary * dic in arrData) {
                    ClubModel * model = [[ClubModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.yearArrAllData addObject:model];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.rankListTableView reloadData];
                });
            }
            
        } failBlock:nil];
        
    }

}



-(void)setDataWithUrl:(NSString *)STRING Dictionary:(NSDictionary *)Dic{
    
    if (self.listVC.number == 0) {
        [RequestUrl requestWith:GET URL:STRING condition:Dic SuccessBlock:^(id item) {
            if (item) {
                NSArray * arrData = [item objectForKey:@"data"];
                for (NSDictionary * dic in arrData) {
                    ClubModel * model = [[ClubModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.monthArrAllData addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.rankListTableView reloadData];
                    
                    });
            }
           
        } failBlock:^(NSError *err) {
           
        }];
    }else if (self.listVC.number == 1){
        
    [RequestUrl requestWith:GET URL:STRING condition:Dic SuccessBlock:^(id item) {
        if (item) {
            NSArray * arrData = [item objectForKey:@"data"];
        for (NSDictionary * dic in arrData) {
            ClubModel * model = [[ClubModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.yearArrAllData addObject:model];
            
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.rankListTableView reloadData];
                });
        }
       
    } failBlock:nil];
    
    }
}


//通知--刷新列表

-(void)changeAction{
    self.number=self.listVC.number;
    if (self.number == 0) {
        [self.rankListTableView reloadData];
        self.titleLabel.text = @"俱乐部月度榜";
////        if (!self.monthArrAllData) {
//            [self setDataWithUrl:URLMONTH Dictionary:self.monthDic];
////        }

        
        [self example01];
       
    }else if (self.number == 1){
        [self.rankListTableView reloadData];
        self.titleLabel.text = @"俱乐部年度榜";
////        if (self.yearArrAllData.count==0) {
//              [self setDataWithUrl:URLYEAR Dictionary:self.yearDic];
//
////        }
        [self example01];
    }
    

    [UIView animateWithDuration:0.4 animations:^{
        self.titleImage.center = CGPointMake(kscreenWidth/2 + 20, 25);
        self.titleImage.transform = CGAffineTransformRotate(_titleImage.transform, M_PI);

        
    }];

}




#pragma mark TableView Delegate
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.listVC.number == 0) {
        return self.monthArrAllData.count;
    }else if (self.listVC.number == 1){
        return self.yearArrAllData.count;
    }
    
    return 0;
}


//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClubTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ClubTableViewCell" forIndexPath:indexPath];
    if (self.listVC.number == 0) {
        
        ClubModel * model = self.monthArrAllData[indexPath.row];
        
        cell.teamNumber.textAlignment = NSTextAlignmentCenter;
        cell.teamNumber.layer.masksToBounds = YES;
        if (indexPath.row == 0) {
            cell.teamNumber.backgroundColor = [UIColor orangeColor];
            cell.teamNumber.text = @"#1";
        }else if (indexPath.row == 1){
            cell.teamNumber.backgroundColor = [UIColor brownColor];
            cell.teamNumber.text = @"#2";
        }else if (indexPath.row > 1){
            cell.teamNumber.backgroundColor = [UIColor grayColor];
            cell.teamNumber.text = [NSString stringWithFormat:@"#%ld",indexPath.row + 1];
        }
        
        cell.teamTitle.text = model.teamTitle;
        
        if (model.teamCityName.length == 0) {
            cell.teamCitynameImageView.hidden = YES;
            cell.teamCityName.text=nil;
        }else{
            cell.teamCitynameImageView.hidden=NO;
            cell.teamCityName.text=model.teamCityName;
        }
        cell.teamCityName.text = model.teamCityName;
        cell.teamMiles.text = [NSString stringWithFormat:@"%ld",model.teamMiles];
        cell.teamUserCounts.text = [NSString stringWithFormat:@"%ld",model.teamUserCounts];
        cell.teamAvatar.layer.masksToBounds = YES;
        if (model.teamAvatar.length != 0) {
            [cell.teamAvatar sd_setImageWithURL:[NSURL URLWithString:model.teamAvatar]];
        }else{
            cell.teamAvatar.image = [UIImage imageNamed:@"xing.jpg"];
        }

        
    }else if (self.listVC.number == 1){
    
        ClubModel * model = self.yearArrAllData[indexPath.row];
        cell.teamNumber.textAlignment = NSTextAlignmentCenter;
        cell.teamNumber.layer.masksToBounds = YES;
        if (indexPath.row == 0) {
            cell.teamNumber.backgroundColor = [UIColor orangeColor];
            cell.teamNumber.text = @"#1";
        }else if (indexPath.row == 1){
            cell.teamNumber.backgroundColor = [UIColor brownColor];
            cell.teamNumber.text = @"#2";
        }else if (indexPath.row > 1){
            cell.teamNumber.backgroundColor = [UIColor grayColor];
            cell.teamNumber.text = [NSString stringWithFormat:@"#%ld",indexPath.row + 1];
        }
        
        cell.teamTitle.text = model.teamTitle;
        
        if (model.teamCityName.length == 0) {
            cell.teamCitynameImageView.hidden = YES;
        }
        cell.teamCityName.text = model.teamCityName;
        cell.teamMiles.text = [NSString stringWithFormat:@"%ld",model.teamMiles];
        cell.teamUserCounts.text = [NSString stringWithFormat:@"%ld",model.teamUserCounts];
        cell.teamAvatar.layer.masksToBounds = YES;
        if (model.teamAvatar.length != 0) {
            [cell.teamAvatar sd_setImageWithURL:[NSURL URLWithString:model.teamAvatar]];
        }else{
            cell.teamAvatar.image = [UIImage imageNamed:@"xing.jpg"];
        }

        
    }
        return cell;
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController * deatilVC = [[DetailViewController alloc]init];
    deatilVC.hidesBottomBarWhenPushed=YES;
    if (self.listVC.number == 0) {
        ClubModel * model = self.monthArrAllData[indexPath.row];
        deatilVC.teamId = model.teamId;
    }else if (self.listVC.number == 1){
        ClubModel * model = self.yearArrAllData[indexPath.row];
        deatilVC.teamId = model.teamId;
    }
    [self.navigationController pushViewController:deatilVC animated:YES];
    
}



#pragma mark - 下拉刷新 ,上拉加载

//下拉刷新
-(void)example01{
    
    __weak __typeof(self) weakSelf = self;
    self.rankListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    weakSelf.rankListTableView.userInteractionEnabled = NO;
    //设置回调(一旦进入刷新状态,也就是调用self的loadNewData方法)
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    //设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    //隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;

    //设置文字
    [header setTitle:@"辛苦了" forState:MJRefreshStateIdle];
    [header setTitle:@"请稍后...." forState:MJRefreshStatePulling];
    [header setTitle:@"加载中...." forState:MJRefreshStateRefreshing];
    
    //设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:15];
    
    //设置颜色
    header.stateLabel.textColor = [UIColor blueColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor redColor];
    

    //设置header
    self.rankListTableView.mj_header = header;
    //马上进入刷新状态
    [self.rankListTableView.mj_header beginRefreshing];
    
}

//上拉加载
-(void)example11{

    [self example01];
    __weak __typeof(self) weakSelf = self;
    
    //设置回调(一旦进入刷新状态,就调用target的action,也就是调用self的loadingMoreData方法)
    self.rankListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    [footer setTitle:@"no More data ..." forState:MJRefreshStateNoMoreData];
    //设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    //设置颜色
    footer.stateLabel.textColor = [UIColor blueColor];

    //设置footer
    self.rankListTableView.mj_footer = footer;
   self.rankListTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.rankListTableView.mj_footer endRefreshing];
    });
}

//下拉刷新数据
-(void)loadNewData{
    
    if (self.listVC.number == 0) {

        [self setData];
        
            }else if (self.listVC.number == 1){

                [self setData];
            
            }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rankListTableView.userInteractionEnabled = YES;
        [self.rankListTableView.mj_header endRefreshing];
    });

    
}

//上拉加载更多数据
-(void)loadMoreData{
    
    self.number = self.listVC.number;
    
    if (self.number == 0) {
        monthStr++;
        NSInteger  monthPage = monthStr;
        [self.monthDic setObject:[NSString stringWithFormat:@"%ld",monthPage] forKey:@"page"];
        [self setDataWithUrl:URLMONTH Dictionary:self.monthDic];

    }
        else if (self.number == 1) {
        yearStr++;
        NSInteger yearPage = yearStr;
        [self.yearDic setObject:[NSString stringWithFormat:@"%ld",yearPage] forKey:@"page"];
        [self setDataWithUrl:URLYEAR Dictionary:self.yearDic];
    }
    
 
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.rankListTableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.rankListTableView.mj_footer endRefreshing];
        
    });
    
    
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
