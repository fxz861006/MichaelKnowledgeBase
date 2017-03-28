//
//  MoreViewController.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/22.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "MoreViewController.h"
#import "tool.h"
#import "RequestUrl.h"
#import "RoadbookModel.h"
#import "RoadbookTableViewCell.h"
#import <UIImageView+WebCache.h>

static NSInteger num = 250;
@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong) UITableView * detailRoadTableView;
@property(nonatomic,strong) NSMutableArray * arrAllData;


@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setData];
    [self setView];
    [self setDelegate];
    
    self.navtitle.text = @"路书详情";
}


-(void)setView{
    

    self.detailRoadTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kscreenWidth,kscreenHeight )style:(UITableViewStylePlain)];
    [self.view addSubview:self.detailRoadTableView];
    [self.detailRoadTableView registerNib:[UINib nibWithNibName:@"RoadbookTableViewCell" bundle:nil] forCellReuseIdentifier:@"RoadbookTableViewCell"];
    self.detailRoadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailRoadTableView.rowHeight = num;
    UIButton *rightBtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    rightBtn.frame=CGRectMake(kscreenWidth-50, 22, 40, 40);
    [rightBtn setImage:[UIImage imageNamed:@"roadbook_download@2x.png"] forState:(UIControlStateNormal)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.navV addSubview:rightBtn];
    
}
-(void)rightBtnAction{
    NSMutableData *data=[NSMutableData data];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.model forKey:@"readBookModel"];
    [archiver finishEncoding];
    
    
    
    
    
    NSString *str=readBookModelFile;
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:str];
    NSString *str11=readBookModelFile;
    [self.arrAllData removeAllObjects];
    NSMutableDictionary *dic1=[NSMutableDictionary dictionaryWithContentsOfFile:str11];
    NSArray *arr=[dic1 allValues];
    int i=0;
   
    for (NSData *data in arr) {
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        
        RoadbookModel *model=[unarchiver decodeObjectForKey:@"readBookModel"];
        if (model.modelid ==self.model.modelid) {
            i=1;
        }
        [unarchiver finishDecoding];
        
    }
    
    if (dic==nil) {
        dic=[NSMutableDictionary dictionaryWithObject:data forKey:[NSString stringWithFormat:@"%ld",self.model.modelid]];
    }else if(i==0){
        
        [dic setValue:data forKey:[NSString stringWithFormat:@"%ld",self.model.modelid]];
    
    }else{
    
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"已添加过" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertC animated:YES completion:^{
            sleep(2);
            
            alertC.modalTransitionStyle=NO;
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];
    
    
    }
    
   BOOL change=[dic writeToFile:str atomically:YES];
    if (change) {
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"添加到本地成功" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertC animated:YES completion:^{
            sleep(2);
        
            alertC.modalTransitionStyle=NO;
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];

    }else{
    
        UIAlertController *alertC=[UIAlertController alertControllerWithTitle:nil message:@"添加到本地失败" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertC animated:YES completion:^{
            sleep(2);
            
            alertC.modalTransitionStyle=NO;
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }];

    
    
    }
    
}


-(void)setDelegate{
    
    self.detailRoadTableView.delegate = self;
    self.detailRoadTableView.dataSource = self;
}

//-(void)setData{
//    //lat=40.02921596353647&limit=20&lng=116.3373105854755&page=0&type=3
//    
//    NSMutableDictionary * lushuDic = [NSMutableDictionary dictionaryWithDictionary:@{@"lat":@40.02921596353647,@"limit":@20,@"lng":@116.3373105854755,@"page":@0,@"type":@3}];
//    
//    [RequestUrl requestWith:GET URL:URLLUSHU condition:lushuDic SuccessBlock:^(id item) {
//        
//        self.arrAllData = [NSMutableArray array];
//        for (NSDictionary * dic in item) {
//            RoadbookModel * model = [[RoadbookModel alloc]init];
//            [model setValuesForKeysWithDictionary:dic];
//            [self.arrAllData addObject:model];
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self.detailRoadTableView reloadData];
//            
//        });
//        
//        
//    } failBlock:^(NSError *err) {
//        
//        
//    }];
//    
//    
//}


//-(void)backAction{
//    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    
//}

#pragma mark Tableview  delegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    RoadbookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RoadbookTableViewCell" forIndexPath:indexPath];
     cell.imageV1.hidden = YES;
    cell.imageV2.hidden = YES;
    cell.comment_num.hidden = YES;
    cell.download_time.hidden = YES;
    cell.collectionImageView.hidden = YES;
    cell.distanceLabel.hidden = YES;
    cell.user_nameLabel.textColor = [UIColor blackColor];
    cell.user_nameLabel.text = [NSString stringWithFormat:@"%.2fkm",self.model.distance/10000];
   
    
    cell.titleLabel.text = self.model.title;
    

    [cell.mapImageView sd_setImageWithURL:[NSURL URLWithString:self.model.image]];
    
    UIImageView * imaV = [[UIImageView alloc]initWithFrame:CGRectMake(10,num - 40, 30, 30)];
    [cell.contentView addSubview:imaV];
    imaV.layer.cornerRadius = 15;
    imaV.layer.masksToBounds = YES;
    [imaV sd_setImageWithURL:[NSURL URLWithString:self.model.user_pic]];
    UILabel * labl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imaV.frame) + 10, num - 30, 150, 20)];
    labl.font = [UIFont systemFontOfSize:13];
    labl.textColor = [UIColor blueColor];
    [cell.contentView addSubview:labl];
    labl.text = self.model.user_name;
    
    
    
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
