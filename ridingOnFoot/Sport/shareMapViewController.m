//
//  mapViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/22.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "shareMapViewController.h"
#import "tool.h"
#import "userLocationSingleton.h"
#import "sportViewController.h"
#import "MapV.h"
@interface shareMapViewController ()
@property(nonatomic,strong)UITextView * textV;
@end

@implementation shareMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navV=[[UIView alloc] initWithFrame:CGRectMake(0, 0,kscreenWidth,64)];
    self.navV.backgroundColor =[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    [self.view addSubview:self.navV];
    self.backbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backbtn.frame=CGRectMake(10, 22, 40, 40);
    self.backbtn.tintColor=[UIColor whiteColor];
    [self.backbtn setImage:[UIImage imageNamed:@"icon_nav_back@2x.png"] forState:(UIControlStateNormal)];
    [self.backbtn addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navV addSubview:self.backbtn];
    self.navtitle=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-80, 22, 160, 40)];
    
    self.navtitle.textAlignment=NSTextAlignmentCenter;
    self.navtitle.textColor=[UIColor whiteColor];
    [self.navV addSubview:self.navtitle];

    self.navtitle.text=@"推荐随行";
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(10, 70, kscreenWidth-120, 30)];
    
    label1.text=@"位置分享";
    label1.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:label1];
    self.textV =[[UITextView alloc] initWithFrame:CGRectMake(10, 100, kscreenWidth-20, 65)];
    self.textV.layer.borderWidth=1;
    self.textV.layer.borderColor=[UIColor cyanColor].CGColor;
    self.textV.text=[NSString stringWithFormat:@"我在这里，点击查看：\n http://ditu.google.cn/maps?q=%f,%f",[userLocationSingleton shareuserLocationSingleton].userlocation.location.coordinate.latitude,[userLocationSingleton shareuserLocationSingleton].userlocation.location.coordinate.longitude];
    self.textV.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:self.textV];
    UIButton *btn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    btn.frame=CGRectMake(kscreenWidth/2-40, CGRectGetMaxY(self.textV.frame)+10, 80, 30);
    [btn setTitle:@"发送" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    btn.layer.cornerRadius=10;
    btn.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:btn];
}

-(void)backAction{
    NSArray *arr=[UIApplication sharedApplication].delegate.window.subviews;
    MapV *mapv=arr[1];
    mapv.hidden=NO;
    [self dismissViewControllerAnimated:YES completion:^{
      
    }];

}
-(void)btnAction{
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56de35c8e0f55a75a90029f5"
                                      shareText:[NSString stringWithFormat:@"%@",self.textV.text]
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQQ,UMShareToQzone, nil]
                                       delegate:self];
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



@end
