//
//  roadBookViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/11.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "roadBookViewController.h"
#import "LocalViewController.h"
#import "NearbyViewController.h"
#import "tool.h"
#import "RequestUrl.h"
#import "RoadbookModel.h"
#import "RoadbookTableViewCell.h"
#import "MoreViewController.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>


#define RandomColor kColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),1)/** 随机色  */

static const CGFloat MJDuration = 1.0;




@interface roadBookViewController ()<UIScrollViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>


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
@property(nonatomic,strong) UITableView * roadDetailTAbleView;
@property(nonatomic,strong) NSString * searchStr;
@property(nonatomic,strong)  NSMutableDictionary * detailDic;
@property(nonatomic,assign) NSInteger searchPage;
@property(nonatomic,strong) UITapGestureRecognizer * tap;

@end




static CGFloat const maxScale = 1;

static NSInteger titleH = 40;



@implementation roadBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.translucent=NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    

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
    
    self.view.backgroundColor=[UIColor whiteColor];
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
    self.navtitle.text=@"路书";
    self.navtitle.textAlignment=NSTextAlignmentCenter;
    self.navtitle.textColor=[UIColor whiteColor];
    [self.navV addSubview:self.navtitle];
//    [self.backbtn addTarget:self action:@selector(leftAction) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:self.navV];
//    //标题
//    self.title = @"路书";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xingzhe_find@2x.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
//
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xingzhe_nav_more-21@2x.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    
    

    
    

}



-(void)addChildViewController{
    
    
    for (int i = 0; i < self.titleArr.count; i++) {
        
        switch (i) {
            case 0:{
                LocalViewController * locationVC = [[LocalViewController alloc]init];
                locationVC.title = self.titleArr[i];
                [self addChildViewController:locationVC];
                
                break;
            }
            case 1:{
                NearbyViewController * nearbyVC = [[NearbyViewController alloc]init];
                nearbyVC.title = self.titleArr[i];
                [self addChildViewController:nearbyVC];
                
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








#pragma mark 左右按钮


-(void)backAction{
    
    self.searchPage = 0;
    
    if (!self.navV.hidden) {
       
        [UIView animateWithDuration:0.2 animations:^{
//            self.navigationController.navigationBar.frame = CGRectMake(0, -64, kscreenWidth, 64);
            self.navV.hidden = YES;
        } completion:^(BOOL finished){
           self.backView =[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            self.backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:-128/255.0 blue:-128/255.0 alpha:0.5];
            
            [self.view addSubview:self.backView];
//            [self.view bringSubviewToFront:self.backView];
//            self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, 40)];
//            self.titleView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
//            self.titleView.alpha = 1;
//            [self.backView addSubview:self.titleView];
            
            self.search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, 70)];
            self.search.backgroundColor = [UIColor clearColor];
            self.search.placeholder = @"请输入编号和名称";
//            self.search.showsCancelButton = YES;
            [self.backView addSubview:self.search];
            self.search.delegate = self;
            
            
            //               [self.searchBar setInputAccessoryView:_btnHide];// 提供一个遮盖视图, 当处于UISearchBar焦点状态下（输入框正要输入内容时），会有一个遮盖视图。你翻看一下，iPhone手机上的电话本搜索功能。那个遮盖视图就是一个半透明的黑色View。
            
            self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
            
            [self.backView addGestureRecognizer:self.tap];
            
        }];
        
       
        
    }
    
}


//添加路书
/*
-(void)rightAction{
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
    NSInteger w = kscreenWidth/2 - 25;
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kscreenWidth, kscreenHeight + 64)];
    self.backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:-128/255.0 blue:-128/255.0 alpha:0.5];
    [self.view addSubview:self.backView];
    
    UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake((kscreenWidth - w)/2, 300, w, 50)];
    btn1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"roadbook_recommend@2x.png"]];
    [self.backView addSubview:btn1];
    [btn1 addTarget:self action:@selector(btn1Action) forControlEvents:(UIControlEventTouchUpInside)];
    UIButton * btn2 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(btn1.frame), CGRectGetMaxY(btn1.frame) + 20, btn1.frame.size.width, btn1.frame.size.height)];
    btn2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"roadbook_normal@2x"]];
    [self.backView addSubview:btn2];
    [btn2 addTarget:self action:@selector(btn2Action) forControlEvents:(UIControlEventTouchUpInside)];
    UIButton * btn3 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(btn2.frame), CGRectGetMaxY(btn2.frame) + 20, btn2.frame.size.width, btn2.frame.size.height)];
    btn3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"roadbook_Importing@2x.png"]];
    [self.backView addSubview:btn3];
    [btn3 addTarget:self action:@selector(btn3Action) forControlEvents:(UIControlEventTouchUpInside)];
}


//推荐模式
-(void)btn1Action{
    
}


//传统模式
-(void)btn2Action{
    
    
}


//导入路书
-(void)btn3Action{
    
    
    
}

*/


-(void)tapAction{
    
    if (self.navV.hidden) {
        self.navV.hidden = NO;
    [self.backView removeFromSuperview];
//    self.navigationController.navigationBar.userInteractionEnabled = YES;
    }else{
        [self.backView removeFromSuperview];
//        self.navigationController.navigationBar.userInteractionEnabled = YES;
    }
    

}


-(void)setView{
    
    self.roadDetailTAbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.search.frame), kscreenWidth, kscreenHeight - 118) style:(UITableViewStylePlain)];
    [self.backView addSubview:self.roadDetailTAbleView];
    [self.backView bringSubviewToFront:self.search];
    self.roadDetailTAbleView.delegate = self;
    self.roadDetailTAbleView.dataSource = self;
    
    [self.roadDetailTAbleView registerNib:[UINib nibWithNibName:@"RoadbookTableViewCell" bundle:nil] forCellReuseIdentifier:@"RoadbookTableViewCell"];
    
}

