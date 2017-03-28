//
//  RetrievepwdViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/28.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "RetrievepwdViewController.h"
#import "imagetextView.h"
#import "tool.h"
#import "DataBase.h"
#import "contactmodel.h"
@interface RetrievepwdViewController ()
@property(nonatomic,strong)imagetextView *phoneImgTV;
@property(nonatomic,strong)UIScrollView *scrollV;
@property(nonatomic,strong)UITextField *program1;
@property(nonatomic,strong)UITextField *program2;
@property(nonatomic,assign)BOOL   isequ;
@property(nonatomic,strong)contactmodel *conmodel;
@end

@implementation RetrievepwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navtitle.text=@"找回密码";
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
    UILabel *labelprogram1=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.phoneImgTV.frame)+10, kscreenWidth-20, 40)];
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
    UIButton *retrievePwdbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    retrievePwdbtn.frame=CGRectMake(20, CGRectGetMaxY(self.program2.frame)+20, kscreenWidth-40, 40);
    retrievePwdbtn.layer.cornerRadius=10;
    retrievePwdbtn.layer.masksToBounds=YES;
    [retrievePwdbtn setTitle:@"找回密码" forState:(UIControlStateNormal)];
    [retrievePwdbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [retrievePwdbtn addTarget:self action:@selector(retrievePwdbtnaction) forControlEvents:(UIControlEventTouchUpInside)];
    retrievePwdbtn.backgroundColor=[UIColor lightGrayColor];
    [self.scrollV addSubview:retrievePwdbtn];
}
-(void)tapAction{
    
    [self.scrollV endEditing:YES];
    
}
-(void)retrievePwdbtnaction{
    [[DataBase startDB] openDB];
    NSMutableArray *arr=[[DataBase startDB] selectaccount];
    [[DataBase startDB] closeDB];
    self.isequ=NO;
    for (contactmodel *model in arr) {
        if ([model.username isEqualToString:self.phoneImgTV.textField.text]){
            self.isequ=YES;
            self.conmodel=model;
        
        }

    }
    
    if (self.isequ==YES) {
        if ([self.conmodel.problem1 isEqualToString:self.program1.text]&&[self.conmodel.problem2 isEqualToString:self.program2.text]) {
           
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"密码为：" message:@"\n" preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.text =self.conmodel.pwd;
                textField.secureTextEntry = NO;
                
            }];
            UIAlertAction *action=[UIAlertAction  actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            UIAlertAction *action2=[UIAlertAction  actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UITextField *userpwd = alert.textFields.firstObject;
                if (userpwd.text.length==0 ) {
                    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"修改失败,密码不能为空" preferredStyle:(UIAlertControllerStyleAlert)];
                    [self presentViewController:alertC animated:YES completion:^{
                        sleep(2);
                      
                        alertC.modalTransitionStyle=NO;
                        [alertC dismissViewControllerAnimated:YES completion:nil];
                    }];
                }else if([userpwd.text isEqualToString:self.conmodel.pwd]){
                    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"修改失败,密码与原密码相同" preferredStyle:(UIAlertControllerStyleAlert)];
                    [self presentViewController:alertC animated:YES completion:^{
                        sleep(2);
                        
                        alertC.modalTransitionStyle=NO;
                        [alertC dismissViewControllerAnimated:YES completion:nil];
                    }];
                
                }else {
                    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"修改成功" preferredStyle:(UIAlertControllerStyleAlert)];
                    [self presentViewController:alertC animated:YES completion:^{
                        
                        self.conmodel.pwd = userpwd.text;
                        NSLog(@"%@,%@",userpwd.text,self.conmodel.pwd);
                        
                        [[DataBase startDB] openDB];
                        [[DataBase startDB] updatecontact:self.conmodel];
                        [[DataBase startDB] closeDB];
                        sleep(2);
                        alertC.modalTransitionStyle=NO;
                        [alertC dismissViewControllerAnimated:YES completion:nil];
                    }];

               
                }
                 }];
            [alert addAction:action];
            [alert addAction:action2];
            [self  presentViewController:alert animated:YES completion:^{ }];

         
        }else{
        
            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"提示问题答案不正确" preferredStyle:(UIAlertControllerStyleAlert)];
            [self presentViewController:alertC animated:YES completion:^{
                sleep(2);
                
                alertC.modalTransitionStyle=NO;
                [alertC dismissViewControllerAnimated:YES completion:nil];
            }];

        
        
        }
        
        
        
    }
    
    
    
    if (self.isequ==NO) {
        
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"用户名不存在" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertC animated:YES completion:^{
            sleep(2);
            
            alertC.modalTransitionStyle=NO;
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];

        
    }
    
    
    
    
    
    
}
@end
