//
//  helpViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/14.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "helpViewController.h"
#define kscreenWidth  [UIScreen mainScreen].bounds.size.width
#define kscreenHeight  [UIScreen mainScreen].bounds.size.height
//http://cdn.bi-ci.com/webapp/instruction/
@interface helpViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *web;
@end

@implementation helpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navtitle.text=@"使用帮助";
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0,64, kscreenWidth,kscreenHeight-64)];
    self.web.backgroundColor=[UIColor clearColor];
    NSString *urlStr=@"http://cdn.bi-ci.com/webapp/instruction/";
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [self.web loadRequest:request];
    self.web.delegate=self;
    [self.view addSubview:self.web];
    self.web.scalesPageToFit = YES;

}



@end
