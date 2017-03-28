//
//  clubViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/11.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "clubViewController.h"
#import "RankViewController.h"
#import "CreatViewController.h"
#import "tool.h"
#import "ClubTableViewCell.h"
#import "RequestUrl.h"
#import "ClubModel.h"
#import <UIImageView+WebCache.h>
#import "userLocationSingleton.h"
#import <MJRefresh.h>
#import "DetailViewController.h"

static const CGFloat MJDuration = 1.0;


@interface clubViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic,strong) UISearchBar * search;
@property(nonatomic,strong) UIView * titleView;
@property(nonatomic,strong) UITableView * clubListTableView;
@property(nonatomic,strong) UIButton * nearbyButton;

@property(nonatomic,strong) NSMutableArray * arrAllData;
@property(nonatomic,strong) NSMutableArray * showData;
@property(nonatomic,strong) NSString * searcgString;

@property(nonatomic,strong) NSMutableDictionary * nearbyDic;
@property(nonatomic,strong) NSMutableDictionary * searchDic;

@property(nonatomic,strong) NSString * latitude;
@property(nonatomic,strong) NSString * longitude;
@property(nonatomic,assign) NSInteger nearbyPage;
@property(nonatomic,assign) NSInteger searchPage;

@property(nonatomic,strong) UIButton * button;
@end

@implementation clubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
       //标题
    self.title = @"俱乐部";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
        //地址拼接
    self.nearbyPage = 0;
    self.searchPage = 0;
    self.latitude = @"40.029195";
    self.longitude = @"116.337080";
    //    self.latitude = [NSString stringWithFormat:@"%f",[userLocationSingleton shareuserLocationSingleton].userlocation.location.coordinate.latitude];
    //    self.longitude = [NSString stringWithFormat:@"%f",[userLocationSingleton shareuserLocationSingleton].userlocation.location.coordinate.longitude];
    
    
    self.arrAllData = [NSMutableArray array];
    self.showData = [NSMutableArray array];
    

    [self setView];
    
     self.search.delegate = self;

    
}


-(void)setView{
    
    self.search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, 40)];
    self.search.placeholder = @"编号,名称和附近车队搜索";
    [self.view addSubview:self.search];
    
    //左
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"rank_icon@2x.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    self.navigationController.navigationBar.translucent=NO;
    //右
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xingzhe_nav_more-03@2x.png"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction)];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.search.frame.size.height + 20, kscreenWidth, kscreenHeight)];
//    self.scrollView.backgroundColor = [UIColor orangeColor];
    self.scrollView.contentSize = CGSizeMake(kscreenWidth, kscreenHeight * 2);
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    
    
}


-(void)setTableView{
    //self.search.frame.size.height + 20
    self.clubListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.search.frame) + 10, kscreenWidth, kscreenHeight - 118) style:(UITableViewStylePlain)];
    //    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.clubListTableView.rowHeight = 84;
    [self.view addSubview:self.clubListTableView];
    [self.view bringSubviewToFront:self.search];
    self.clubListTableView.delegate = self;
    self.clubListTableView.dataSource =self;
    [self.clubListTableView registerNib:[UINib nibWithNibName:@"ClubTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClubTableViewCell"];

}

-(void)nearbyButtonAction{
    [self setTableView];
//    self.clubListTableView.frame = CGRectMake(0, 10, kscreenWidth, kscreenHeight - 54);
    self.nearbyDic = [ NSMutableDictionary dictionaryWithDictionary:@{@"latitude":[NSString stringWithFormat:@"%@",self.latitude],
                                                                      @"longitude":[NSString stringWithFormat:@"%@",self.longitude],
                                                                      @"page":@0}];
//    [self setDataWithDiction:self.nearbyDic];
    [self.clubListTableView reloadData];
//
    [self example01];
    [self example11];
    
    
}


-(void)setDataWithDiction:(NSMutableDictionary *)Dic{
 
    if (!self.searcgString) {
        
        [RequestUrl requestWith:GET URL:URLNEARBY condition:Dic SuccessBlock:^(id item) {
            
            for (NSDictionary * dic in item) {
                
                ClubModel * model = [[ClubModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.arrAllData addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.clubListTableView reloadData];
                
                
            });
            
            
        } failBlock:^(NSError *err) {
            
        }];
    }else{
        
        [RequestUrl requestWith:GET URL:URLNEARBY condition:Dic SuccessBlock:^(id item) {
            
            for (NSDictionary * dic in item) {
                
                ClubModel * model = [[ClubModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.showData addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.clubListTableView reloadData];
                
                
            });
            
           
        } failBlock:^(NSError *err) {
            
        }];

    }
    
    
    
}




#pragma mark 下拉刷新&上拉加载

//下拉刷新
-(void)example01{
    
    __weak __typeof(self) weakSelf = self;
    self.clubListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    weakSelf.clubListTableView.userInteractionEnabled = NO;
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
    self.clubListTableView.mj_header = header;
    //马上进入刷新状态
    [self.clubListTableView.mj_header beginRefreshing];
   
}


//上拉加载
-(void)example11{
    
//    [self example01];
    __weak __typeof(self) weakSelf = self;
    
    //设置回调(一旦进入刷新状态,就调用target的action,也就是调用self的loadingMoreData方法)
    self.clubListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    self.clubListTableView.mj_footer = footer;
    self.clubListTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.clubListTableView.mj_footer endRefreshing];
    });
}



