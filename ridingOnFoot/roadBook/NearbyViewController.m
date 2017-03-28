//
//  NearbyViewController.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/18.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "NearbyViewController.h"
#import "tool.h"
#import "RequestUrl.h"
#import "RoadbookModel.h"
#import "RoadbookTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "MoreViewController.h"
#import <MJRefresh.h>

static const CGFloat MJDuration = 1.0;

@interface NearbyViewController ()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong) UITableView * nearbyTableView;
@property(nonatomic,strong) NSMutableArray * nearbyArrAllData;
@property(nonatomic,assign) NSInteger roadPage;
@property(nonatomic,strong) NSMutableDictionary * roadDic;

@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nearbyArrAllData = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
   self.title = @"附近";
    //    self.lat = [NSString stringWithFormat:@"%f",[userLocationSingleton shareuserLocationSingleton].userlocation.location.coordinate.latitude];
    //    self.lng = [NSString stringWithFormat:@"%f",[userLocationSingleton shareuserLocationSingleton].userlocation.location.coordinate.longitude];
    self.roadDic = [NSMutableDictionary dictionaryWithDictionary:@{@"lat":@40.02921596353647,@"limit":@20,@"lng":@116.3373105854755,@"page":@0,@"type":@3}];
     self.roadPage = 0;

    [self setData];
    [self setView];
}



-(void)setView{
    
    self.nearbyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight - 148) style:(UITableViewStylePlain)];
   
    [self.view addSubview:self.nearbyTableView];
    
    [self.nearbyTableView registerNib:[UINib nibWithNibName:@"RoadbookTableViewCell" bundle:nil] forCellReuseIdentifier:@"RoadbookTableViewCell"];
    
    self.nearbyTableView.delegate = self;
    self.nearbyTableView.dataSource = self;
    
    [self example01];
    [self example11];
    
    
}






-(void)setData{
    //lat=40.02921596353647&limit=20&lng=116.3373105854755&page=0&type=3
    [self.roadDic setValue:@0 forKey:@"page"];
    [RequestUrl requestWith:GET URL:URLLUSHU condition:self.roadDic SuccessBlock:^(id item) {
        
        self.nearbyArrAllData = [NSMutableArray array];
        for (NSDictionary * dic in item) {
            RoadbookModel * model = [[RoadbookModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.nearbyArrAllData addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.nearbyTableView reloadData];
            
        });
        
        
    } failBlock:^(NSError *err) {
    
        
    }];
    
    
}


-(void)setDataWithDictionary:(NSMutableDictionary *)dic{
    
    [RequestUrl requestWith:GET URL:URLLUSHU condition:self.roadDic SuccessBlock:^(id item) {

        for (NSDictionary * dic in item) {
            RoadbookModel * model = [[RoadbookModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.nearbyArrAllData addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.nearbyTableView reloadData];
            
        });
        
        
    } failBlock:^(NSError *err) {
        
        
    }];
    
    
    
}



#pragma mark 下拉刷新&上拉加载

//下拉刷新
-(void)example01{
    
    __weak __typeof(self) weakSelf = self;
    //    self.clubListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [weakSelf loadNewData];
    //    }];
    weakSelf.nearbyTableView.userInteractionEnabled = NO;
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
    self.nearbyTableView.mj_header = header;
    //马上进入刷新状态
    [self.nearbyTableView.mj_header beginRefreshing];
    
}


//上拉加载
-(void)example11{
    
    //    [self example01];
    __weak __typeof(self) weakSelf = self;
    
    //设置回调(一旦进入刷新状态,就调用target的action,也就是调用self的loadingMoreData方法)
//    self.nearbyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf loadMoreData];
//    }];
//    
//    
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
    self.nearbyTableView.mj_footer = footer;
    self.nearbyTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.nearbyTableView.mj_footer endRefreshing];
    });
}


-(void)loadNewData{
    
    [self setData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.nearbyTableView.userInteractionEnabled = YES;
        [self.nearbyTableView.mj_header endRefreshing];
    });
    
    
    
}

-(void)loadMoreData{
    
    self.roadPage++;
    [self.roadDic setObject:[NSString stringWithFormat:@"%ld",self.roadPage] forKey:@"page"];
    [self setDataWithDictionary:self.roadDic];
    
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        // 刷新表格
//                [self.nearbyArrAllData reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.nearbyTableView.mj_footer endRefreshing];
        
        
    });
    
}








#pragma mark TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.nearbyArrAllData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RoadbookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RoadbookTableViewCell" forIndexPath:indexPath];
    RoadbookModel * model = self.nearbyArrAllData[indexPath.row];
    
    cell.titleLabel.text = model.title;
    cell.user_nameLabel.text = [NSString stringWithFormat:@"%@ ",model.user_name];
   
    cell.distanceLabel.text = [NSString stringWithFormat:@"| %.2fkm",model.distance/1000];
    
    cell.comment_num.text = [NSString stringWithFormat:@"%ld",model.comment_num];
    cell.download_time.text = [NSString stringWithFormat:@"%ld",model.download_time];
   [cell.mapImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
   
    if (model.is_collect == false) {
        
        cell.collectionImageView.hidden = YES;
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    MoreViewController * moreVC = [[MoreViewController alloc]init];
    moreVC.model = self.nearbyArrAllData[indexPath.row];
    [self.navigationController pushViewController:moreVC animated:YES];
    
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
