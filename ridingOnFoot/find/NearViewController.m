//
//  NearViewController.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/25.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "NearViewController.h"
#import "tool.h"
#import "FindModel.h"
#import "FindTableViewCell.h"
#import "RequestUrl.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "FindDetailViewController.h"
static const CGFloat MJDuration = 1.0;


@interface NearViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView * nearTableView;
@property(nonatomic,strong) NSMutableArray * arrAllData;
@property(nonatomic,strong) NSMutableDictionary * nearDic;

@property(nonatomic,strong) NSString * lat;
@property(nonatomic,strong) NSString * lon;
@property(nonatomic,assign) NSInteger findPage;



@end

@implementation NearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    //?lat=40.02921596353647&limit=20&lon=116.3373105854755&page=0
    //    self.lat = [NSString stringWithFormat:@"%f",[userLocationSingleton shareuserLocationSingleton].userlocation.location.coordinate.latitude];
    //    self.lon= [NSString stringWithFormat:@"%f",[userLocationSingleton shareuserLocationSingleton].userlocation.location.coordinate.longitude];
    

    self.nearDic = [NSMutableDictionary dictionaryWithDictionary:@{@"lat":@"40.02921596353647",@"lon":@"116.3373105854755",@"limit":@"20",@"page":@0}];
    self.arrAllData = [NSMutableArray array];
    [self setDataWithDictionary:self.nearDic];
    [self setView];
    [self setDelegate];
    
    
    
}



-(void)setView{
    
    self.nearTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight - 148) style:(UITableViewStylePlain)];
    [self.view addSubview:self.nearTableView];
    
    [self.nearTableView registerNib:[UINib nibWithNibName:@"FindTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindTableViewCell"];
    
    [self example01];
    [self example11];
}

-(void)setDelegate{
   
    self.nearTableView.delegate = self;
    self.nearTableView.dataSource = self;
    
}


-(void)setData{
    
    [self.nearDic setValue:@0 forKey:@"page"];
    
    [RequestUrl requestWith:GET URL:URLFIND condition:self.nearDic SuccessBlock:^(id item) {
        self.arrAllData = [NSMutableArray array];
        if (item) {
            
            NSArray * arr = item[@"data"];
            for (NSDictionary * dic in arr) {
                
                FindModel * model = [[FindModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.arrAllData addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.nearTableView reloadData];
            });

        }
    } failBlock:^(NSError *err) {
        
    }];
}



-(void)setDataWithDictionary:(NSMutableDictionary *)dic{
    
    [RequestUrl requestWith:GET URL:URLFIND condition:dic SuccessBlock:^(id item) {
        if (item) {
            
            NSArray * arr = item[@"data"];
        for (NSDictionary * dic in arr) {
            
            FindModel * model = [[FindModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.arrAllData addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.nearTableView reloadData];
        });
        }
    } failBlock:^(NSError *err) {
        
    }];

    
            
}


#pragma mark 下拉刷新&&上拉加载
//下拉刷新
-(void)example01{
    
    __weak __typeof(self) weakSelf = self;
    //    self.clubListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [weakSelf loadNewData];
    //    }];
    weakSelf.nearTableView.userInteractionEnabled = NO;
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
    self.nearTableView.mj_header = header;
    //马上进入刷新状态
    [self.nearTableView.mj_header beginRefreshing];
    
}


//上拉加载
-(void)example11{
    
    //    [self example01];
    __weak __typeof(self) weakSelf = self;
    
    //设置回调(一旦进入刷新状态,就调用target的action,也就是调用self的loadingMoreData方法)
    self.nearTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    
    //设置回调()
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //禁止自动加载
    footer.automaticallyRefresh = NO;
    
    //当上拉刷新控件出现50%时(出现一半),就会自动刷新.这个值默认是1.0(也就是上拉刷新100%出现时,才会自动刷新)
    footer.triggerAutomaticallyRefreshPercent = 0.5;
    
    //设置文字
    [footer setTitle:@"加载完成" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中...." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"no More data ..." forState:MJRefreshStateNoMoreData];
    //设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    //设置颜色
    footer.stateLabel.textColor = [UIColor blueColor];
    
    //设置footer
    self.nearTableView.mj_footer = footer;
    self.nearTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.nearTableView.mj_footer endRefreshing];
    });
}


