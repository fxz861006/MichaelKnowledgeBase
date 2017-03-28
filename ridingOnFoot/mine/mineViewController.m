//
//  mineViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/11.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "mineViewController.h"
#import "mineTableViewCell.h"
#import "tool.h"
#import "headerView.h"
#import "shareRecommendViewController.h"
#import "userLocationSingleton.h"
#import "loginViewController.h"
#import "userInfoViewController.h"
#import "userProtocolViewController.h"
#import <SDImageCache.h>
#import <MJRefresh.h>
#import "DataBase.h"
#import "usermodel.h"
#import <UIImageView+WebCache.h>
#import "downloadmapviewViewController.h"
#import "historicalRecordViewController.h"
#define minecell @"minecell_id"
static const CGFloat MJDuration = 1.0;
@interface mineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tabelV;
@property(nonatomic,strong)NSMutableArray *arrAllImage;
@property(nonatomic,strong)UIImageView *headerbackimgV;
@property(nonatomic,assign)NSInteger  index;
@property(nonatomic,strong)NSIndexPath *indexpath;
@property(nonatomic,strong)headerView *hearderview;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)usermodel *model;
@property(nonatomic,strong)NSString *islogin;
@end

@implementation mineViewController

-(void)viewWillAppear:(BOOL)animated{
    NSString*filepath=file;
    self.islogin=[NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    [self.tabelV reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor yellowColor];
   
    [self setData];
    [self setView];
    [self setDele];
    //去掉状态栏
    self.automaticallyAdjustsScrollViewInsets =NO;
    [self.tabelV registerNib:[UINib nibWithNibName:@"mineTableViewCell" bundle:nil] forCellReuseIdentifier:@"minecell_id"];
//    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//    NSLog(@"%@",username);
//    [[DataBase startDB] openDB];
//   self.model=[[DataBase startDB] selectuser:username];
//    [[DataBase startDB] closeDB];
    //        self.index=0;
   
    NSString*filepath=file;
    self.islogin=[NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
//    if ([str isEqualToString:@"登录"])  {
//     NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//   
//    usermodel *model=[[DataBase startDB] selectuser:username];
//        self.hearderview.username.text=model.username;
//        if (model.address.length==0) {
//            
//            [self updateinfo];
//        }else{
//           
//            self.hearderview.loctionLabel.text=model.address;
//        
//        
//        }
//        
//    }
     //下拉刷新
    [self downTableV];
   }
//-(void)updateinfo{
//    userInfoViewController *userinfoVC=[[userInfoViewController alloc] init];
//    userinfoVC.model=self.model;
//    [self.navigationController pushViewController:userinfoVC animated:YES];
//
//
//}
-(void)setData{
    for (int i =0; i<7; i++) {
        [self.arrAllImage addObject:[NSString stringWithFormat:@"user_cover%d.jpg",i]];
    }
    
}
-(void)setView{
    self.navigationController.navigationBar.hidden=YES;
    self.tabelV=[[UITableView alloc] initWithFrame:CGRectMake(0,0, kscreenWidth, kscreenHeight-20) style:(UITableViewStyleGrouped)];
//    self.tabelV
    [self.view addSubview:self.tabelV];

}

-(void)setDele{
    self.tabelV.delegate=self;
    self.tabelV.dataSource=self;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return 4;
    }
    return 3;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    mineTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"minecell_id" forIndexPath:indexPath];
 [cell setCellindexpath:indexPath];
    if (indexPath.section==1&&indexPath.row==1) {
         NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        ;
        cell.labelData.text=[NSString stringWithFormat:@"%0.2f M",[self folderSizeAtPath:filePath]];
        
    }
    
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        self.headerbackimgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,kscreenWidth, 240)];
        self.headerbackimgV.userInteractionEnabled=YES;
        self.headerbackimgV.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.arrAllImage[self.index]]];
        self.hearderview=[[headerView alloc] initWithFrame:CGRectMake(0, 0,kscreenWidth,240)];
               
