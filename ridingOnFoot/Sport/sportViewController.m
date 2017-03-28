//
//  sportViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/11.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "sportViewController.h"
#import "leftState.h"
#import "scrollAddView.h"
#import "helpViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "MapV.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "PointWithDistanceAnn.h"
#import "PointWithDistanceAnnView.h"
#import "MovementInfo.h"
#import "userLocationSingleton.h"
#import "shareMapViewController.h"
#import "UMSocial.h"
#import "sportmodel.h"
#import "usermodel.h"
#import <AFNetworkReachabilityManager.h>
//#define kscreenWidth  [UIScreen mainScreen].bounds.size.width
//#define kscreenHeight  [UIScreen mainScreen].bounds.size.height
#import "tool.h"
@interface sportViewController ()<UIScrollViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIView *mengV;
@property(nonatomic,strong)UILabel *navlabel;
@property(nonatomic,strong)UIScrollView *scrollV;
@property(nonatomic,strong)scrollAddView *scrollAddV;
@property(nonatomic,strong)UIButton *startBtn;
@property(nonatomic,strong)UIButton *endBtn;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,assign)BOOL  distanceFlag;
@property(nonatomic,assign)BOOL altitudeFlag;
@property(nonatomic,assign)BOOL  isstart;
@property(nonatomic,assign)BOOL   fist;
@property(nonatomic,strong)NSMutableArray *distancePolylineArray;
@property(nonatomic,strong)MapV *mapView;
@property(nonatomic,strong)sportmodel *sportModel;
@property(nonatomic,assign)NSInteger totdis;
@property(nonatomic,assign)BMKUserTrackingMode currentTrackigMode;
//用来存放测距模式下的ann
@property(strong,nonatomic)NSMutableArray *distanceAnnArray;
/** 百度定位服务 */
@property (nonatomic, strong) BMKLocationService *bmkLocationService;
//地图的缩放级别，范围是[3-19]
@property(assign,nonatomic)CGFloat zoomLevel;
///** 位置数组 */
//@property (nonatomic, strong) NSMutableArray *locationArrayM;
///** 轨迹数组 */
//@property (nonatomic, strong) NSMutableArray *polyLineArray;
//用来存放整个运动过程中的运动信息model
@property(strong,nonatomic)NSMutableArray *roadmapArray;
//用来存放运动时的路径画线
@property(strong,nonatomic)NSMutableArray *roadmapPolylineArray;
//运动计时用timer
@property(strong,nonatomic)NSTimer *moveTimer;
//运动用时
@property(assign,nonatomic)NSInteger timeCount;
//用来存放起点和终点
@property(strong,nonatomic)NSMutableArray *startAndEndAnnArray;
//极速速度
@property(assign,nonatomic)CGFloat  topspeed;
//精准度
@property(assign,nonatomic)CGFloat  Accuracy;
@property(nonatomic,strong)BMKGeoCodeSearch* geocodesearch;
@end

@implementation sportViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication].delegate.window addSubview:self.mapView];

}


-(void)viewWillDisappear:(BOOL)animated {
    [self.mapView removeFromSuperview];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self networking];
    
     [self addMapView];
    self.isStartpoint=YES;
    self.sportModel=[[sportmodel alloc] init];
    UIView *navV=[[UIView alloc] initWithFrame:CGRectMake(0, 0,kscreenWidth,64)];
    navV.backgroundColor =[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    
    self.leftBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    self.leftBtn.frame=CGRectMake(10, 22, 40, 40);
    self.leftBtn.tintColor=[UIColor whiteColor];
    switch ([leftState shareleftstate].leftstate) {
        case biking:{
            [self.leftBtn setImage:[UIImage imageNamed:@"icon_biking@2x.png"] forState:(UIControlStateNormal)];
            break;}
        case running:{
            [self.leftBtn setImage:[UIImage imageNamed:@"icon_running@2x.png"] forState:(UIControlStateNormal)];
            break;}
        case walking:{
            [self.leftBtn setImage:[UIImage imageNamed:@"icon_biking@2x.png"] forState:(UIControlStateNormal)];
            break;}
        default:
            break;
    }
    
    
    [self.leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [navV addSubview:self.leftBtn];
    
    self.navlabel=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-60, 22, 120, 40)];
    self.navlabel.text=@"随行";
    self.navlabel.font=[UIFont systemFontOfSize:19];
    self.navlabel.textColor=[UIColor whiteColor];
    self.navlabel.textAlignment=NSTextAlignmentCenter;
    [navV addSubview:self.navlabel];
    //调用相册