-(void)setDataWithDictionary:(NSMutableDictionary *)dic{
    //?limit=20&page=0&query=111&type=0
//    NSMutableDictionary * detailDic = [NSMutableDictionary dictionaryWithDictionary:@{@"limit":@"20",@"page":@"0",@"query":@"111",@"type":@"0"}];
    [RequestUrl requestWith:GET URL:URLLUSHU condition:dic SuccessBlock:^(id item) {
        
        self.arrAllData = [NSMutableArray array];
        for (NSDictionary * dic in item) {
            
            RoadbookModel * model = [[RoadbookModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.arrAllData addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.roadDetailTAbleView reloadData];
        });
        
    } failBlock:^(NSError *err) {
        
    }];
}

#pragma mark - UISearch Delegate 搜索框
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
           //键盘样式
        self.search.returnKeyType = UIReturnKeySearch;
        [self.search setKeyboardType:(UIKeyboardTypeNamePhonePad)];
    self.search.showsCancelButton = YES;

    return YES;
}



-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    if (self.navV.hidden) {
        self.navV.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
//            self.navigationController.navigationBar.frame = CGRectMake(0, 0, kscreenWidth, 64);
            
        } completion:^(BOOL finished) {
            [self.backView removeFromSuperview];
            
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            
        }];
        
    }
    
    self.search.showsCancelButton = NO;
           
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText != nil && searchText.length > 0) {
        
        self.searchStr = searchText;
    self.detailDic = [NSMutableDictionary dictionaryWithDictionary:@{@"limit":@"20",@"page":@"0",@"query":[NSString stringWithFormat:@"%@",self.searchStr],@"type":@"0"}];
    }
    

    
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
//    self.backView.userInteractionEnabled = NO;
    
    if ([self.backView.subviews containsObject:self.roadDetailTAbleView]) {
        
        [self.roadDetailTAbleView removeFromSuperview];
    }
    
//    [self.arrAllData removeAllObjects];
    [self setDataWithDictionary:self.detailDic];
    [self setView];
    [self.backView removeGestureRecognizer:self.tap];
    
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    
    [self example01];
    [self example11];
}

#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrAllData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.search resignFirstResponder];
    RoadbookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RoadbookTableViewCell" forIndexPath:indexPath];
    RoadbookModel * model = self.arrAllData[indexPath.row];
    
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
    moreVC.model = self.arrAllData[indexPath.row];
    [self.navigationController pushViewController:moreVC animated:YES];
    
}


#pragma mark 下拉刷新&&上拉加载
//下拉刷新
-(void)example01{
    
    __weak __typeof(self) weakSelf = self;
    //    self.clubListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [weakSelf loadNewData];
    //    }];
    weakSelf.roadDetailTAbleView.userInteractionEnabled = NO;
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
    self.roadDetailTAbleView.mj_header = header;
    //马上进入刷新状态
    [self.roadDetailTAbleView.mj_header beginRefreshing];
    
}


//上拉加载
-(void)example11{
    
    //    [self example01];
    __weak __typeof(self) weakSelf = self;
    
    //设置回调(一旦进入刷新状态,就调用target的action,也就是调用self的loadingMoreData方法)
    self.roadDetailTAbleView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    self.roadDetailTAbleView.mj_footer = footer;
    self.roadDetailTAbleView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.roadDetailTAbleView.mj_footer endRefreshing];
    });
}


-(void)loadNewData{
    
    [self.arrAllData removeAllObjects];
    self.searchPage = 0;
    [self.detailDic setObject:[NSString stringWithFormat:@"%ld",self.searchPage] forKey:@"page"];
    [self setDataWithDictionary:self.detailDic];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.roadDetailTAbleView.userInteractionEnabled = YES;
        [self.roadDetailTAbleView.mj_header endRefreshing];
    });

    
    
}

-(void)loadMoreData{
    
    self.searchPage++;
    [self.detailDic setObject:[NSString stringWithFormat:@"%ld",self.searchPage] forKey:@"page"];
    [self setDataWithDictionary:self.detailDic];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        // 刷新表格
        [self.roadDetailTAbleView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.roadDetailTAbleView.mj_footer endRefreshing];
        
        
    });

}


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
        
        _titleArr = [NSArray arrayWithObjects:@"本地",@"附近", nil];
        
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
