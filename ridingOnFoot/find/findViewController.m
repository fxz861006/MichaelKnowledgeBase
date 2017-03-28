
//
//  findViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/11.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "findViewController.h"
#import "tool.h"
#import "NearViewController.h"
#import "MyViewController.h"
#import "RequestUrl.h"
#import <MJRefresh.h>
#import "FindModel.h"
#import "FindTableViewCell.h"
#import "FindDetailViewController.h"
#import <UIImageView+WebCache.h>

static const CGFloat MJDuration = 1.0;

@interface findViewController ()<UIScrollViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UIScrollView * titleScrollView;
@property(nonatomic,strong) UIScrollView * contentScrollView;
@property(nonatomic,strong) NSArray * titleArr;
@property(nonatomic,strong) NSMutableArray * buttonArr;
@property(nonatomic,strong) UIButton * selectButton;
@property(nonatomic,strong) UIImageView * selectBackImageView;

@property(nonatomic,strong) UILabel * titleLabel;

//搜索
@property(nonatomic,strong) UISearchBar * search;
@property(nonatomic,strong) UIView * titleView;
@property(nonatomic,strong) UIView * backView;
@property(nonatomic,strong) NSMutableArray * arrAllData;
@property(nonatomic,strong) UITableView * findSearchTableView;
@property(nonatomic,strong) NSString * searchStr;
@property(nonatomic,strong)  NSMutableDictionary * searchDic;
@property(nonatomic,assign) NSInteger searchPage;
@property(nonatomic,strong) UITapGestureRecognizer * tap;

@end




static CGFloat const maxScale = 1;

static NSInteger titleH = 40;


@implementation findViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationController.navigationBarHidden = YES;
    
    self.navV=[[UIView alloc] initWithFrame:CGRectMake(0, 0,kscreenWidth,64)];
    self.navV.backgroundColor =[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    [self.view addSubview:self.navV];
    self.backbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backbtn.frame=CGRectMake(10, 22, 30, 30);
    self.backbtn.tintColor=[UIColor whiteColor];
    [self.backbtn setImage:[UIImage imageNamed:@"xingzhe_find@2x.png"] forState:(UIControlStateNormal)];
    [self.backbtn addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navV addSubview:self.backbtn];
    self.navtitle=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-80, 22, 160, 40)];
    self.navtitle.text=@"活动";
    self.navtitle.textAlignment=NSTextAlignmentCenter;
    self.navtitle.textColor=[UIColor whiteColor];
    [self.navV addSubview:self.navtitle];

    
    
    //添加子控制器
    [self addChildViewController];
    //添加文字标签
    [self setTitleScrollView];
    //添加控制器scrollView
    [self setContentScrollView];      /** 添加scrollView  */
    
    [self setupTitle];                /** 设置标签按钮 文字 背景图  */
    //滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    //控制器scrollView的每一页的大小
    self.contentScrollView.contentSize = CGSizeMake(self.titleArr.count * kscreenWidth, 0);
    //可翻页
    self.contentScrollView.pagingEnabled = YES;
    //水平方向的滑标
    self.contentScrollView.showsHorizontalScrollIndicator  = NO;
    self.contentScrollView.delegate = self;
    
//    //标题
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xingzhe_find@2x.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xingzhe_nav_more-21@2x.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
//
    
    
    // Do any additional setup after loading the view.
}

-(void)backAction{
    
    self.searchPage = 0;
    
    if (!self.navV.hidden) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.navV.hidden = YES;
        } completion:^(BOOL finished){
            self.backView =[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            self.backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:-128/255.0 blue:-128/255.0 alpha:0.5];
            
            [self.view addSubview:self.backView];
            self.search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, 70)];
            self.search.backgroundColor = [UIColor clearColor];
            self.search.placeholder = @"搜索附近的活动";
            [self.backView addSubview:self.search];
            self.search.delegate = self;
            self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
            [self.backView addGestureRecognizer:self.tap];
            
        }];
        
        
        
    }

}


-(void)tapAction{
    
    if (self.navV.hidden) {
        self.navV.hidden = NO;
        [self.backView removeFromSuperview];
    }else{
        [self.backView removeFromSuperview];
    }
    
    
}



-(void)addChildViewController{
    
    
    for (int i = 0; i < self.titleArr.count; i++) {
        
        switch (i) {
            case 0:{
                NearViewController * nearVC = [[NearViewController alloc]init];
                nearVC.title = self.titleArr[i];
                [self addChildViewController:nearVC];
                
                break;
            }
            case 1:{
                MyViewController * myVC = [[MyViewController alloc]init];
                myVC.title = self.titleArr[i];
                [self addChildViewController:myVC];
                
                break;
            }
            default:
                break;
        }
        
    }
    
}


-(void)setTitleScrollView{
    //设置位置大小
    CGRect rect = CGRectMake(0, 64, kscreenWidth,titleH);
    
    //设置标签视图的位置大小
    self.titleScrollView = [[UIScrollView alloc]initWithFrame:rect];
    //把标签的背景色
    self.titleScrollView.backgroundColor = kColor(226, 226, 226, 1);
    
    //添加到父视图
    [self.view addSubview:self.titleScrollView];
    
}