-(void)loadNewData{
    
//    if (self.arrAllData.count == 0) {
//       [self.arrAllData removeAllObjects];
//    }
//    
    self.findPage = 0;
//    [self.nearDic setObject:[NSString stringWithFormat:@"%ld",self.findPage] forKey:@"page"];
//    [self setDataWithDictionary:self.nearDic];

    
    [self setData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.nearTableView.userInteractionEnabled = YES;
        [self.nearTableView.mj_header endRefreshing];
    });
    
    
    
}

-(void)loadMoreData{
    
    self.findPage++;
    [self.nearDic setObject:[NSString stringWithFormat:@"%ld",self.findPage] forKey:@"page"];
    [self setDataWithDictionary:self.nearDic];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        // 刷新表格
//        [self.nearTableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.nearTableView.mj_footer endRefreshing];
        
        
    });
    
}



#pragma mark TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrAllData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FindTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FindTableViewCell" forIndexPath:indexPath];
    
    FindModel * model = self.arrAllData[indexPath.row];
    [cell setmodel:model indexpath:indexPath];
  
//    cell.activityType.layer.masksToBounds = YES;
//    if (model.activityType == 0) {
//        cell.activityType.backgroundColor = kColor(26,0 ,255 ,1);
//        cell.activityType.text = @"简单";
//    }else if (model.activityType == 1){
//        cell.activityType.backgroundColor = kColor(58, 255, 0, 1);
//        cell.activityType.text = @"休闲";
//    }else if (model.activityType == 2){
//        cell.activityType.backgroundColor = kColor(245, 128, 2, 1);
//        cell.activityType.text = @"困难";
//    }else if (model.activityType == 3){
//        cell.activityType.backgroundColor = kColor(243, 21, 3, 1);
//        cell.activityType.text = @"疯狂";
//    }else if (model.activityType == 4){
//        cell.activityType.backgroundColor = [UIColor blackColor];
//        cell.activityType.text = @"地狱";
//    }
//  
//    cell.activityTitle.text = model.activityTitle;
//    cell.activityAddress.text = model.activityAddress;
//    cell.activityCount.text = [NSString stringWithFormat:@"%ld/%ld人",model.activityUsersCount,model.activityUserMaxCount];
//    cell.activityMiles.text = [NSString stringWithFormat:@"%ldkm",model.activityMiles/1000];
//    if ([model.activityCoverPic containsString:@";"]) {
//        
//        NSArray * array = [model.activityCoverPic componentsSeparatedByString:@";"];
//        NSString * picStr = array.firstObject;
//        
//            [cell.activityCoverPic sd_setImageWithURL:[NSURL URLWithString:picStr]];
//    }else if(model.activityCoverPic.length == 0 ){
//        
//        cell.activityCoverPic.image = [UIImage imageNamed:@"xing.jpg"];
//        
//    }else{
//        [cell.activityCoverPic sd_setImageWithURL:[NSURL URLWithString:model.activityCoverPic]];
//    }
//      cell.leftlayout.constant=(CGRectGetMaxX(cell.activityTime.frame)-cell.activityMiles.frame.origin.x+15)/2+CGRectGetMaxX(cell.activityTime.frame)-(cell.activityCount.frame.size.width+15)/2;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FindDetailViewController *findDetailVC=[[FindDetailViewController alloc] init];
    FindModel * model = self.arrAllData[indexPath.row];
    findDetailVC.activityId=model.activityId;
    findDetailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:findDetailVC animated:YES];
  


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