//刷新
-(void)loadNewData{
    self.nearbyPage = 0;
    self.searchPage = 0;
            [self.arrAllData removeAllObjects];
            [self.showData removeAllObjects];
            [self.nearbyDic setObject:@0 forKey:@"page"];
            [self setDataWithDiction:self.nearbyDic];
            [self.clubListTableView reloadData];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.clubListTableView.userInteractionEnabled = YES;
        
        [self.clubListTableView.mj_header endRefreshing];
    });
}

//加载
-(void)loadMoreData{

    self.nearbyPage++;
    [self.nearbyDic setObject:[NSString stringWithFormat:@"%ld",self.self.nearbyPage] forKey:@"page"];
    [self setDataWithDiction:self.nearbyDic];

    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        // 刷新表格
        [self.clubListTableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.clubListTableView.mj_footer endRefreshing];
        
        
    });
    
    
}
#pragma mark SearchBar Delegate

//搜索框开始编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

//     self.button.hidden = YES;
    self.search.showsCancelButton = YES;
    if (!self.navigationController.navigationBarHidden) {
        
        self.navigationController.navigationBarHidden = YES;
        //键盘
        self.search.returnKeyType = UIReturnKeySearch;
        [self.search setKeyboardType:(UIKeyboardTypeNamePhonePad)];
        
    self.search.frame = CGRectMake(0, 0, kscreenWidth, 64);
        self.search.backgroundColor = [UIColor grayColor];
   
        //附近按钮
        self.nearbyButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 50, 110, 30)];
        [self.nearbyButton setTitle:@"附近俱乐部" forState:(UIControlStateNormal)];
        [self.nearbyButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        [self.nearbyButton.layer setCornerRadius:15.0];
        [self.nearbyButton.layer setBorderWidth:1];
        [self.nearbyButton.layer setBorderColor:[UIColor blueColor].CGColor];
        [self.nearbyButton addTarget:self action:@selector(nearbyButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.scrollView addSubview:self.nearbyButton];
        
        
    }
        return YES;
}


//输入框内容变化
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText != nil && searchText.length > 0) {
        
        self.searcgString = searchText;
        self.searchDic = [ NSMutableDictionary dictionaryWithDictionary:@{@"latitude":[NSString stringWithFormat:@"%@",self.latitude],
                                                                          @"longitude":[NSString stringWithFormat:@"%@",self.longitude],
                                                                          @"keyword":[NSString stringWithFormat:@"%@",self.searcgString],
                                                                          @"page":@0}];

    }
    
}


//取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.button.enabled = NO;
    [searchBar setText:nil];
    self.navigationController.navigationBarHidden = NO;
    
    [self.titleView removeFromSuperview];
    
    if ([self.view.subviews containsObject:self.clubListTableView]) {
        
        [self.clubListTableView removeFromSuperview];
    }
    
    [searchBar setShowsCancelButton:NO animated:YES];

    self.search.frame = CGRectMake(0, 0, kscreenWidth, 40);
    self.search.backgroundColor = [UIColor grayColor];
    
     [self.search resignFirstResponder];
    [self.nearbyButton removeFromSuperview];
    
}

//点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"---%@",searchBar.text);
    
    if ([self.view.subviews containsObject:self.clubListTableView]) {
        
        [self.clubListTableView removeFromSuperview];
    }
    [self.showData removeAllObjects];
    
        [self setDataWithDiction:self.searchDic];
        [self setTableView];
}



#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return  self.arrAllData.count;
    
    if (!self.searcgString) {
        
        return  self.arrAllData.count;
    }else{
        
        return self.showData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     [self.search resignFirstResponder];
    ClubTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ClubTableViewCell" forIndexPath:indexPath];
    
    if (self.searcgString == nil) {

    ClubModel * model = self.arrAllData[indexPath.row];
    CGRect rect = cell.teamNumber.frame;
    rect.size.width = 50;
    cell.teamNumber.frame = rect;
    cell.teamNumber.backgroundColor = [UIColor clearColor];
    cell.teamNumber.text = [NSString stringWithFormat:@"#%ld",model.teamId];
    
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
        
        
    }else{
        
        ClubModel * model = self.showData[indexPath.row];
        CGRect rect = cell.teamNumber.frame;
        rect.size.width = 50;
        cell.teamNumber.frame = rect;
        cell.teamNumber.backgroundColor = [UIColor clearColor];
        cell.teamNumber.text = [NSString stringWithFormat:@"#%ld",model.teamId];
        
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
            cell.teamAvatar.image = [UIImage imageNamed:@"chuyin.png"];
        }

        
    }
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController * detailVC = [[DetailViewController alloc]init];
        detailVC.hidesBottomBarWhenPushed = YES;
    
    if (self.searcgString ==nil) {
        ClubModel * model = self.arrAllData[indexPath.row];
        detailVC.teamId = model.teamId;
    }else {
        ClubModel * model = self.showData[indexPath.row];
        detailVC.teamId = model.teamId;
    }

    [self.navigationController pushViewController:detailVC animated:YES];
    

}


//-(void)rightAction{
//    
//    CreatViewController * creatVC = [[CreatViewController alloc]init];
//    
//    [self.navigationController pushViewController:creatVC animated:YES];
//    
//}

-(void)leftAction{
    
    RankViewController * rankVC = [[RankViewController alloc]init];
    
    [self.navigationController pushViewController:rankVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
