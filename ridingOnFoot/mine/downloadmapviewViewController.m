//
//  downloadmapviewViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/24.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "downloadmapviewViewController.h"
#import "tool.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface downloadmapviewViewController ()<UITableViewDelegate,UITableViewDataSource,BMKOfflineMapDelegate>
@property(nonatomic,strong)UITableView *tableV;
@property(nonatomic,strong)BMKOfflineMap* offlineMap;
@property(nonatomic,strong)NSArray* arrayOfflineCityData;//全国支持离线地图的城市
@property(nonatomic,strong)NSMutableArray * arraylocalDownLoadMapInfo;//本地下载的离线地图
/** 当前选中的城市 */
@property (nonatomic, strong) BMKOLSearchRecord *currentItem;
/** 当前选中的行 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
/** 选中的城市中数组的最后一个子城市 */
@property (nonatomic, strong) NSString *lastChildCityName;
/** 纪录是否正在下载 */
@property (nonatomic, assign) BOOL isDownload;
//正在下载的城市
@property(nonatomic,strong)BMKOLSearchRecord *downloadcity;
@end

@implementation downloadmapviewViewController
-(void)viewWillAppear:(BOOL)animated{
    
    for (BMKOLSearchRecord* item in self.arrayOfflineCityData) {
        NSString *cityname=[[NSUserDefaults standardUserDefaults] valueForKey:item.cityName];
        if ([cityname isEqualToString:@"正在下载"]) {
            BOOL isSuccessful = [self.offlineMap remove:item.cityID];
            if (isSuccessful) {
                
                [[NSUserDefaults standardUserDefaults] setValue:@"未下载" forKey:item.cityName];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.tableV reloadData];
            }
            
        }
        
    }
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.offlineMap = [[BMKOfflineMap alloc]init];
    self.arrayOfflineCityData = [self.offlineMap getOfflineCityList];
    self.navtitle.text=@"下载离线地图";
    self.tableV=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kscreenWidth, kscreenHeight-64) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableV];
    self.tableV.delegate=self;
    self.tableV.dataSource=self;
    
  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
}
-(void)timeAction{
//    if (self.isDownload==YES) {
      [self.tableV reloadData];
//    }
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.arrayOfflineCityData.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString *CellIdentifier = @"OfflineMapCityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
   
    BMKOLSearchRecord* item = [_arrayOfflineCityData objectAtIndex:indexPath.row];
    BMKOLUpdateElement* updateInfo;
    updateInfo = [_offlineMap getUpdateInfo:self.downloadcity.cityID];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", item.cityName];
    //转换包大小
    NSString*packSize = [self getDataSizeString:item.size];
    UILabel *sizelabel =[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth-150, 0, 150, 40)];
    sizelabel.textAlignment=NSTextAlignmentRight;
    sizelabel.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin;
     NSString *cityname=[[NSUserDefaults standardUserDefaults] valueForKey:item.cityName];
    if (cityname==nil||[cityname isEqualToString:@"未下载"]) {
        
        sizelabel.text = packSize;
    }
    else if([cityname isEqualToString:@"正在下载"]){
        sizelabel.text = [NSString stringWithFormat:@"%d%%",updateInfo.ratio];
        if (updateInfo.ratio==100) {
            self.isDownload=NO;
            [[NSUserDefaults standardUserDefaults] setValue:@"已下载" forKey:item.cityName];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }else {
//       self.isDownload=NO;
       sizelabel.text=@"已下载";

    }
    
    sizelabel.backgroundColor = [UIColor clearColor];
    cell.accessoryView = sizelabel;



    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *downloadAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.currentIndexPath = indexPath;
        self.currentItem =  self.arrayOfflineCityData[indexPath.row];
        //如果正在下载 提示正在下载
        if (self.isDownload==YES) {
            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"正在下载" preferredStyle:(UIAlertControllerStyleAlert)];
            [self presentViewController:alertC animated:YES completion:^{
//                self.isDownload=YES;
//                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
                sleep(2);
                alertC.modalTransitionStyle=NO;
                [alertC dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }else{
            //不是正在下载开始下载当前点击的cell  并记录下载的当前cell
        self.currentIndexPath = indexPath;
        self.currentItem =  self.arrayOfflineCityData[indexPath.row];
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:self.currentItem.cityID];
       NSString *cityname=[[NSUserDefaults standardUserDefaults] valueForKey:self.currentItem.cityName];
            
        if (cityname==nil||[cityname isEqualToString:@"未下载"]) {
            
            
                self.lastChildCityName = [(BMKOLSearchRecord *)[self.currentItem.childCities lastObject] cityName];;
                if (!self.lastChildCityName) {
                    self.lastChildCityName = self.currentItem.cityName;
                }
                [self.offlineMap start:self.currentItem.cityID];
            self.downloadcity=self.currentItem;
                self.isDownload=YES;
                [[NSUserDefaults standardUserDefaults] setValue:@"正在下载" forKey:self.currentItem.cityName];
                [[NSUserDefaults standardUserDefaults] synchronize];
            
            

      
//        }
            
            
        }else if(updateInfo.ratio<100){
//            if (self.isDownload==YES) {
                UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"正在下载" preferredStyle:(UIAlertControllerStyleAlert)];
                [self presentViewController:alertC animated:YES completion:^{
                    
//                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    sleep(2);
                    alertC.modalTransitionStyle=NO;
                    [alertC dismissViewControllerAnimated:YES completion:nil];
                }];
//            }
            

            
        }
        else
        
        
        {
            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"已下载" preferredStyle:(UIAlertControllerStyleAlert)];
            [self presentViewController:alertC animated:YES completion:^{
                
                [[NSUserDefaults standardUserDefaults] setValue:@"已下载" forKey:self.currentItem.cityName];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                sleep(2);
                alertC.modalTransitionStyle=NO;
                [alertC dismissViewControllerAnimated:YES completion:nil];
            }];
        
        
        }
       }
    }];
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.currentItem =  self.arrayOfflineCityData[indexPath.row];
        if (self.isDownload==YES && ![self.downloadcity isEqual:self.currentItem]) {
            
            UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"正在下载" preferredStyle:(UIAlertControllerStyleAlert)];
            [self presentViewController:alertC animated:YES completion:^{
                  self.isDownload=YES;
//                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                sleep(2);
                alertC.modalTransitionStyle=NO;
                [alertC dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        else {
            BOOL isSuccessful = [self.offlineMap remove:self.currentItem.cityID];
            if (isSuccessful) {
                [self.tableV reloadData];
                self.isDownload=NO;
                [[NSUserDefaults standardUserDefaults] setValue:@"未下载" forKey:self.currentItem.cityName];
                [[NSUserDefaults standardUserDefaults] synchronize];
        }
         
        }
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:downloadAction];
    [alertController addAction:removeAction];
    [alertController addAction:cancleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];



}


- (void)onGetOfflineMapState:(int)type withState:(int)state
{
    
    if (type == TYPE_OFFLINE_UPDATE) {
        //id为state的城市正在下载或更新，start后会毁掉此类型
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
//        NSLog(@"城市名：%@,下载比例:%d",updateInfo.cityName,updateInfo.ratio);

        
    }
    if (type == TYPE_OFFLINE_NEWVER) {
        //id为state的state城市有新版本,可调用update接口进行更新
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
//        NSLog(@"是否有更新%d",updateInfo.update);
    }
    if (type == TYPE_OFFLINE_UNZIP) {
        //正在解压第state个离线包，导入时会回调此类型
    }
    if (type == TYPE_OFFLINE_ZIPCNT) {
        //检测到state个离线包，开始导入时会回调此类型
//        NSLog(@"检测到%d个离线包",state);
        if(state==0)
        {
//            [self showImportMesg:state];
        }
    }
    if (type == TYPE_OFFLINE_ERRZIP) {
        //有state个错误包，导入完成后会回调此类型
//        NSLog(@"有%d个离线包导入错误",state);
    }
    if (type == TYPE_OFFLINE_UNZIPFINISH) {
//        NSLog(@"成功导入%d个离线包",state);
        //导入成功state个离线包，导入成功后会回调此类型
//        [self showImportMesg:state];
    }
    
}
//导入提示框
//- (void)showImportMesg:(int)count
//{
//    NSString* showmeg = [NSString stringWithFormat:@"成功导入离线地图包个数:%d", count];
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"导入离线地图" message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//    [myAlertView show];
//}

#pragma mark 包大小转换工具类（将包大小转换成合适单位）
-(NSString *)getDataSizeString:(int) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%dB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
    }
    
    return string;
}


@end