//    UIButton *photobtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
//    photobtn.frame=CGRectMake(kscreenWidth-90, 22, 40, 40);
//    [photobtn setImage:[UIImage imageNamed:@"camera@2x.png"] forState:(UIControlStateNormal)];
//    photobtn.tintColor=[UIColor whiteColor];
//    [photobtn addTarget:self action:@selector(photoAction) forControlEvents:(UIControlEventTouchUpInside)];
//    [navV addSubview:photobtn];
    UIButton *setbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    setbtn.frame=CGRectMake(kscreenWidth-50, 22, 40, 40);

    [setbtn setTitle:@"帮助" forState:(UIControlStateNormal)];
    setbtn.tintColor=[UIColor whiteColor];
    [setbtn addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    [navV addSubview:setbtn];
    
    [self setScroll];
    self.scrollV.delegate=self;

    self.imageV=[[UIImageView alloc] initWithFrame:CGRectMake(kscreenWidth-15,kscreenHeight/2-86,20, 80)];
    self.imageV.userInteractionEnabled=YES;
    self.imageV.image=[UIImage imageNamed:@"drag_btn@2x.png"];
    [self.scrollAddV addSubview:self.imageV];
    
    
  [self.view addSubview:navV];
    self.geocodesearch=[[BMKGeoCodeSearch alloc]init];
    self.geocodesearch.delegate=self;
    
    
}
//网络判断
-(void)networking{
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,//未识别的网络
     AFNetworkReachabilityStatusNotReachable     = 0,//不可达的网络(未连接)
     AFNetworkReachabilityStatusReachableViaWWAN = 1,//2G,3G,4G...
     AFNetworkReachabilityStatusReachableViaWiFi = 2,//wifi网络
     };
     */
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
//                NSLog(@"未识别的网络");
                UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络链接失败" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *defulAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:nil];
                [alertCon addAction:defulAction];
                [self presentViewController:alertCon animated:YES completion:^{
                    NSString *islogin=@"退出";
                    NSString *filepath=file;
                    [islogin writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    [userLocationSingleton shareuserLocationSingleton].isnetwork=NO;
                }];
                break;}
                
            case AFNetworkReachabilityStatusNotReachable:{
//                NSLog(@"不可达的网络(未连接)");
                UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络未链接" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *defulAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:nil];
                [alertCon addAction:defulAction];
                [self presentViewController:alertCon animated:YES completion:^{
                    NSString *islogin=@"退出";
                    NSString *filepath=file;
                    [islogin writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    [userLocationSingleton shareuserLocationSingleton].isnetwork=NO;
                }];
                break;}
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"2G,3G,4G...的网络");
                [userLocationSingleton shareuserLocationSingleton].isnetwork=YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"wifi的网络");
                [userLocationSingleton shareuserLocationSingleton].isnetwork=YES;
                break;
            default:
                break;
        }
    }];
    //开始监听
    [manager startMonitoring];


}
//添加地图视图
-(void)addMapView{
    self.mapView=[[MapV alloc] initWithFrame:CGRectMake(kscreenWidth, 0, kscreenWidth, kscreenHeight)];
      //追踪用户的location
    self.mapView.mapView.mapType=BMKMapTypeStandard;
    self.currentTrackigMode=BMKUserTrackingModeFollow;
    self.mapView.mapView.userTrackingMode=BMKUserTrackingModeFollow;
     self.mapView.mapView.delegate=self;
    self.mapView.mapView.buildingsEnabled=YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.mapView.leftView addGestureRecognizer:pan];
    [self.mapView.shareButton addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.mapTypeButton addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.mapDistanceButton addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.mapZoomInButton addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.mapZoomOutButton addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView.mapDirectionButton addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.Accuracy=500;
    self.mapView.mapView.showsUserLocation = YES;
    self.mapView.mapView.zoomLevel=15;
//    指南针是否显示，no为不显示
//    self.mapView.mapView.showsCompass= YES;
    //设置指南针位置compassPosition
//    self.mapView.mapView.compassPosition= CGPointMake(kscreenWidth-50 ,kscreenHeight*0.15);
//    [self.mapView.mapView setCompassImage:[UIImage imageNamed:@"compass@3x"]];
//    [self.mapView.mapView setCompassPosition:CGPointMake(kscreenWidth- 100,100)];

    self.bmkLocationService=[[BMKLocationService alloc] init];
//    //2. 设置更新位置频率(单位：米;必须要在开始定位之前设置)

    self.bmkLocationService.delegate=self;
  
    self.bmkLocationService.distanceFilter =self.Accuracy;
    //    设置最小定位精度
    self.bmkLocationService.desiredAccuracy =10;
 
    //开始定位
    [self.bmkLocationService startUserLocationService];
    //测高模式默认关闭
    self.altitudeFlag =NO;
    //测距模式默认关闭
    self.distanceFlag = NO;
}

