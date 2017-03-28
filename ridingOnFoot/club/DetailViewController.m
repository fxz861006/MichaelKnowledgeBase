//
//  DetailViewController.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "DetailViewController.h"
#import "RequestUrl.h"
#import "tool.h"
#import "DetailModel.h"
#import "DetailTableViewCell.h"
#import <UIImageView+WebCache.h>
//#import "RankViewController.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView * detailTableView;
//@property(nonatomic,strong) NSMutableArray * allArrData;
@property(nonatomic,strong)DetailModel *model;
@property(nonatomic,strong) NSArray * frontArray;
@property(nonatomic,strong) NSMutableArray * arrTeammateData;
@property(nonatomic,strong)NSString *cellstr;


@end

@implementation DetailViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navV=[[UIView alloc] initWithFrame:CGRectMake(0, 0,kscreenWidth,64)];
    self.navV.backgroundColor =[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
    [self.view addSubview:self.navV];
    self.backbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backbtn.frame=CGRectMake(10, 22, 40, 40);
    self.backbtn.tintColor=[UIColor whiteColor];
    [self.backbtn setImage:[UIImage imageNamed:@"icon_nav_back@2x.png"] forState:(UIControlStateNormal)];
    [self.backbtn addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navV addSubview:self.backbtn];
    self.navtitle=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-80, 22, 160, 40)];
    self.navtitle.text=@"详情";
    self.navtitle.textAlignment=NSTextAlignmentCenter;
    self.navtitle.textColor=[UIColor whiteColor];
    [self.navV addSubview:self.navtitle];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld",self.teamId]forKey:@"teamId"];
    
    [self setDataWithDic:dic];
    NSMutableDictionary * teammateDic = [NSMutableDictionary dictionaryWithDictionary:@{@"limit":@"20",@"orderType":@"0",@"page":@0,@"timeType":@1}];
    [teammateDic setValue:[NSString stringWithFormat:@"%ld",self.teamId] forKey:@"teamId"];
    [self setTeammateDataWithDictionary:teammateDic];
    [self setView];
    [self setDelegate];
}


-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)setView{
    
    self.detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kscreenWidth, kscreenHeight - 64) style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.detailTableView];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailTableViewCell"];
    
    
}


-(void)setDelegate{
    
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
}


-(void)setDataWithDic:(NSDictionary *)dic{
    __weak typeof(self)  weakself=self;
   [RequestUrl requestWith:GET URL:URLCLUBDETAIL condition:dic SuccessBlock:^(id item) {
//       weakself.allArrData = [NSMutableArray array];
      NSDictionary *dic1 = item[@"data"];
    NSDictionary * dic2 = dic1[@"user"];
    
           weakself.model = [[DetailModel alloc]init];
           [weakself.model setValuesForKeysWithDictionary:dic1];
       [weakself.model setValuesForKeysWithDictionary:dic2];
//           [weakself.allArrData addObject:model];
       
   
       
       dispatch_async(dispatch_get_main_queue(), ^{
          
           [weakself.detailTableView reloadData];
       });
       
   } failBlock:^(NSError *err) {
       
   }];
}

-(void)setTeammateDataWithDictionary:(NSDictionary *)dic{
    
    [RequestUrl requestWith:GET URL:URLTEAMMATE condition:dic SuccessBlock:^(id item) {
        self.arrTeammateData = [NSMutableArray array];
        NSArray * arr = item[@"data"];
        for (NSDictionary * dic in arr) {
            
            DetailModel * model = [[DetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.arrTeammateData addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.detailTableView reloadData];
        });

    } failBlock:^(NSError *err) {
        
    }];
}

#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 9;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell" forIndexPath:indexPath];
    
    cell.labelFront.text = self.frontArray[indexPath.row];
    
//    DetailModel * model = self.allArrData[0];
    [cell setmodelData:self.model arr:self.arrTeammateData indexPath:indexPath];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==8) {
 
        return [DetailTableViewCell cellHightWithString:self.model.teamDesc] + 30;
    }else {
    return 40;
    }
}

-(NSArray *)frontArray{
    if (!_frontArray) {
        _frontArray = @[@"名称",@"车队标志",@"ID",@"城市",@"总里程",@"月度里程",@"队长",@"队员",@"公告"];
    }
    return _frontArray;
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
