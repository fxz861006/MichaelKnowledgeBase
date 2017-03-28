//
//  LocalViewController.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/18.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "LocalViewController.h"
#import "tool.h"
#import "RoadbookModel.h"
#import <UIImageView+WebCache.h>
#import "RoadbookTableViewCell.h"
#import "MoreViewController.h"
@interface LocalViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tabelV;
@property(nonatomic,strong)NSMutableArray *arrAllData;
@property(nonatomic,strong)NSMutableDictionary *dic;
@end

@implementation LocalViewController
-(void)viewWillAppear:(BOOL)animated{
    [self setData];
    [self.tabelV reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor orangeColor];
    [self setViews];
    [self setData];
    [self.tabelV registerNib:[UINib nibWithNibName:@"RoadbookTableViewCell" bundle:nil] forCellReuseIdentifier:@"RoadbookTableViewCell"];
    self.tabelV.delegate=self;
    self.tabelV.dataSource=self;
    self.title = @"本地";
    
    
}
-(void)setViews{
    self.tabelV=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight-148) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tabelV];

}
-(void)setData{
    NSString *str=readBookModelFile;
    [self.arrAllData removeAllObjects];
    self.dic=[NSMutableDictionary dictionaryWithContentsOfFile:str];
   NSArray *arr=[self.dic allValues];
    for (NSData *data in arr) {
        NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        
        RoadbookModel *model=[unarchiver decodeObjectForKey:@"readBookModel"];
        [self.arrAllData addObject:model];
        [unarchiver finishDecoding];

    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.arrAllData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoadbookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RoadbookTableViewCell" forIndexPath:indexPath];
    RoadbookModel * model = self.arrAllData[indexPath.row];
    
    cell.titleLabel.text = model.title;
    cell.user_nameLabel.text = [NSString stringWithFormat:@"%@ ",model.user_name];
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"| %.2fkm",model.distance/1000];
    [cell.downV removeFromSuperview];
//    cell.comment_num.text = [NSString stringWithFormat:@"%ld",model.comment_num];
//    cell.download_time.text = [NSString stringWithFormat:@"%ld",model.download_time];
    [cell.mapImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    
    if (model.is_collect == false) {
        
        cell.collectionImageView.hidden = YES;
    }
    
    UIButton *clearbtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
    clearbtn.frame=CGRectMake(kscreenWidth-40, 140, 30, 30);
    [clearbtn addTarget:self action:@selector(clearbtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    clearbtn.tag=1100+indexPath.row;
    [clearbtn setBackgroundImage:[UIImage imageNamed:@"xingzhe_delete@3x.png"] forState:(UIControlStateNormal)];
   
    [cell.contentView addSubview:clearbtn];
    return cell;




}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreViewController * moreVC = [[MoreViewController alloc]init];
    moreVC.model = self.arrAllData[indexPath.row];
    [self.navigationController pushViewController:moreVC animated:YES];
    
}
-(void)clearbtnAction:(UIButton *)button{
    NSInteger i=button.tag-1100;
    RoadbookModel *model=self.arrAllData[i];
    [self.dic removeObjectForKey:[NSString stringWithFormat:@"%ld",model.modelid]];
    NSLog(@"%ld",model.modelid);
    NSString *str=readBookModelFile;
   
    
    [self.dic writeToFile:str atomically:YES];
    
    
    [self.arrAllData removeObjectAtIndex:i];
    [self.tabelV reloadData];

}

-(NSMutableArray *)arrAllData{
    if (!_arrAllData) {
        _arrAllData=[NSMutableArray array];
    }
    return _arrAllData;


}
@end
