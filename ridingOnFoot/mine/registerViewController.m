//
//  registerViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/19.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "registerViewController.h"
#import "imagetextView.h"
#import "tool.h"
#import "DataBase.h"
#import "contactmodel.h"
#import "userLocationSingleton.h"
@interface registerViewController ()
@property(nonatomic,strong)imagetextView *phoneImgTV;
@property(nonatomic,strong)imagetextView *pwdImgTV;
@property(nonatomic,strong)imagetextView *pwdqueImgTV;
@property(nonatomic,strong)UIScrollView *scrollV;
@property(nonatomic,strong)UITextField *program1;
@property(nonatomic,strong)UITextField *program2;
@property(nonatomic,assign)BOOL   isequ;
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navtitle.text=@"注册";
    self.scrollV=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kscreenWidth, kscreenHeight)];
    self.scrollV.contentSize=CGSizeMake(kscreenWidth, kscreenHeight*1.2);
    self.scrollV.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.9];
    [self.view addSubview:self.scrollV];
 
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.scrollV addGestureRecognizer:tap];
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
    self.pwdqueImgTV=[[imagetextView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.pwdImgTV.frame), kscreenWidth, 50)];
    self.pwdqueImgTV.backgroundColor=[UIColor whiteColor];
    self.pwdqueImgTV.imageV.image=[UIImage imageNamed:@"login_lock@3x.png"];
    self.pwdqueImgTV.textField.placeholder=@"请确认密码";
    self.pwdqueImgTV.textField.secureTextEntry=YES;
    [self.scrollV addSubview:self.pwdqueImgTV];
    UIView *HV1=[[UIView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.pwdImgTV.frame), kscreenWidth-50, 1)];
    HV1.backgroundColor=[UIColor lightGrayColor];
    HV1.alpha=0.5;
    [self.scrollV addSubview:HV1];
    UILabel *labelprogram1=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.pwdqueImgTV.frame)+10, kscreenWidth-20, 40)];
   labelprogram1.text=@"你最喜爱的动物是：";
    [self.scrollV addSubview:labelprogram1];
    self.program1=[[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(labelprogram1.frame)+10, kscreenWidth-20, 40)];
    self.program1.layer.cornerRadius=5;
    self.program1.layer.masksToBounds=YES;
    self.program1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.program1.layer.borderWidth=0.5;
    [self.scrollV addSubview:self.program1];
    UILabel *labelprogram2=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.program1.frame)+10, kscreenWidth-20, 40)];
    labelprogram2.text=@"你最崇拜的人是：";
    [self.scrollV addSubview:labelprogram2];
    self.program2=[[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(labelprogram2.frame)+10, kscreenWidth-20, 40)];
    self.program2.layer.cornerRadius=5;
    self.program2.layer.masksToBounds=YES;
    self.program2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.program2.layer.borderWidth=0.5;
    [self.scrollV addSubview:self.program2];
    UIButton *registerbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    registerbtn.frame=CGRectMake(20, CGRectGetMaxY(self.program2.frame)+20, kscreenWidth-40, 40);
    registerbtn.layer.cornerRadius=10;
    registerbtn.layer.masksToBounds=YES;
    [registerbtn setTitle:@"注册" forState:(UIControlStateNormal)];
    [registerbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [registerbtn addTarget:self action:@selector(registerbtnaction) forControlEvents:(UIControlEventTouchUpInside)];
    registerbtn.backgroundColor=[UIColor lightGrayColor];
    [self.scrollV addSubview:registerbtn];

}
-(void)registerbtnaction{
    
    if ([userLocationSingleton shareuserLocationSingleton].isnetwork==YES) {
 
     self.isequ=NO;
    if (self.phoneImgTV.textField.text.length==0) {
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"用户名不能为空" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertC animated:YES completion:^{
            sleep(2);
            self.isequ=YES;
            alertC.modalTransitionStyle=NO;
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];

    }else if(self.pwdImgTV.textField.text.length==0) {
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"密码不能为空" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertC animated:YES completion:^{
            sleep(2);
            self.isequ=YES;
            alertC.modalTransitionStyle=NO;
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }else if(self.pwdqueImgTV.textField.text.length==0) {
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"请输入确认密码" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertC animated:YES completion:^{
            sleep(2);
            self.isequ=YES;
            alertC.modalTransitionStyle=NO;
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }else if(![self.pwdqueImgTV.textField.text isEqualToString:self.pwdImgTV.textField.text]) {
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"两次密码输入不一致" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertC animated:YES completion:^{
            sleep(2);
            self.isequ=YES;
            alertC.modalTransitionStyle=NO;
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }else if(self.program1.text.length==0||self.program2.text.length==0) {
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"提示问题不能为空" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertC animated:YES completion:^{
            sleep(2);
            self.isequ=YES;
            alertC.modalTransitionStyle=NO;
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }else{
    [[DataBase startDB] openDB];
    NSMutableArray *arr=[[DataBase startDB] selectaccount];
    [[DataBase startDB] closeDB];
   
    for (contactmodel *model in arr) {
        if ([model.username isEqualToString:self.phoneImgTV.textField.text]) {
            
            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"用户名已存在" preferredStyle:(UIAlertControllerStyleAlert)];
            [self presentViewController:alertC animated:YES completion:^{
                sleep(2);
                self.isequ=YES;
                alertC.modalTransitionStyle=NO;
                [alertC dismissViewControllerAnimated:YES completion:nil];
            }];
            
            
        }}
    }
    if (self.isequ==NO) {
        
            
            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"注册成功" preferredStyle:(UIAlertControllerStyleAlert)];
            [self presentViewController:alertC animated:YES completion:^{
                contactmodel *model=[[contactmodel alloc] init];
                model.username=[NSString stringWithFormat:@"%@",self.phoneImgTV.textField.text];
                model.pwd=[NSString stringWithFormat:@"%@",self.pwdImgTV.textField.text];
                model.problem1=[NSString stringWithFormat:@"%@",self.program1.text];
                model.problem2=[NSString stringWithFormat:@"%@",self.program2.text];
                usermodel *umodel=[[usermodel alloc] init];
                
                umodel.username=model.username;
                [[DataBase startDB] openDB];
                [[DataBase startDB] createuserTable:model.username];
                [[DataBase startDB] createsportTable:model.username];
                [[DataBase startDB]  createFindActiveTable:model.username];
                [[DataBase startDB] addcontact:model];
                [[DataBase startDB] adduser:umodel];
                [[DataBase startDB] closeDB];
                [[NSUserDefaults standardUserDefaults] setObject:model.username forKey:@"username"];
                
                sleep(2);
                
                
                alertC.modalTransitionStyle=NO;
                [alertC dismissViewControllerAnimated:YES completion:^{
                   
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

-(void)tapAction{
    
    [self.scrollV endEditing:YES];
    
}
@end
