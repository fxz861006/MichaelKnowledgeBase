//
//  loginViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/19.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "loginViewController.h"
#import "registerViewController.h"
#import "imagetextView.h"
#import "UMSocial.h"
#import "tool.h"
#import "DataBase.h"
#import "contactmodel.h"
#import "userLocationSingleton.h"
#import "RetrievepwdViewController.h"
@interface loginViewController ()
@property(nonatomic,strong)imagetextView *phoneImgTV;
@property(nonatomic,strong)imagetextView *pwdImgTV;
@property(nonatomic,strong)UIScrollView *scrollV;
@property(nonatomic,strong)contactmodel *conmodel;
@property(nonatomic,assign)BOOL   isequ;
@property(nonatomic,strong)UITextField *usertextf;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.scrollV=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kscreenWidth, kscreenHeight)];
    self.scrollV.contentSize=CGSizeMake(kscreenWidth, kscreenHeight*1.2);
     self.scrollV.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.9];
    [self.view addSubview:self.scrollV];
    self.navtitle.text=@"登录";
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.scrollV addGestureRecognizer:tap];
    UIButton *registerbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    registerbtn.frame=CGRectMake(kscreenWidth-50, 22, 40, 40);
    [registerbtn setTitle:@"注册" forState:(UIControlStateNormal)];
    [registerbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [registerbtn addTarget:self action:@selector(registerbtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navV addSubview:registerbtn];
    UIImageView *imageV=[[UIImageView alloc] initWithFrame:CGRectMake(kscreenWidth/2-40, 30, 80, 70)];
    imageV.image=[UIImage imageNamed:@"suixing2.png"];
    [self.scrollV  addSubview:imageV];
    self.phoneImgTV=[[imagetextView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(imageV.frame)+10, kscreenWidth, 50)];
    self.phoneImgTV.backgroundColor=[UIColor whiteColor];
    self.phoneImgTV.imageV.image=[UIImage imageNamed:@"xingzhe_v1_profile_photo@2x.png"];
    self.phoneImgTV.textField.placeholder=@"请输入用户名";
    [self.scrollV addSubview:self.phoneImgTV];
        self.pwdImgTV=[[imagetextView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.phoneImgTV.frame), kscreenWidth, 50)];
    self.pwdImgTV.backgroundColor=[UIColor whiteColor];
    self.pwdImgTV.imageV.image=[UIImage imageNamed:@"login_lock@3x.png"];
    self.pwdImgTV.textField.placeholder=@"请输入密码";
    self.pwdImgTV.textField.secureTextEntry=YES;
    [self.scrollV addSubview:self.pwdImgTV];
    UIView *HV=[[UIView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.phoneImgTV.frame), kscreenWidth-50, 1)];
    HV.backgroundColor=[UIColor lightGrayColor];
    HV.alpha=0.5;
    [self.scrollV addSubview:HV];
    UIButton *loginbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    loginbtn.frame=CGRectMake(20, CGRectGetMaxY(self.pwdImgTV.frame)+20, kscreenWidth-40, 40);
    loginbtn.layer.cornerRadius=10;
    loginbtn.layer.masksToBounds=YES;
    [loginbtn setTitle:@"登录" forState:(UIControlStateNormal)];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [loginbtn addTarget:self action:@selector(loginbtnaction) forControlEvents:(UIControlEventTouchUpInside)];
    loginbtn.backgroundColor=[UIColor lightGrayColor];
    [self.scrollV addSubview:loginbtn];
    UILabel *findpwd=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-30, CGRectGetMaxY(loginbtn.frame)+20 , 60, 30)];
    findpwd.textAlignment=NSTextAlignmentCenter;
    findpwd.text=@"找回密码";
    findpwd.userInteractionEnabled=YES;
    findpwd.font=[UIFont systemFontOfSize:14];
    findpwd.textColor=[UIColor blueColor];
    UITapGestureRecognizer *tapfindpwd=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapfindpwdAction)];
    [findpwd addGestureRecognizer:tapfindpwd];
    [self.scrollV addSubview:findpwd];
    
    UIView *HV2=[[UIView alloc] initWithFrame:CGRectMake(20, kscreenHeight-200, kscreenWidth/2-80, 1)];
    HV2.backgroundColor=[UIColor lightGrayColor];
    [self.scrollV addSubview:HV2];
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-50, kscreenHeight-215, 100, 30)];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.text=@"选择登录方式";
    label1.font=[UIFont systemFontOfSize:14];
    label1.textColor=[UIColor lightGrayColor];
    [self.scrollV addSubview:label1];
    UIView *HV3=[[UIView alloc] initWithFrame:CGRectMake(kscreenWidth/2+60, kscreenHeight-200, kscreenWidth/2-80, 1)];
    HV3.backgroundColor=[UIColor lightGrayColor];
    [self.scrollV addSubview:HV3];
    UIButton *qqbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    [qqbtn setBackgroundImage:[UIImage imageNamed:@"login_qq@3x.png"] forState:(UIControlStateNormal)];
    qqbtn.frame=CGRectMake(kscreenWidth/2-120, CGRectGetMaxY(HV3.frame)+20, 40, 40);
    [qqbtn addTarget:self action:@selector(qqbtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollV addSubview:qqbtn];
    UILabel *qqlabel=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-120, CGRectGetMaxY(qqbtn.frame), 40, 20)];
    qqlabel.font=[UIFont systemFontOfSize:14];
    qqlabel.textAlignment=NSTextAlignmentCenter;
    qqlabel.text=@"QQ";
    qqlabel.textColor=[UIColor lightGrayColor];
    [self.scrollV addSubview:qqlabel];
    UIButton *sinabtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    [sinabtn setBackgroundImage:[UIImage imageNamed:@"login_microblog@3x.png"] forState:(UIControlStateNormal)];
    sinabtn.frame=CGRectMake(kscreenWidth/2-20, CGRectGetMaxY(HV3.frame)+20, 40, 40);
    [sinabtn addTarget:self action:@selector(sinabtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollV addSubview:sinabtn];
    UILabel *sinalabel=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-20, CGRectGetMaxY(sinabtn.frame), 40, 20)];
    sinalabel.font=[UIFont systemFontOfSize:14];
    sinalabel.textAlignment=NSTextAlignmentCenter;
    sinalabel.text=@"新浪";
    sinalabel.textColor=[UIColor lightGrayColor];
    [self.scrollV addSubview:sinalabel];
    UIButton *wechatbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    [wechatbtn setBackgroundImage:[UIImage imageNamed:@"login_wechat@3x.png"] forState:(UIControlStateNormal)];
    wechatbtn.frame=CGRectMake(kscreenWidth/2+80, CGRectGetMaxY(HV3.frame)+20, 40, 40);
    [wechatbtn addTarget:self action:@selector(wechatbtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollV addSubview:wechatbtn];
    UILabel *wechatlabel=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2+80, CGRectGetMaxY(wechatbtn.frame), 40, 20)];
    wechatlabel.font=[UIFont systemFontOfSize:14];
    wechatlabel.textAlignment=NSTextAlignmentCenter;
    wechatlabel.text=@"微信";
    wechatlabel.textColor=[UIColor lightGrayColor];
    [self.scrollV addSubview:wechatlabel];
    
}
-(void)tapfindpwdAction{
    RetrievepwdViewController *retrievePVC=[[RetrievepwdViewController alloc] init];
    retrievePVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:retrievePVC animated:YES];


}
-(void)registerbtnAction{
    registerViewController *registerVC=[[registerViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];


}
-(void)tapAction{

    [self.scrollV endEditing:YES];

}
-(void)loginbtnaction{
    if ([userLocationSingleton shareuserLocationSingleton].isnetwork==YES) {
        
   
    [[DataBase startDB] openDB];
    NSMutableArray *arr=[[DataBase startDB] selectaccount];
    [[DataBase startDB] closeDB];
    
    self.isequ=NO;
    for (contactmodel *model in arr) {
        if ([model.username isEqualToString:self.phoneImgTV.textField.text]&&[model.pwd isEqualToString:self.pwdImgTV.textField.text]) {
            self.isequ=YES;
            [[NSUserDefaults standardUserDefaults] setObject:model.username forKey:@"username"];
     
        }
        
        }
    
        if (self.isequ==NO) {
      
        
            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"用户名或密码错误" preferredStyle:(UIAlertControllerStyleAlert)];
            [self presentViewController:alertC animated:YES completion:^{
                
                sleep(2);
                alertC.modalTransitionStyle=NO;
                [alertC dismissViewControllerAnimated:YES completion:nil];
                
            }];

       
        
        }else{
        
        
            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"登录成功" preferredStyle:(UIAlertControllerStyleAlert)];
            [self presentViewController:alertC animated:YES completion:^{
//                NSString *islogin=@"登录";
//                NSString *filepath=file;
//                [islogin writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
//                [[NSUserDefaults standardUserDefaults] setValue:modelequ.username forKey:@"username"];
                sleep(2);
                
                alertC.modalTransitionStyle=NO;
                [alertC dismissViewControllerAnimated:YES completion:^{
                    NSString *islogin=@"登录";
                    NSString *filepath=file;
                    [islogin writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }];
        
        }
    }else{
    
    
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"请先打开网络连接" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertC animated:YES completion:^{
            
            sleep(2);
            alertC.modalTransitionStyle=NO;
            [alertC dismissViewControllerAnimated:YES completion:nil];
            
        }];
    
    
    
    }
    
    


}


-(void)qqbtnAction{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            [self loginAction:snsAccount.usid sna:@"qq"  img:snsAccount.iconURL];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});

}
-(void)sinabtnAction{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            [self loginAction:snsAccount.usid sna:@"sina" img:snsAccount.iconURL];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
    
    //解除授权2979774015
    //    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//    NSLog(@"response is %@",response);
//}];

}
-(void)wechatbtnAction{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            [self loginAction:snsAccount.usid sna:@"wechat" img:snsAccount.iconURL];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }
        
    });

}