//           NSString*filepath=file;
////          [arr  writeToFile:nemtemp atomically:YES];
//        NSString *str=[NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
        
        if ([self.islogin isEqualToString:@"登录"]) {
            NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            [[DataBase startDB] openDB];
            self.model=[[DataBase startDB] selectuser:username];
            [[DataBase startDB] closeDB];
            self.hearderview.username.text=self.model.username;
            if ([self.model.address  isEqual:@"(null)"]) {
                
                
            }else{
                
                self.hearderview.loctionLabel.text=self.model.address;
                
                
            }
     
            self.hearderview.headerimageV.userInteractionEnabled=YES;
            self.hearderview.headerminimageV.userInteractionEnabled=YES;
            
            UITapGestureRecognizer *headertap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headertapaction)];
            UITapGestureRecognizer *headermintap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headertapaction)];
            [self.hearderview.headerimageV addGestureRecognizer:headertap];
            if (self.model.imgpic==nil||[self.model.imgpic  isEqual:@"(null)"]) {
                
            }else {
            [self.hearderview.headerimageV  sd_setImageWithURL:[NSURL URLWithString:self.model.imgpic]];
            }
            [self.hearderview.headerminimageV addGestureRecognizer:headermintap];
            self.view.backgroundColor=[UIColor clearColor];
            self.tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapaction)];
            if ([self.model.totaldistance  isEqual:@"(null)"]) {
                self.hearderview.totleDistancelabel.text=@"0";
                
            }else{
                
               self.hearderview.totleDistancelabel.text=self.model.totaldistance;
                
                
            }
            
            [self.hearderview addGestureRecognizer:self.tap];
       
        }else{
            self.view.backgroundColor=[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.3];
            self.hearderview.headerminimageV.hidden=YES;
            self.hearderview.headerimageV.hidden=YES;
            self.hearderview.imageloctionV.hidden=YES;
            self.hearderview.username.hidden=YES;
            self.hearderview.loctionLabel.hidden=YES;
            self.hearderview.totleDistancelabel.text=@"0";
            UIButton *loginBtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
            loginBtn.frame=CGRectMake(kscreenWidth/2-50, 64, 100, 40);
            loginBtn.layer.borderWidth=1;
            loginBtn.backgroundColor=[UIColor blueColor];
            loginBtn.layer.borderColor=[UIColor whiteColor].CGColor;
            [loginBtn setTitle:@"立即登录" forState:(UIControlStateNormal)];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [self.hearderview removeGestureRecognizer:self.tap];
            [loginBtn addTarget:self action:@selector(loginbtn) forControlEvents:(UIControlEventTouchUpInside)];
            [self.hearderview addSubview:loginBtn];
      
        }
        [self.headerbackimgV addSubview:self.hearderview];
        return self.headerbackimgV;
    }

    return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 240;
    }
    return 0;
}
-(void)tapaction{
    if (self.index==6) {
        self.index=0;
    }else{
    self.index++;
    }
 self.headerbackimgV.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.arrAllImage[self.index]]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row==0) {
        //历史记录
        if ([self.islogin isEqualToString:@"登录"]) {
            historicalRecordViewController *historicalRVC=[[historicalRecordViewController alloc] init];
            historicalRVC.userM=self.model;
            historicalRVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:historicalRVC animated:YES];
        }else{
        
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
            [self  presentViewController:alert animated:YES completion:^{
            
                sleep(1);
                alert.modalTransitionStyle=NO;
                [alert dismissViewControllerAnimated:YES completion:^{
                    loginViewController *loginVC=[[loginViewController alloc] init];
                    loginVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:loginVC animated:YES];
                }];
            
            
            }];
 
        }

    }
    if (indexPath.section==0 && indexPath.row==1) {
        //分享推荐
        if ([self.islogin isEqualToString:@"登录"]) {
        shareRecommendViewController *shareRVC=[[shareRecommendViewController alloc] init];
        
        shareRVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:shareRVC animated:YES];
    }else{
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        [self  presentViewController:alert animated:YES completion:^{
            
            sleep(1);
            alert.modalTransitionStyle=NO;
            [alert dismissViewControllerAnimated:YES completion:^{
                loginViewController *loginVC=[[loginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }];
            
            
        }];
        
    }

        
    } if (indexPath.section==0&&indexPath.row==2) {
        //问题反馈
        if ([self.islogin isEqualToString:@"登录"]) {
            [self displayComposerSheet];

        }else{
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
            [self  presentViewController:alert animated:YES completion:^{
                
                sleep(1);
                alert.modalTransitionStyle=NO;
                [alert dismissViewControllerAnimated:YES completion:^{
                    loginViewController *loginVC=[[loginViewController alloc] init];
                    loginVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:loginVC animated:YES];
                }];
                
                
            }];
            
        }
    }
    if (indexPath.section==1&&indexPath.row==0) {
        //离线地图
        downloadmapviewViewController *downloadMVC=[[downloadmapviewViewController alloc] init];
        downloadMVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:downloadMVC animated:YES];
        
        
        
    }if (indexPath.section==1&&indexPath.row==1) {
        //清理缓存
        [self clearaction];
        self.indexpath=indexPath;
     
        
    }if (indexPath.section==1&&indexPath.row==2) {
       //用户协议
        userProtocolViewController *userPVC=[[userProtocolViewController alloc] init];
        userPVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:userPVC animated:YES];
        
    }
    
    
    
 


}
//文件大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}

