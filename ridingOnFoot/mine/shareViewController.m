//
//  shareViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "shareViewController.h"
#import "tool.h"
#import "userLocationSingleton.h"
#import <MessageUI/MessageUI.h>
@interface shareViewController ()<MFMessageComposeViewControllerDelegate>
@property(nonatomic,strong)UITextView * textV;
@end

@implementation shareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [btn setTitle:@"短信发送" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    btn.layer.cornerRadius=10;
    btn.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:btn];
}

-(void)btnAction{
    
    //    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://10000"]];
    [self showMessageView:[NSArray arrayWithObjects:@" ", nil] title:@"test" body:[NSString stringWithFormat:@"%@",self.textV.text]];
    
    
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertController *alert=[UIAlertController  alertControllerWithTitle:@"提示" message:@"该设备不支持短信功能" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action=[UIAlertAction  actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alert addAction:action];
        [self  presentViewController:alert animated:YES completion:^{ }];    }
}

@end