//选择运动模式
-(void)leftBtnAction{
    self.mengV=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.mengV.backgroundColor=[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.2];
    UIButton *btn0=[UIButton buttonWithType:UIButtonTypeSystem];
    btn0.frame=CGRectMake(10, 69, 80, 60);
    btn0.backgroundColor=[UIColor whiteColor];
    btn0.tintColor=[UIColor grayColor];
    [btn0 setImage:[UIImage imageNamed:@"xingzhe_sporttype_cycling_highlight@2x.png"] forState:(UIControlStateNormal)];
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame=CGRectMake(91, 69, 80, 60);
    btn1.backgroundColor=[UIColor whiteColor];
      btn1.tintColor=[UIColor grayColor];
    [btn1 setImage:[UIImage imageNamed:@"xingzhe_sporttype_run_highlight@2x.png"] forState:(UIControlStateNormal)];
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame=CGRectMake(172, 69, 80, 60);
    btn2.backgroundColor=[UIColor whiteColor];
      btn2.tintColor=[UIColor grayColor];
    [btn2 setImage:[UIImage imageNamed:@"xingzhe_sporttype_walk_highlight@2x.png"] forState:(UIControlStateNormal)];

    [btn0  addTarget:self action:@selector(action:) forControlEvents:(UIControlEventTouchUpInside)];
    btn0.tag=101;
    [btn1  addTarget:self action:@selector(action:) forControlEvents:(UIControlEventTouchUpInside)];
    btn1.tag=102;
    [btn2  addTarget:self action:@selector(action:) forControlEvents:(UIControlEventTouchUpInside)];
    btn2.tag=103;
    switch ([leftState shareleftstate].leftstate) {
        case biking:{
            btn0.tintColor=[UIColor blackColor];
                       break;}
        case running:{
             btn1.tintColor=[UIColor blackColor];
                        break;}
        case walking:{
             btn2.tintColor=[UIColor blackColor];
            break;}
        default:
            break;
    }
    [self.mengV addSubview:btn0];
    [self.mengV addSubview:btn1];
    [self.mengV addSubview:btn2];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAction)];
    [self.mengV addGestureRecognizer:tap];
    [self.view addSubview:self.mengV];
    
}

