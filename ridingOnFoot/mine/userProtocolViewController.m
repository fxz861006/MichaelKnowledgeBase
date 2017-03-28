//
//  userProtocolViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "userProtocolViewController.h"
#import "tool.h"
@interface userProtocolViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *web;
@end

@implementation userProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *navV=[[UIView alloc] initWithFrame:CGRectMake(0, 0,kscreenWidth,64)];
    navV.backgroundColor =[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    [self.view addSubview:navV];
    UIButton *backbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    backbtn.frame=CGRectMake(10, 27, 30, 30);
    backbtn.tintColor=[UIColor whiteColor];
    [backbtn setImage:[UIImage imageNamed:@"icon_nav_back@2x.png"] forState:(UIControlStateNormal)];
    [backbtn addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [navV addSubview:backbtn];
    UILabel *navtitle=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-80, 22, 160, 40)];
    navtitle.text=@"使用帮助";
    navtitle.textAlignment=NSTextAlignmentCenter;
    navtitle.textColor=[UIColor whiteColor];
    [navV addSubview:navtitle];
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(10,64, kscreenWidth-20,kscreenHeight-64)];
    self.web.backgroundColor=[UIColor clearColor];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.web loadHTMLString:htmlCont baseURL:nil];
    self.web.delegate=self;
    [self.view addSubview:self.web];
    self.web.scalesPageToFit = YES;
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"];//修改百分比即可
}
-(void)backAction{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}
@end