-(void)setContentScrollView{
    
    
    CGFloat y  = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect  = CGRectMake(0, y, kscreenWidth, kscreenHeight - titleH);
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:self.contentScrollView];
    
    
}

-(void)setupTitle{
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat x = 0;
    CGFloat w = kscreenWidth/2;
    CGFloat h = titleH;
    self.selectBackImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, titleH)];
    self.selectBackImageView.image = [UIImage imageNamed:@"blue.png"];
    self.selectBackImageView.backgroundColor = [UIColor blueColor];
    //页面交互
    self.selectBackImageView.userInteractionEnabled = YES;
    //    [self.titleScrollView addSubview:self.selectBackImageView];
    [self.titleScrollView insertSubview:self.selectBackImageView atIndex:1];
    
    for (int i = 0; i < count; i++)
    {
        UIViewController *vc = self.childViewControllers[i];
        
        x = i * w;
        //标签按钮的大小
        CGRect rect = CGRectMake(x, 0, w, h-2);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];
        
        
        if (i == 0)
        {
            [self click:btn];
        }
        
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
}

-(void)click:(UIButton *)sender{
    
    [self selectTitleBtn:sender];
    NSInteger i = sender.tag;
    CGFloat x  = i *kscreenWidth;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    if (i==1) {
        UIButton *btn= self.buttonArr[i-1];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    
    [self.selectButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    
    [self setUpOneChildController:i];
    
}


-(void)selectTitleBtn:(UIButton *)btn{
    
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    //1:1放缩
    btn.transform = CGAffineTransformMakeScale(maxScale, maxScale);
    self.selectButton = btn;
    
    [self setupTitleCenter:btn];
    
}


-(void)setupTitleCenter:(UIButton *)sender
{
    
    CGFloat offset = sender.center.x - kscreenWidth * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    CGFloat maxOffset  = self.titleScrollView.contentSize.width - kscreenWidth;
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
}

-(void)setUpOneChildController:(NSInteger)index{
    
    
    CGFloat x  = index * kscreenWidth;
    UIViewController *vc  =  self.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, kscreenWidth, kscreenHeight - self.contentScrollView.frame.origin.y);
    [self.contentScrollView addSubview:vc.view];
    
}
#pragma mark - UIScrollView  delegate 本地&附近

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger i  = self.contentScrollView.contentOffset.x / kscreenWidth;
    [self selectTitleBtn:self.buttons[i]];
    [self setUpOneChildController:i];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetX  = scrollView.contentOffset.x;
    NSInteger leftIndex  = offsetX / kscreenWidth;
    NSInteger rightIdex  = leftIndex + 1;
    
    UIButton *leftButton = self.buttons[leftIndex];
    UIButton *rightButton  = nil;
    if (rightIdex < self.buttons.count) {
        rightButton  = self.buttons[rightIdex];
    }
    CGFloat scaleR  = offsetX / kscreenWidth - leftIndex;
    CGFloat scaleL  = 1 - scaleR;
    CGFloat transScale = maxScale - 1;
    
    self.selectBackImageView.transform  = CGAffineTransformMakeTranslation((offsetX*(self.titleScrollView.contentSize.width / self.contentScrollView.contentSize.width)), 0);
    
    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    
    UIColor *rightColor = [UIColor blackColor];
    UIColor *leftColor = [UIColor blackColor];
    
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    
}








#pragma mark - UISearch Delegate 搜索框
//搜索框开始编辑
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    //键盘样式
    self.search.returnKeyType = UIReturnKeySearch;
    [self.search setKeyboardType:(UIKeyboardTypeNamePhonePad)];
    self.search.showsCancelButton = YES;
    
    return YES;
}


//点击取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    if (self.navV.hidden) {
        self.navV.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
         } completion:^(BOOL finished) {
            [self.backView removeFromSuperview];
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            
        }];
        
    }
    
    self.search.showsCancelButton = NO;
    
}

//搜索框文本发生变化
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText != nil && searchText.length > 0) {
        
        self.searchStr = searchText;
        self.searchDic = [NSMutableDictionary dictionaryWithDictionary:@{@"limit":@"20",@"page":@"0",@"keyword":[NSString stringWithFormat:@"%@",self.searchStr]}];
    }
    
    
    
}

//点击搜索按钮
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if ([self.backView.subviews containsObject:self.findSearchTableView]) {
        
        [self.findSearchTableView removeFromSuperview];
    }
    
    self.arrAllData = [NSMutableArray array];
    [self setDataWithDictionary:self.searchDic];
    [self setView];
    [self.findSearchTableView reloadData];
    [self.backView removeGestureRecognizer:self.tap];
    
    
}

//结束搜索框内容编辑
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    
    [self example01];
    [self example11];
//
}