-(void)clearaction{

    UIAlertController *alert=[UIAlertController  alertControllerWithTitle:@"提示" message:@"是否立即清除缓存" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action=[UIAlertAction  actionWithTitle:@"立即清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clear];
        
    }];
    UIAlertAction *action1=[UIAlertAction  actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        alert.modalTransitionStyle=NO;
        [alert dismissViewControllerAnimated:YES completion:^{
           
        }];
        
    }];
     [alert addAction:action];
    [alert addAction:action1];
   
    [self  presentViewController:alert animated:YES completion:^{ }];

}

//清理缓存
-(void)clear{

    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                   });
    

}
-(void)clearCacheSuccess
{   UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"清除成功" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{

        // 延迟2秒
        mineTableViewCell *cell=(mineTableViewCell *)[self.tabelV cellForRowAtIndexPath:self.indexpath];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        ;
        cell.labelData.text=[NSString stringWithFormat:@"%0.2f M",[self folderSizeAtPath:filePath]];
        sleep(2);
        alert.modalTransitionStyle=NO;
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];

    
}
//调用邮件
-(void)displayComposerSheet
{
    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"3282900742@qq.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    //添加主题
    [mailUrl appendString:@"&subject=my email"];
    //添加邮件内容
    [mailUrl appendString:@"&body=<b>email</b> body!"];
    NSString* email = [mailUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];

     }

-(void)headertapaction{
    userInfoViewController *userVC=[[userInfoViewController alloc] init];
     userVC.hidesBottomBarWhenPushed=YES;
    userVC.model=self.model;
    [self.navigationController pushViewController:userVC animated:YES];

}
-(void)loginbtn{
    loginViewController *loginVC=[[loginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:loginVC animated:YES];

}
//下拉刷新
-(void)downTableV{
   
    __weak __typeof(self) weakSelf = self;
    self.tabelV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    //设置回调(一旦进入刷新状态,也就是调用self的loadNewData方法)
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    //设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    //隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    //设置文字
    [header setTitle:@"加载完成" forState:MJRefreshStateIdle];
    [header setTitle:@"请稍后...." forState:MJRefreshStatePulling];
    [header setTitle:@"加载中...." forState:MJRefreshStateRefreshing];
    
    //设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:15];
    
    //设置颜色
    header.stateLabel.textColor = [UIColor blueColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor redColor];
    
    
    //设置header
    self.tabelV.mj_header = header;
    //马上进入刷新状态
    [self.tabelV.mj_header beginRefreshing];
    
    
    
    
}
-(void)loadNewData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabelV.mj_header endRefreshing];
    });
    
}
//懒加载
-(NSMutableArray *)arrAllImage{
    if (_arrAllImage==nil) {
        _arrAllImage=[[NSMutableArray alloc] init];
    }
    return _arrAllImage;
}



@end
