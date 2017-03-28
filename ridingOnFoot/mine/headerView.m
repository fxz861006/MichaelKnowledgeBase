//
//  headerView.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/19.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "headerView.h"
#import "tool.h"
@implementation headerView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addAllView];
    }

    return self;
 
}
-(void)addAllView{
    self.headerimageV=[[UIImageView alloc] initWithFrame:CGRectMake(kscreenWidth/2-30,30, 60, 60)];
    self.headerimageV.image=[UIImage imageNamed:@"2E71EB036C835965A0C1B027F48F61EC.jpg"];
    self.headerimageV.layer.cornerRadius=30;
    self.headerimageV.layer.masksToBounds=YES;
    [self addSubview:self.headerimageV];
    self.headerminimageV=[[UIImageView alloc] initWithFrame:CGRectMake(kscreenWidth/2+15,70, 14, 14)];
    self.headerminimageV.image=[UIImage imageNamed:@"account_modify_button@2x.png"];
    self.headerminimageV.layer.cornerRadius=7;
    self.headerminimageV.layer.masksToBounds=YES;
    self.headerminimageV.layer.borderWidth=1;
    self.headerminimageV.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self addSubview:self.headerminimageV];
    self.username=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-100,CGRectGetMaxY(self.headerimageV.frame)+10, 200, 30)];
    self.username.textAlignment=NSTextAlignmentCenter;
    self.username.font=[UIFont systemFontOfSize:14];
//    self.username.text=@"asgasdSDDDSFSG";
    self.username.textColor=[UIColor whiteColor];
    [self addSubview:self.username];
    self.imageloctionV=[[UIImageView alloc] initWithFrame:CGRectMake(kscreenWidth/2-50,CGRectGetMaxY(self.username.frame)+2.5 , 15, 15)];
    self.imageloctionV.image=[UIImage imageNamed:@"locationicon_white.png"];
    [self addSubview:self.imageloctionV];

    self.loctionLabel=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-40, CGRectGetMaxY(self.username.frame), 80, 20)];
    self.loctionLabel.textAlignment=NSTextAlignmentCenter;
    self.loctionLabel.font=[UIFont systemFontOfSize:12];
//    self.loctionLabel.text=@"北京市";
    self.loctionLabel.textColor=[UIColor whiteColor];
    [self addSubview:self.loctionLabel];
    UIView * Hview=[[UIView alloc] initWithFrame:CGRectMake(kscreenWidth/2-100, CGRectGetMaxY(self.loctionLabel.frame)+10, 200, 1)];
    Hview.backgroundColor=[UIColor whiteColor];
    Hview.alpha=0.5;
    [self addSubview:Hview];
    UIImageView *imgV1=[[UIImageView alloc] initWithFrame:CGRectMake(kscreenWidth/2-40, CGRectGetMaxY(Hview.frame)+15, 10, 10)];
    imgV1.image=[UIImage imageNamed:@"Photosharing_distance.png"];
    
    [self addSubview:imgV1];
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-30, CGRectGetMaxY(Hview.frame)+9, 70, 20)];
    label1.text=@"总距离km";
    label1.textAlignment=NSTextAlignmentCenter;
    label1.textColor=[UIColor whiteColor];
    label1.font=[UIFont systemFontOfSize:12];
    [self addSubview:label1];
    self.totleDistancelabel=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-100, CGRectGetMaxY(label1.frame), 200, 40)];
    self.totleDistancelabel.textColor=[UIColor whiteColor];
    self.totleDistancelabel.textAlignment=NSTextAlignmentCenter;
    self.totleDistancelabel.font=[UIFont systemFontOfSize:30];
    self.totleDistancelabel.text=@"0.00";
    [self addSubview:self.totleDistancelabel];
    
    
    
}

@end