//请求数据
-(void)setDataWithDictionary:(NSDictionary *)dic{
    
    [RequestUrl requestWith:GET URL:URLFINDSEARCH condition:dic SuccessBlock:^(id item) {
       
        if (item) {
            
            NSArray * arr = item[@"data"];
            
            for (NSDictionary * dic in arr) {
                
                FindModel * model = [[FindModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.arrAllData addObject:model];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self.findSearchTableView reloadData];
            });
            
        }
        
    } failBlock:^(NSError *err) {
        
    }];
}


//TableView 初始化
-(void)setView{
    
    self.findSearchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.search.frame), kscreenWidth, kscreenHeight - 118) style:(UITableViewStylePlain)];
    [self.backView addSubview:self.findSearchTableView];
    [self.backView bringSubviewToFront:self.search];
    self.findSearchTableView.delegate = self;
    self.findSearchTableView.dataSource = self;
    [self.findSearchTableView registerNib:[UINib nibWithNibName:@"FindTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindTableViewCell"];
    
}


#pragma mark 下拉刷新&&上拉加载
//下拉刷新
-(void)example01{
    
    __weak __typeof(self) weakSelf = self;
    //    self.clubListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [weakSelf loadNewData];
    //    }];
    weakSelf.findSearchTableView.userInteractionEnabled = NO;
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
    self.findSearchTableView.mj_header = header;
    //马上进入刷新状态
    [self.findSearchTableView.mj_header beginRefreshing];
    
}


//上拉加载
-(void)example11{
    
    //    [self example01];
    __weak __typeof(self) weakSelf = self;
    
    //设置回调(一旦进入刷新状态,就调用target的action,也就是调用self的loadingMoreData方法)
    self.findSearchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    self.findSearchTableView.mj_footer = footer;
    self.findSearchTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.findSearchTableView.mj_footer endRefreshing];
    });
}

//下拉刷新
-(void)loadNewData{
    
    [self.arrAllData removeAllObjects];
    self.searchPage = 0;
    [self.searchDic setObject:[NSString stringWithFormat:@"%ld",self.searchPage] forKey:@"page"];
    [self setDataWithDictionary:self.searchDic];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.findSearchTableView.userInteractionEnabled = YES;
        [self.findSearchTableView.mj_header endRefreshing];
    });
    
    
    
}

//上拉加载
-(void)loadMoreData{
    
    self.searchPage++;
    [self.searchDic setObject:[NSString stringWithFormat:@"%ld",self.searchPage] forKey:@"page"];
    [self setDataWithDictionary:self.searchDic];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        // 刷新表格
        [self.findSearchTableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.findSearchTableView.mj_footer endRefreshing];
        
        
    });
    
}



#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrAllData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.search resignFirstResponder];
//    [self.findSearchTableView reloadData];
    FindTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FindTableViewCell" forIndexPath:indexPath];
    FindModel * model = self.arrAllData[indexPath.row];
    
    cell.activityType.layer.masksToBounds = YES;
    if (model.activityType == 0) {
        cell.activityType.backgroundColor = kColor(26,0 ,255 ,1);
        cell.activityType.text = @"简单";
    }else if (model.activityType == 1){
        cell.activityType.backgroundColor = kColor(58, 255, 0, 1);
        cell.activityType.text = @"休闲";
    }else if (model.activityType == 2){
        cell.activityType.backgroundColor = kColor(245, 128, 2, 1);
        cell.activityType.text = @"困难";
    }else if (model.activityType == 3){
        cell.activityType.backgroundColor = kColor(243, 21, 3, 1);
        cell.activityType.text = @"疯狂";
    }else if (model.activityType == 4){
        cell.activityType.backgroundColor = [UIColor blackColor];
        cell.activityType.text = @"地狱";
    }
    
    cell.activityTitle.text = model.activityTitle;
    cell.activityAddress.text = model.activityAddress;
    cell.activityCount.text = [NSString stringWithFormat:@"%ld/%ld人",model.activityUsersCount,model.activityUserMaxCount];
    cell.activityMiles.text = [NSString stringWithFormat:@"%ldkm",model.activityMiles/1000];
    if ([model.activityCoverPic containsString:@";"]) {
        
        NSArray * array = [model.activityCoverPic componentsSeparatedByString:@";"];
        NSString * picStr = array.firstObject;
        
        [cell.activityCoverPic sd_setImageWithURL:[NSURL URLWithString:picStr]];
    }else if(model.activityCoverPic.length == 0 ){
        
        cell.activityCoverPic.image = [UIImage imageNamed:@"xing.jpg"];
        
    }else{
        [cell.activityCoverPic sd_setImageWithURL:[NSURL URLWithString:model.activityCoverPic]];
    }

   
        
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FindDetailViewController * findDetailVC = [[FindDetailViewController alloc]init];
    FindModel * model = self.arrAllData[indexPath.row];
    findDetailVC.activityId = model.activityId;
    
    [self.navigationController pushViewController:findDetailVC animated:YES];}






#pragma mark 懒加载
- (NSMutableArray *)buttons
{
    if (!_buttonArr)
    {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}


-(NSArray *)titleArr{
    if (!_titleArr) {
        
        _titleArr = [NSArray arrayWithObjects:@"附近",@"我的", nil];
        
    }
    
    return _titleArr;
    
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
