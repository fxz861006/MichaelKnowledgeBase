//
//  MapView.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/15.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "MapMoveInfoView.h"
@interface MapV : UIView
//地图视图
@property(strong,nonatomic)BMKMapView *mapView;
//信息提示label
@property(strong,nonatomic)UILabel *promptLabel;
//用来显示运动信息的视图
@property(strong,nonatomic)MapMoveInfoView *moveInfoView;
//地图样式切换button
@property(strong,nonatomic)UIButton *mapTypeButton;
//获取位置的高度
//@property(strong,nonatomic)UIButton *mapAltitudeButton;
//获取位置的距离
@property(strong,nonatomic)UIButton *mapDistanceButton;
//地图放大Button
@property(strong,nonatomic)UIButton *mapZoomInButton;
//地图缩小Button
@property(strong,nonatomic)UIButton *mapZoomOutButton;
//地图导航模式Button
@property(strong,nonatomic)UIButton *mapDirectionButton;
//用于向左滑动的view
@property(strong,nonatomic)UIImageView *leftView;
//路书button
@property(strong,nonatomic)UIButton *loadBookButton;
//分享Button
@property(strong,nonatomic)UIButton *shareButton;
//导航栏的左侧提示label
@property(strong,nonatomic)UILabel *naVleftLabel;
@end
