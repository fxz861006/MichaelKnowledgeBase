//
//  ListViewController.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/11.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "ListViewController.h"
#import "tool.h"


@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

//static NSInteger number = 0;

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setView];
    
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
}



-(void)setView{
    
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, kscreenHeight) style:(UITableViewStylePlain)];

    self.listTableView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.2];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.listTableView];

}


-(void)tapListAction{
    
    
             [UIView animateWithDuration:0.4 animations:^{
                
                 self.view.frame = CGRectMake(0,-100, kscreenWidth,64 );
                 
             } completion:^(BOOL finished) {
                 
                 [self.view removeFromSuperview];
             }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    
    if (!self.cell) {
        
        self.cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell_id"];
    }
    
    UIView * view =[[UIView alloc]init];
    view.backgroundColor = [UIColor lightGrayColor];
    
    self.cell.backgroundColor = [UIColor whiteColor];
    self.cell.selectedBackgroundView = view;
    
    self.cell.textLabel.text = self.arr[indexPath.row];
    
    return self.cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        
        _number = indexPath.row;
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"number" object:@"change" userInfo:@{@"1":@"俱乐部月度榜"}];
        
    }
    
   

        [UIView animateWithDuration:0.4 animations:^{
            
            self.view.frame = CGRectMake(0,-100, kscreenWidth,64 );
            
        } completion:^(BOOL finished) {
            
            [self.view removeFromSuperview];
        }];

       
  }






-(NSArray *)arr{
    
    if (!_arr) {
        _arr = [NSArray arrayWithObjects:@"俱乐部月度榜",@"俱乐部年度榜", nil];
    }
    return _arr;
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
