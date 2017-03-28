//
//  userInfoViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/19.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "userInfoViewController.h"
#import "tool.h"
#import "DataBase.h"
#import "userinfoTableViewCell.h"
#import <UIImageView+WebCache.h>
@interface userInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSArray *arrAlldata;
@property(nonatomic,strong)UITableView *tableV;
@end

@implementation userInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrAlldata=@[@[@"头像",@"用户名",@"地点"],@[@"性别",@"年龄",@"身高",@"体重"],@[@"手机",@"密码"]];
    self.tableV=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kscreenWidth,kscreenHeight-64) style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.tableV];
    self.tableV.delegate=self;
    self.tableV.dataSource=self;
    self.navtitle.text=@"个人信息修改";
//    UIButton *exitbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
//    exitbtn.frame=CGRectMake( kscreenWidth/2-100,600, 200, 40);
//    [exitbtn setTitle:@"退出" forState:(UIControlStateNormal)];
//    [exitbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    exitbtn.layer.cornerRadius=10;
//    exitbtn.backgroundColor=[UIColor redColor];
//    [exitbtn addTarget:self action:@selector(exitbtnAction) forControlEvents:(UIControlEventTouchUpInside)];
////    self.tableV.
//    [self.tableV addSubview:exitbtn];
     UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
   }
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.arrAlldata.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  [self.arrAlldata[section] count];
}
-(void)viewTapped:(UITapGestureRecognizer*)tap



{
    
    
    
    [self.view endEditing:YES];
    
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    userinfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"infocell_id"];
    if (cell==nil) {
        cell=[[userinfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"infocell_id"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.leftlabel.text=self.arrAlldata[indexPath.section][indexPath.row];
    if (indexPath.section==0&&indexPath.row==0) {
        cell.righttextfield.hidden=YES;
        UIImageView *imageV=[[UIImageView alloc] initWithFrame:CGRectMake(kscreenWidth-50, 10, 40, 40)];
        if (self.model.imgpic==nil||[self.model.imgpic  isEqual:@"(null)"]) {
            imageV.image=[UIImage imageNamed:@"2E71EB036C835965A0C1B027F48F61EC.jpg"];
            
        }else {
        [imageV  sd_setImageWithURL:[NSURL URLWithString:self.model.imgpic]];
        }
        [cell.contentView addSubview:imageV];
        
    }
    
    cell.leftlabel.font=[UIFont systemFontOfSize:14];
    cell.righttextfield.textColor=[UIColor lightGrayColor];
      cell.righttextfield.font=[UIFont systemFontOfSize:14];
    if (indexPath.section==0&&indexPath.row==1) {
        cell.righttextfield.delegate=self;
        cell.righttextfield.tag=1010;
        cell.righttextfield.enabled=NO;
        cell.righttextfield.placeholder=nil;
        cell.righttextfield.text=self.model.username;
    }
    if (indexPath.section==0&&indexPath.row==2) {
        cell.righttextfield.delegate=self;
        cell.righttextfield.tag=1011;
        if ([self.model.address isEqual:@"(null)"]) {
//            cell.righttextfield.text=@"编辑";
        }else{
        cell.righttextfield.text=self.model.address;
        }
        }
    if (indexPath.section==1&&indexPath.row==0) {
        cell.righttextfield.delegate=self;
        cell.righttextfield.tag=1012;
        if ([self.model.sex isEqual:@"(null)"]) {
        
        }else{
        cell.righttextfield.text=self.model.sex;
        }
        }
    if (indexPath.section==1&&indexPath.row==1) {
        cell.righttextfield.delegate=self;
        cell.righttextfield.tag=1013;
        if ([self.model.age  isEqual:@"(null)"]) {
           
        }else{
        cell.righttextfield.text=self.model.age;
    
        }}
    if (indexPath.section==1&&indexPath.row==2) {
        cell.righttextfield.delegate=self;
        cell.righttextfield.tag=1014;
        if ([self.model.height  isEqual:@"(null)"]) {
        
        }else{
        cell.righttextfield.text=self.model.height;
        }}
    if (indexPath.section==1&&indexPath.row==3) {
        cell.righttextfield.delegate=self;
        cell.righttextfield.tag=1015;
        if ([self.model.weight  isEqual:@"(null)"]) {
            
        }else{
        cell.righttextfield.text=self.model.weight;
        }}
    if (indexPath.section==2&&indexPath.row==0) {
        cell.righttextfield.delegate=self;
        cell.righttextfield.tag=1016;
        if ([self.model.phone isEqual:@"(null)"]) {
              
        }else{
        cell.righttextfield.text=self.model.phone;
        }}
    if (indexPath.section==2&&indexPath.row==1) {
        cell.righttextfield.delegate=self;
        cell.righttextfield.tag=1017;
       
            cell.righttextfield.secureTextEntry=YES;
        cell.righttextfield.text=self.model.email;
        }
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.00001;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 70;
    }
    return 0.00001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section==2) {
        UIView *footview =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, 70)];
        UIButton *exitbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
        exitbtn.frame=CGRectMake( kscreenWidth/2+20,20, 80, 40);
        [exitbtn setTitle:@"退出" forState:(UIControlStateNormal)];
        [exitbtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        exitbtn.layer.cornerRadius=10;
        exitbtn.backgroundColor=[UIColor redColor];
        [exitbtn addTarget:self action:@selector(exitbtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        UIButton *xiugaibtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
        [xiugaibtn setTitle:@"修改" forState:(UIControlStateNormal)];
        xiugaibtn.frame=CGRectMake( kscreenWidth/2-100,20, 80, 40);
        
        [xiugaibtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        xiugaibtn.layer.cornerRadius=10;
        xiugaibtn.backgroundColor=[UIColor purpleColor];
        [xiugaibtn addTarget:self action:@selector(xiugaibtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        //    self.tableV.
        [footview addSubview:xiugaibtn];
        [footview addSubview:exitbtn];
        return footview;
    }
    return nil;
}
-(void)exitbtnAction{
    
   
    NSString *islogin=@"退出";
    NSString *filepath=file;
    [islogin writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",filepath);
 [self.navigationController popToRootViewControllerAnimated:YES];


}

-(void)xiugaibtnAction{
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
    [self  presentViewController:alert animated:YES completion:^{
        [[DataBase startDB] openDB];
        [[DataBase startDB] updateuser:self.model];
        [[DataBase startDB] closeDB];

        sleep(2);
        alert.modalTransitionStyle=NO;
        [alert dismissViewControllerAnimated:YES completion:^{
           
        }];
        
        
    }];

    
    
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        
        case 1011:{
            self.model.address=textField.text;
            break;}
        case 1012:{
            self.model.sex=textField.text;
            break;}
        case 1013:{
            self.model.age=textField.text;
            break;}
        case 1014:{
            self.model.height=textField.text;
            break;}
        case 1015:{
            self.model.weight=textField.text;
            break;}
        case 1016:{
            self.model.phone=textField.text;
            break;}
        case 1017:{
            self.model.email=textField.text;
            break;}
        
        default:
            break;
    }


}
-(NSArray *)arrAlldata{
    if (!_arrAlldata) {
        _arrAlldata=[[NSArray alloc] init];
        
    }
    return _arrAlldata;


}


@end
