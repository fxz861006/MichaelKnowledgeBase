//
//  historicalRecordViewController.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/26.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "historicalRecordViewController.h"
#import "DataBase.h"
#import "tool.h"
#import "sportmodel.h"
#import "historicalTableViewCell.h"
@interface historicalRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *arrAllData;
@property(nonatomic,strong)UITableView *tableV;
@end

@implementation historicalRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navtitle.text=@"历史记录";
    [self setData];
    [self setViews];
    self.tableV.dataSource=self;
    self.tableV.delegate=self;
}
-(void)setData{
    [[DataBase startDB] openDB];
 self.arrAllData= [[DataBase startDB] selectsport:self.userM.username];
    [[DataBase startDB] closeDB];
}

-(void)setViews{
    self.tableV=[[UITableView alloc] initWithFrame:CGRectMake(0, 64,kscreenWidth , kscreenHeight-64) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableV];

}
-(NSMutableArray *)arrAllData{
    if (!_arrAllData) {
        _arrAllData=[NSMutableArray array];
    }
    return _arrAllData;


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.arrAllData.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    historicalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"historicalcell_id"];
    if (cell==nil) {
        cell=[[historicalTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"historicalcell_id"];
    }
    sportmodel *model=self.arrAllData[indexPath.row];
    
    
    cell.model=model;
    UIButton *clearbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    clearbtn.frame=CGRectMake(kscreenWidth-40, 140, 30, 30);
    [clearbtn addTarget:self action:@selector(clearbtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    clearbtn.tag=2100+indexPath.row;
    [clearbtn setBackgroundImage:[UIImage imageNamed:@"xingzhe_delete@3x.png"] forState:(UIControlStateNormal)];
    
    [cell.contentView addSubview:clearbtn];
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat startpoint=[historicalTableViewCell customStartpointHeight:self.arrAllData[indexPath.row]];
    CGFloat stoppoint=[historicalTableViewCell customlabelstoppointHeight:self.arrAllData[indexPath.row]];
    CGFloat height=startpoint>=stoppoint?startpoint:stoppoint;
    return height+100;
}
-(void)clearbtnAction:(UIButton *)button{
    NSInteger i=button.tag-2100;
    sportmodel *model=self.arrAllData[i];
    [self.arrAllData removeObjectAtIndex:i];
    NSLog(@"%@",model.timeDate);
    [[DataBase startDB] openDB];
    [[DataBase startDB] deletesport:model];
    [[DataBase startDB] closeDB];
    
    [self.tableV reloadData];
    
}
@end
