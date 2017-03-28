//
//  recommendedViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "recommendedViewController.h"
#import "tool.h"
#import "UMSocial.h"
@interface recommendedViewController ()<UMSocialUIDelegate>
@property(nonatomic,strong)UITextView * textV;
@end

@implementation recommendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navtitle.text=@"推荐随行";
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 70, kscreenWidth-120, 30)];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.text=@"欢迎推荐随行给认识的朋友😊";
    label1.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:label1];
    self.textV =[[UITextView alloc] initWithFrame:CGRectMake(10, 100, kscreenWidth-20, 65)];
    self.textV.layer.borderWidth=1;
    self.textV.layer.borderColor=[UIColor cyanColor].CGColor;
    self.textV.text=@"我在使用@随行骑行软件，非常不错你也试试吧，进入AppStore搜索“随行”下载";
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