-(void)loginAction:(NSString *)usid sna:(NSString *)sna img:(NSString *)imgpic{

    [[DataBase startDB] openDB];
    NSMutableArray *arr=[[DataBase startDB] selectaccount];
    [[DataBase startDB] closeDB];
    //是否是登陆状态
//    NSString*filepath=file;
//    //          [arr  writeToFile:nemtemp atomically:YES];
//    NSString *str=[NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
//    if ([str isEqualToString:@"登录"]) {
//        for (contactmodel *model in arr) {
//            if ([model.username isEqualToString:[userLocationSingleton shareuserLocationSingleton].model.username]) {
//                self.conmodel=model;
//                return ;
//            }
//        }
//        if ([[self.conmodel valueForKey:sna] isEqualToString:usid]) {
//            
//        }else{
//            [self.conmodel setValue:usid forKey:sna];
//            [[DataBase startDB] openDB];
//            [[DataBase startDB] updatecontact:self.conmodel];
//            [[DataBase startDB] closeDB];
//        }
//    }
    //不是登录状态
//    if ([str isEqualToString:@"退出"]) {
    
        int i=0;
        for (contactmodel *model in arr) {
            NSString *userac=[model valueForKey:sna];
            if ([userac isEqualToString:usid]) {
                i=1;
               [[NSUserDefaults standardUserDefaults] setObject:model.username forKey:@"username"];
            }}
        if (i==0){
            contactmodel *model=[[contactmodel alloc] init];
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"用户名(不可更改)" message:@"\n" preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.placeholder = @"请输入用户名";
                textField.secureTextEntry = NO;
            }];
            UIAlertAction *action=[UIAlertAction  actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                self.usertextf = alert.textFields.firstObject;
                if (self.usertextf.text.length==0) {
                    
                    [self  presentViewController:alert animated:YES completion:^{
                        
                        
                    }];
                   
                }else{
                    model.username = self.usertextf.text;
                    model.qq=usid;
                    usermodel *umodel=[[usermodel alloc] init];
                    umodel.imgpic=imgpic;
                    umodel.username=model.username;
                    [[DataBase startDB] openDB];
                    [[DataBase startDB] createuserTable:model.username];
                    [[DataBase startDB] createsportTable:model.username];
                    [[DataBase startDB]  createFindActiveTable:model.username];
                    [[DataBase startDB] addcontact:model];
                    [[DataBase startDB] adduser:umodel];
                    [[DataBase startDB] closeDB];
                    [[NSUserDefaults standardUserDefaults] setObject:model.username forKey:@"username"];
//                    [self.navigationController popToRootViewControllerAnimated:YES];
                    NSString *islogin=@"登录";
                                    NSString *filepath=file;
                                    [islogin writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                                    NSLog(@"%@",filepath);
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                
//
            }];
            [alert addAction:action];
            [self  presentViewController:alert animated:YES completion:^{
                
            
            }];
        }
    if(i==1){
            NSString *islogin=@"登录";
            NSString *filepath=file;
            [islogin writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"%@",filepath);
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        }
    
    


    



}
@end