-(void)action:(UIButton *)button{
    
    switch (button.tag) {
        case 101:{
            [leftState shareleftstate].leftstate= biking;
            
            break;}
        case 102:{
            [leftState shareleftstate].leftstate= running;
            break;}
        case 103:{
            [leftState shareleftstate].leftstate= walking;
            break;}
        default:
            break;
    }
    
    switch ([leftState shareleftstate].leftstate) {
        case biking:{
            [self.leftBtn setImage:[UIImage imageNamed:@"icon_biking@2x.png"] forState:(UIControlStateNormal)];
            self.tabBarItem.selectedImage=[UIImage imageNamed:@"tabbar_cycle_inactive@2x.png"];
            self.navigationController.tabBarItem.image=[UIImage imageNamed:@"tabbar_cycle_inactive@2x.png"];
            self.Accuracy=500;
            if (self.isstart==NO) {
                
            }else{
                //            [self endBtnAction];
                [self startBtnAction];
            }
            break;}
        case running:{
            [self.leftBtn setImage:[UIImage imageNamed:@"icon_running@2x.png"] forState:(UIControlStateNormal)];
            self.tabBarItem.selectedImage=[UIImage imageNamed:@"tabbar1_running_inactive@2x.png"];
            self.navigationController.tabBarItem.image=[UIImage imageNamed:@"tabbar1_running_inactive@2x.png"];
             self.Accuracy=50;
            if (self.isstart==NO) {
                
            }else{

            [self startBtnAction];
            }
            break;}
        case walking:{
            [self.leftBtn setImage:[UIImage imageNamed:@"icon_walking@2x.png"] forState:(UIControlStateNormal)];
            
            [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar1_walking_active@3x"]];
            self.tabBarItem.image = [UIImage imageNamed:@"tabbar1_walking_active@3x"];
             self.Accuracy=10;
        if (self.isstart==NO) {
            
        }else{
   
            [self startBtnAction];
        }

            break;}
        default:
            break;
    }
    [self removeAction];
}
//移除蒙版
-(void)removeAction{

[self.mengV removeFromSuperview];

}



//设置帮助按钮的方法
-(void)setAction{
    helpViewController *helpVC=[[helpViewController alloc] init];
    
    [self.navigationController pushViewController:helpVC animated:YES];
    

}
-(void)setScroll{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 20, kscreenWidth, kscreenHeight)];
    [self.view addSubview:v];
    self.scrollV=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kscreenWidth, kscreenHeight)];
    self.scrollV.contentSize=CGSizeMake(kscreenWidth*2, kscreenHeight-64);
    self.scrollV.pagingEnabled=YES;
    
    [self.view addSubview:self.scrollV];
    self.scrollAddV=[[[NSBundle mainBundle] loadNibNamed:@"scrollAddView" owner:nil options:nil] lastObject];
    if (kscreenHeight==568) {
        self.scrollAddV.frame=CGRectMake(0,10, kscreenWidth, kscreenHeight-168);
    }else{
        
     self.scrollAddV.frame=CGRectMake(0,10, kscreenWidth, kscreenHeight-168);
        self.scrollAddV.high.constant=150;
    
    }
    [self.scrollV addSubview:self.scrollAddV];
    self.startBtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.startBtn.frame=CGRectMake(0, kscreenHeight-108, kscreenWidth,60);
    self.startBtn.backgroundColor=[UIColor colorWithRed:27/255.0 green:162/255.0 blue:252/255.0 alpha:1];
    [self.startBtn setTitle:@"开始" forState:(UIControlStateNormal)];
    self.startBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    self.startBtn.tintColor=[UIColor whiteColor];
    [self.startBtn addTarget:self action:@selector(startBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.startBtn];
    self.endBtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.endBtn.frame=CGRectMake(0, kscreenHeight-108, kscreenWidth,60);
    self.endBtn.backgroundColor=[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    [self.endBtn setTitle:@"结束" forState:(UIControlStateNormal)];
    self.endBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    self.endBtn.tintColor=[UIColor whiteColor];
    self.endBtn.alpha=0;
    [self.endBtn addTarget:self action:@selector(endBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.endBtn];
    
    
    
    
}
/**
 *  开始骑行
 */
-(void)startBtnAction{
    //1. 开启骑行前清理各个lable的数值
    [self cleanLabel];
    
    [UIView animateWithDuration:1.0f animations:^{
        //1. 隐藏开始骑行按钮
        self.startBtn.alpha = 0;
        //2. 显示完成按钮
       
        self.endBtn.alpha = 1;
        
    } completion:^(BOOL finished) {
        //3. 开始骑行功能
        self.isstart=YES;
        [self startCycling];
    }];
    
}
/**
 *  结束骑行按钮
 */
-(void)endBtnAction{
    [UIView animateWithDuration:1.0f animations:^{
        //1. 隐藏开始骑行按钮
        self.startBtn.alpha = 1;
        //2. 显示完成按钮
        
        self.endBtn.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.isstart=NO;
        [self endCycling];
       
    }];
}

/**
 *  清空所有的显示信息label和路径
 */
-(void)cleanLabel{
    
    //路程记录数组
    [self.roadmapArray removeAllObjects];
    //移除地图上的线路路线
    [self.mapView.mapView removeOverlays:self.roadmapPolylineArray];
    //清空路线数组
    [self.roadmapPolylineArray removeAllObjects];
    //移除地图上的起点和终点的ann
    [self.mapView.mapView removeAnnotations:self.startAndEndAnnArray];
    //清除起点和终点ann的数组
    [self.startAndEndAnnArray removeAllObjects];
    //清空计时
    self.timeCount = 0;
 self.scrollAddV.labelspeedhour.text=@"0.00";
    self.scrollAddV.labelmileage.text=@"0.00";
    self.scrollAddV.labeltime.text=@"0:00:00";
    self.scrollAddV.labelacerage.text=@"0.00";
    self.scrollAddV.labelheat.text=@"0.00";
    self.scrollAddV.labelspeed.text=@"0.00";
    self.scrollAddV.labelelevation.text=@"0.00";


}
/**
 *  开始骑行
 */
-(void)startCycling{
    //设定最小更新距离
    [self.bmkLocationService stopUserLocationService];
    self.bmkLocationService.distanceFilter = self.Accuracy;
    //    设置最小定位精度
    self.bmkLocationService.desiredAccuracy =10;
    self.isStartpoint=YES;
    //开始定位
    [self.bmkLocationService startUserLocationService];

    [self beginTiming];
}
-(void)endCycling{
        MovementInfo *movementInfo = (MovementInfo *)self.roadmapArray.lastObject;
        self.isStartpoint=NO;
        PointWithDistanceAnn *ann = [[PointWithDistanceAnn alloc]init];
        ann.distanceStr = @"终点";
        ann.coordinate = movementInfo.coorRecord;
   
        [self.startAndEndAnnArray addObject:ann];
        
        // 添加大头针的方法
        [self.mapView.mapView addAnnotation:ann];
        
    [self.bmkLocationService stopUserLocationService];
    
    [self endTiming];
    
        [self ReverseGeoCode:ann.coordinate];

    
 

}




-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.mapView.frame = CGRectMake(kscreenWidth-scrollView.contentOffset.x, 0, kscreenWidth, kscreenHeight);
}
//地图界面左侧按钮的拖拽方法
-(void)panAction:(UIPanGestureRecognizer *)pan
{
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self.mapView];
    //获取手势操作点
    CGPoint point = [pan translationInView:pan.view];
    
    self.scrollV.contentOffset = CGPointMake(kscreenWidth-point.x, 0);
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        CGFloat magnitude = 0;
        CGFloat slideMult = 0;
        if (self.scrollV.contentOffset.x>kscreenWidth/2)
        {
            magnitude = kscreenWidth - self.scrollV.contentOffset.x;
            slideMult = magnitude / 200;
            float slideFactor = 0.1 * slideMult; // Increase for more of a slide
            
            [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                //pan.view.center = finalPoint;
                self.scrollV.contentOffset = CGPointMake(kscreenWidth, 0);
                
            } completion:nil];
            
        }
        else
        {
            magnitude = self.scrollV.contentOffset.x;
            slideMult = magnitude / 200;
            float slideFactor = 0.1 * slideMult; // Increase for more of a slide
            
            [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                //pan.view.center = finalPoint;
                self.scrollV.contentOffset = CGPointMake(0, 0);
            } completion:nil];
        }
        
        
    }
    
    
}
-(void)mapButtonAction:(UIButton *)button{
    switch (button.tag) {
        case 1002:{
            shareMapViewController *shar= [[shareMapViewController alloc] init];
            self.mapView.hidden=YES;
            [self presentViewController:shar animated:NO completion:nil];
            
            break;
        }
        case 1003:{
            if (self.mapView.mapView.mapType == BMKMapTypeSatellite)
            {
                [button setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_sat_off@2x.png"] forState:(UIControlStateNormal)];
                self.mapView.mapView.mapType = BMKMapTypeStandard;
                [self AnimationOfDisappearing:@"标准模式"];
            }
            //如果是普通地图模式，就切换到卫星地图模式
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_sat_on@2x.png"] forState:UIControlStateNormal];
                self.mapView.mapView.mapType = BMKMapTypeSatellite;
                //一个逐渐消失的提示信息
                [self AnimationOfDisappearing:@"卫星模式"];
                
            }
            self.mapView.mapView.userTrackingMode = self.currentTrackigMode;

            break;}
        case 1005:{
            if (self.distanceFlag == NO)
            {
                [button setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_length_on@2x.png"] forState:UIControlStateNormal];
                self.distanceFlag = YES;
                [self AnimationOfDisappearing:@"测距模式"];
            }
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_length_off@2x.png"] forState:UIControlStateNormal];
                self.distanceFlag = NO;
                [self.mapView.mapView removeAnnotations:self.distanceAnnArray];
                [self.distanceAnnArray removeAllObjects];
                [self.mapView.mapView removeOverlays:self.distancePolylineArray];
            }
            

            break;}
        case 1006:{
            //由跟随模式转换成指向模式
            if(self.mapView.mapView.userTrackingMode ==BMKUserTrackingModeFollow )
        {
            [button setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_location3@2x.png"] forState:(UIControlStateNormal)];
            // 追踪用户的location与heading更新
            self.mapView.mapView.showsUserLocation=NO;
            self.mapView.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
            self.mapView.mapView.showsUserLocation=YES;
            //由指向模式转换成跟随模式
        }else if(self.mapView.mapView.userTrackingMode == BMKUserTrackingModeFollowWithHeading||self.mapView.mapView.userTrackingMode ==BMKUserTrackingModeNone)
            {
                
                [button setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_location_1@2x.png"] forState:(UIControlStateNormal)];
                //追踪用户的location更新
                self.mapView.mapView.showsUserLocation=NO;
                 self.mapView.mapView.userTrackingMode=BMKUserTrackingModeFollow;
                self.mapView.mapView.showsUserLocation=YES;

                
            }
                        self.currentTrackigMode = self.mapView.mapView.userTrackingMode;
            

            break;}
        case 1007:{
            self.zoomLevel = self.mapView.mapView.zoomLevel;
            //最大是19，所以当前值只要比18小就可再加一
            if (self.zoomLevel <= 20)
            {
                self.zoomLevel += 1;
            }
            //
            else
            {
                self.zoomLevel = 21;
            }
            //设置地图缩放率
//            [self.mapView.mapView setZoomLevel:self.zoomLevel animated:YES];
            self.mapView.mapView.zoomLevel = self.zoomLevel;
            break;

            break;}
        case 1008:{
            self.zoomLevel = self.mapView.mapView.zoomLevel;
            if (self.zoomLevel >= 4)
            {
                self.zoomLevel -= 1;
            }
            else
            {
                self.zoomLevel = 3;
            }
//            [self.mapView.mapView setZoomLevel:self.zoomLevel animated:YES];
            self.mapView.mapView.zoomLevel = self.zoomLevel;

            break;}
            
        default:
            break;
    }


}
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"分享成功" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            // 延迟3秒
            
            sleep(3);
            alert.modalTransitionStyle=NO;
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}


//提示动画
-(void)AnimationOfDisappearing:(NSString *)str
{
    self.mapView.promptLabel.alpha = 1;
    self.mapView.promptLabel.text = str;
    [self.mapView addSubview:self.mapView.promptLabel];
    //开始动画,动画效果为label逐渐消失
    [UIView beginAnimations:@"prompt" context:NULL];
    //设置动画间隔
    [UIView setAnimationDuration:0.2];
    //提交动画
    [UIView commitAnimations];
    //用2秒内完成animation内的操作,透明度设为0
    [UIView animateWithDuration:2 animations:^{
        self.mapView.promptLabel.alpha= 0;
    } completion:^(BOOL finished) {
        [self.mapView.promptLabel removeFromSuperview];
    }];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [userLocationSingleton shareuserLocationSingleton].userlocation=userLocation;
    [self ReverseGeoCode:userLocation.location.coordinate];
    if (self.isstart==YES) {
        
    
    MovementInfo *movementInfo = [[MovementInfo alloc]init];
    if (self.roadmapArray.count !=0)
    {
        movementInfo = ((MovementInfo *)self.roadmapArray.lastObject).mutableCopy;
    }
    /*当定位成功后，如果horizontalAccuracy 水平距离大于0，说明定位有效
     horizontalAccuracy，该位置的纬度和经度确定的圆的中心，并且这个值表示圆的半径。负值表示该位置的纬度和经度是无效的。
     */
    if (userLocation.location.horizontalAccuracy > 0)
    {
        CGFloat distance = 0;
        NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
       
        //将第一次定位单独处理，因为计算距离要与上一个点进行操作，第一次定位没有上一个点
        if (movementInfo.coorRecord.latitude && movementInfo.coorRecord.longitude)
        {
            if (userLocation.location.speed== -1||userLocation.location.speed == 0)
            {
                self.scrollAddV.labelspeed.text=@"0.00";
                movementInfo.currentSpeed =0.00;
            }
            else if(userLocation.location.speed != 0)
            {
                
                
                CLLocation *locat1 = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
                CLLocation *locat2 = [[CLLocation alloc]initWithLatitude:movementInfo.coorRecord.latitude longitude:movementInfo.coorRecord.longitude];
                NSTimeInterval timeINterval = [nowDate timeIntervalSinceDate:movementInfo.timeDate];
                distance = [locat1 distanceFromLocation:locat2];
                movementInfo.currentSpeed = (distance/timeINterval)*3.6;
//                去除因定位误差所产生的过大的错误速度
                if (movementInfo.currentSpeed > 500)
                {
                    movementInfo.currentSpeed = 0.00;
                }

            }
            movementInfo.timeDate = nowDate;
            if (self.fist==YES) {
                self.fist=NO;
            }else{
            movementInfo.totleDistance += distance;
            self.totdis=movementInfo.totleDistance;
            }//平均速度
            if (self.timeCount==0) {
                self.scrollAddV.labelacerage.text=@"0.00";
            }else{
            self.scrollAddV.labelacerage.text =  [NSString stringWithFormat:@"%0.2f",(movementInfo.totleDistance/self.timeCount)*3.6];
            }
            
            
            
        }
        //第一次定位,初始化一次参数
        else
        {    self.fist=YES;
            movementInfo.timeDate = nowDate;
            movementInfo.currentSpeed = 0.00;
            movementInfo.totleDistance = 0.00;
        }
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    movementInfo.coorRecord = coordinate;
    [self GDLocationSucceed:movementInfo];
    self.scrollAddV.labelelevation.text=[NSString stringWithFormat:@"%0.2f",userLocation.location.altitude];

    CLLocationCoordinate2D  center;
    center.latitude  = userLocation.location.coordinate.latitude;
       center.longitude = userLocation.location.coordinate.longitude;
    self.mapView.mapView.centerCoordinate=center;
     }
    [self.mapView.mapView updateLocationData:userLocation];
        
}
-(void)GDLocationSucceed:(MovementInfo *)movementInfo
{
    
    
    //判断是不是出发点,如果不是则计算与上一个点的距离，是的话就显示出发点
    if (self.roadmapArray.count !=0)
    {

                if (self.fist==YES) {
        self.fist=NO;
        }else{
        if (movementInfo.currentSpeed>=self.topspeed) {
            self.topspeed=movementInfo.currentSpeed;
            
        }
        self.scrollAddV.labelspeed.text=[NSString stringWithFormat:@"%0.2f",self.topspeed];
        }
  
          
            
            //构造折线数据对象
            CLLocationCoordinate2D  commonPolylineCoords[2];
           
            commonPolylineCoords[0].latitude = ((MovementInfo *)(self.roadmapArray.lastObject)).coorRecord.latitude;
            commonPolylineCoords[0].longitude = ((MovementInfo *)(self.roadmapArray.lastObject)).coorRecord.longitude;
            
            commonPolylineCoords[1].latitude = movementInfo.coorRecord.latitude;
            commonPolylineCoords[1].longitude = movementInfo.coorRecord.longitude;
            //构造折线对象
           BMKPolyline *commonPolyline = [BMKPolyline polylineWithCoordinates:commonPolylineCoords count:2];
            //存入数组中
            [self.roadmapPolylineArray addObject:commonPolyline];
            //在地图上添加折线对象
            [self.mapView.mapView addOverlay: commonPolyline];
//        }
        
    }
    else
    {
        PointWithDistanceAnn *ann = [[PointWithDistanceAnn alloc]init];
        ann.distanceStr = @"出发点";
        self.sportModel.timeDate=[self timedateAction];
        ann.coordinate = movementInfo.coorRecord;
        [self ReverseGeoCode:movementInfo.coorRecord];
        [self.startAndEndAnnArray addObject:ann];
        
        // 添加大头针的方法
        [self.mapView.mapView addAnnotation:ann];
      self.scrollAddV.labelacerage.text =@"0.00";
        self.scrollAddV.labelspeed.text=@"0.00";
        self.topspeed=0.00;
    }
    [self.roadmapArray addObject:movementInfo];
 
    self.mapView.moveInfoView.distanceLabel.text = [NSString stringWithFormat:@"%0.2f",movementInfo.totleDistance/1000.0];
    self.mapView.moveInfoView.speedLabel.text = [NSString stringWithFormat:@"%0.2f",movementInfo.currentSpeed];
    
    
    
    self.scrollAddV.labelmileage.text = self.mapView.moveInfoView.distanceLabel.text;
    self.scrollAddV.labelspeedhour.text = self.mapView.moveInfoView.speedLabel.text;
//骑车速度（m/s）*体重（kg）*9.8（重力系数）*摩擦系数*骑车时间（秒）再就是1卡路里=4200焦耳
    self.scrollAddV.labelheat.text=[NSString stringWithFormat:@"%.2f",movementInfo.currentSpeed*60*9.8*self.timeCount/4200];
    
    

}
//调用反编码
-(void)ReverseGeoCode:(CLLocationCoordinate2D )coorRecord{


    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint =coorRecord;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }


}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.mapView.naVleftLabel.text=result.address;
            if (self.isStartpoint==YES) {
                     self.sportModel.startpoint=result.address;
                     NSLog(@"%@",result.address);

              
            }else{
                self.sportModel.stoppoint=result.address;
               
             NSLog(@"%@",result.address);
                if (((MovementInfo *)self.roadmapArray.lastObject).totleDistance < 20)
                            {
                                UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"由于本次运动过短，将不会被记录" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *defulAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:nil];
                                [alertCon addAction:defulAction];
                                [self presentViewController:alertCon animated:YES completion:nil];
                            }else{
                self.sportModel.username=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
                    self.sportModel.distance=(NSInteger)((MovementInfo *)self.roadmapArray.lastObject).totleDistance;
                self.sportModel.time=self.timeCount;
                self.sportModel.type=[leftState shareleftstate].leftstate;
                
                [[DataBase startDB] openDB];
               usermodel *userM=[[DataBase startDB] selectuser:self.sportModel.username];
                      
                                NSInteger totalDis=[userM.totaldistance intValue] +self.totdis;
                                userM.totaldistance=[NSString stringWithFormat:@"%ld",totalDis/1000];
                                [[DataBase startDB] updateuser:userM];
                [[DataBase startDB] addSport:self.sportModel];
                [[DataBase startDB] closeDB];
              
                        }

                
                
            }
    
   
    
    
}



