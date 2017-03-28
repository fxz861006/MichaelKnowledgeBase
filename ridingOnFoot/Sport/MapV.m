//
//  MapView.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/15.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "MapV.h"
#import "tool.h"
@implementation MapV
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addAllView];
    }
    return self;

}
-(void)addAllView{
    self.mapView=[[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.mapView.mapType = BMKMapTypeStandard;
    //设置比例尺位置
    self.mapView.showMapScaleBar=YES;
    self.mapView.mapScaleBarPosition=CGPointMake(10, kscreenHeight-64);

    
    [self addSubview:self.mapView];
    self.leftView=[[UIImageView alloc] initWithFrame:CGRectMake(0,kscreenHeight/2-56,20, 80)];
    self.leftView.userInteractionEnabled=YES;
    self.leftView.image=[UIImage imageNamed:@"drag_btn@2x.png"];
    [self addSubview:self.leftView];
    self.moveInfoView=[[MapMoveInfoView alloc] initWithFrame:CGRectMake(20, 74, kscreenWidth-40, 44)];
    [self addSubview:self.moveInfoView];
    UIView *naV=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, 64)];
    naV.backgroundColor =[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    [self addSubview:naV];
//    self.loadBookButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
//    self.loadBookButton.frame=CGRectMake(kscreenWidth-100, 22, 40, 40);
//    [self.loadBookButton setBackgroundImage:[UIImage imageNamed:@"xingzhe_nav_routebook@2x.png"] forState:(UIControlStateNormal)];
//    self.loadBookButton.tag=1001;
//    self.loadBookButton.tintColor=[UIColor whiteColor];
//    [naV addSubview:self.loadBookButton];
    self.shareButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.shareButton.frame=CGRectMake(kscreenWidth-50, 22, 40, 40);
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"xingzhe_nav_share@2x.png"] forState:(UIControlStateNormal)];
    self.shareButton.tag=1002;
    self.shareButton.tintColor=[UIColor whiteColor];
//    [naV addSubview:self.shareButton];
    
    self.mapTypeButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.mapTypeButton.frame=CGRectMake(kscreenWidth-60,CGRectGetMaxY(self.moveInfoView.frame)+15, 40, 40);
    self.mapTypeButton.tag=1003;
    self.mapTypeButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.mapTypeButton.layer.borderWidth=0.5;
    self.mapTypeButton.backgroundColor=[UIColor whiteColor];
    [self.mapTypeButton setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_sat_off@2x.png"] forState:(UIControlStateNormal)];
//     setbackgroundImage:[UIImage imageNamed:@"xingzhe_map_sat_off@2x.png"] forState:(UIControlStateNormal)];
//    self.mapTypeButton.tintColor=[UIColor darkGrayColor];
    [self addSubview:self.mapTypeButton];
    
//    self.mapAltitudeButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
//    self.mapAltitudeButton.frame=CGRectMake(kscreenWidth-60,CGRectGetMaxY(self.mapTypeButton.frame)+15, 40, 40);
//    self.mapAltitudeButton.tag=1004;
//    self.mapAltitudeButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    self.mapAltitudeButton.layer.borderWidth=0.5;
//    self.mapAltitudeButton.backgroundColor=[UIColor whiteColor];
//    [self.mapAltitudeButton setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_altitude_off@2x.png"] forState:(UIControlStateNormal)];
////    self.mapAltitudeButton.tintColor=[UIColor darkGrayColor];
//    [self addSubview:self.mapAltitudeButton];
    
    self.mapDistanceButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.mapDistanceButton.frame=CGRectMake(kscreenWidth-60,CGRectGetMaxY(self.self.mapTypeButton.frame)+15, 40, 40);
    self.mapDistanceButton.tag=1005;
    self.mapDistanceButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.mapDistanceButton.layer.borderWidth=0.5;
    self.mapDistanceButton.backgroundColor=[UIColor whiteColor];
    [self.mapDistanceButton setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_length_off@2x.png"] forState:(UIControlStateNormal)];
//    self.mapDistanceButton.tintColor=[UIColor darkGrayColor];
    [self addSubview:self.mapDistanceButton];
    
    self.mapZoomOutButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.mapZoomOutButton.frame=CGRectMake(kscreenWidth-60,kscreenHeight-55, 40 , 50);
    self.mapZoomOutButton.tag=1008;
    self.mapZoomOutButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.mapZoomOutButton.layer.borderWidth=0.5;
    self.mapZoomOutButton.backgroundColor=[UIColor whiteColor];
    [self.mapZoomOutButton setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_zoom_out@2x.png"] forState:(UIControlStateNormal)];
//    self.mapZoomOutButton.tintColor=[UIColor darkGrayColor];
    [self addSubview:self.mapZoomOutButton];

    self.mapZoomInButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.mapZoomInButton.frame=CGRectMake(kscreenWidth-60,CGRectGetMinY(self.mapZoomOutButton.frame)-50, 40, 50);
    self.mapZoomInButton.tag=1007;
    self.mapZoomInButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.mapZoomInButton.layer.borderWidth=0.5;
    self.mapZoomInButton.backgroundColor=[UIColor whiteColor];
    [self.mapZoomInButton setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_zoom_in@2x.png"] forState:(UIControlStateNormal)];
//    self.mapZoomInButton.tintColor=[UIColor darkGrayColor];
    [self addSubview:self.mapZoomInButton];
    self.mapDirectionButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.mapDirectionButton.frame=CGRectMake(kscreenWidth-60,CGRectGetMinY(self.mapZoomInButton.frame)-55, 40, 40);
    self.mapDirectionButton.tag=1006;
    self.mapDirectionButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.mapDirectionButton.layer.borderWidth=0.5;
    self.mapDirectionButton.backgroundColor=[UIColor whiteColor];
    [self.mapDirectionButton setBackgroundImage:[UIImage imageNamed:@"xingzhe_map_location_1@2x.png"] forState:(UIControlStateNormal)];
//    self.mapDirectionButton.tintColor=[UIColor darkGrayColor];
    [self addSubview:self.mapDirectionButton];
    //头视图的信息提示label
    self.naVleftLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 22, kscreenWidth-60, 40)];
    self.naVleftLabel.text=@"正在定位...";
    self.naVleftLabel.textColor=[UIColor whiteColor];
//    self.naVleftLabel.hidden=YES;
    [naV addSubview:self.naVleftLabel];
    self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth/4, 60)];
    self.promptLabel.center = CGPointMake(kscreenWidth/2, [UIScreen mainScreen].bounds.size.height*0.8);
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.layer.masksToBounds = YES;
    self.promptLabel.layer.cornerRadius=10;
    self.promptLabel.layer.borderWidth = 10;
    self.promptLabel.layer.borderColor = [UIColor clearColor].CGColor;
    self.promptLabel.backgroundColor = [UIColor blackColor];
    self.promptLabel.textColor = [UIColor whiteColor];
    
    
    
    
}

@end