-(NSString *)timedateAction{
    //3.通过计算获取东八区的时间
    NSDate *eightAreaTime = [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60];
    
    return [[NSString stringWithFormat:@"%@",eightAreaTime] substringToIndex:6];
}
//更新用户方向
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView.mapView updateLocationData:userLocation];
   
}
//单击地图添加测距点
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{

    if (self.distanceFlag == YES)
    {
        // 创建一个大头针对象
        PointWithDistanceAnn * ann = [[PointWithDistanceAnn alloc]init];
        
        ann.coordinate = coordinate;
        CLLocationDistance distance = 0;
        //判断是不是出发点,如果不是则计算与上一个点的距离，是的话就显示出发点
        if (self.distanceAnnArray.count != 0)
        {
            PointWithDistanceAnn *ann2 = (PointWithDistanceAnn *)self.distanceAnnArray.lastObject;
            //1.将两个经纬度点转成投影点
           BMKMapPoint point1 = BMKMapPointForCoordinate(ann.coordinate);
           BMKMapPoint point2 = BMKMapPointForCoordinate(ann2.coordinate);
            //2.计算距离
            distance = BMKMetersBetweenMapPoints(point1,point2);
            ann.pointDistance = distance + ann2.pointDistance;
            if (ann.pointDistance >=1000)
            {
                ann.distanceStr = [NSString stringWithFormat:@"%.1fkm",ann.pointDistance/1000];
                
            }else{
        
                ann.distanceStr = [NSString stringWithFormat:@"%.fm",ann.pointDistance];
            }
            //构造折线数据对象
            CLLocationCoordinate2D commonPolylineCoords[2];
            commonPolylineCoords[0].latitude = ann2.coordinate.latitude;
            commonPolylineCoords[0].longitude = ann2.coordinate.longitude;
            
            commonPolylineCoords[1].latitude = ann.coordinate.latitude;
            commonPolylineCoords[1].longitude = ann.coordinate.longitude;
            //构造折线对象
            BMKPolyline *commonPolyline = [BMKPolyline polylineWithCoordinates:commonPolylineCoords count:2];
            //存入数组中
            [self.distancePolylineArray addObject:commonPolyline];
            //在地图上添加折线对象
            [self.mapView.mapView addOverlay: commonPolyline];
        }
        else
            ann.distanceStr = @"出发点";
        
        
        [self.distanceAnnArray addObject:ann];
        
        // 添加大头针的方法
        [self.mapView.mapView addAnnotation:ann];
    }
    
    
    
    
    
    
    
}

//自定义测距大头针
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    //测距模式的大头针
    if ([annotation isKindOfClass:[PointWithDistanceAnn class]])
    {
        //自制的测距用大头针对象
        PointWithDistanceAnn *ann = (PointWithDistanceAnn *)annotation;
        
        //自制测距用大头针视图
        PointWithDistanceAnnView *annotationView = (PointWithDistanceAnnView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ann"];
        if (annotationView == nil) {
            annotationView = [[PointWithDistanceAnnView alloc] initWithAnnotation:annotation reuseIdentifier:@"ann"];
        }
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        //气泡的偏移量，向下偏移10
//        annotationView.calloutOffset = CGPointMake(0, 5);
        //显示信息赋值
        annotationView.distanceStr = ann.distanceStr;
        annotationView.centerOffset=CGPointMake(0, 0);
        //设置大头针的样式（图片）
        annotationView.image = [UIImage imageNamed:@"point.png"];
        
        return annotationView;
    }
    return nil;
}



- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [UIColor  colorWithRed:255/255.0 green:65/255.0 blue:45/255.0 alpha:1];
        polylineView.strokeColor = [UIColor  colorWithRed:255/255.0 green:65/255.0 blue:45/255.0 alpha:1];
        polylineView.lineWidth = 4.0f;
        return polylineView;
    }
    return nil;
}



//运动计时开始
-(void)beginTiming
{
    if (self.moveTimer)
    {
        [self endTiming];
    }
    
    self.moveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}
//结束计时
-(void)endTiming
{
    [self.moveTimer invalidate];
    self.moveTimer = nil;
}
//计时
-(void)timerAction:(NSTimer *)timer
{
    self.scrollAddV.labeltime.text = [NSString stringWithFormat:@"%0ld:%02ld:%02ld",(long)(self.timeCount/3600)%24,(long)(self.timeCount/60)%60,(long)self.timeCount%60];
    
    self.mapView.moveInfoView.timeLabel.text = self.scrollAddV.labeltime.text;
    
    self.timeCount++;
    
}

//懒加载
-(NSMutableArray *)distanceAnnArray
{
    if (_distanceAnnArray == nil)
    {
        _distanceAnnArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _distanceAnnArray;
}
-(NSMutableArray *)distancePolylineArray
{
    if (_distancePolylineArray == nil)
    {
        _distancePolylineArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _distancePolylineArray;
}

-(NSMutableArray *)roadmapArray
{
    if (_roadmapArray == nil)
    {
        _roadmapArray = [[NSMutableArray alloc]init];
    }
    return _roadmapArray;
}

-(NSMutableArray *)roadmapPolylineArray
{
    if (_roadmapPolylineArray == nil)
    {
        _roadmapPolylineArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _roadmapPolylineArray;
}

-(NSMutableArray *)startAndEndAnnArray
{
    if (_startAndEndAnnArray == nil)
    {
        _startAndEndAnnArray = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _startAndEndAnnArray;
}


@end
