//
//  FindDetailTableViewCell.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/26.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CellView.h"
@interface FindDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelOrder;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
//@property(nonatomic,strong)CellView * view2;
//@property(nonatomic,strong)CellView * view;
+(CGFloat)cellHightWithString:(NSString *)str;



@end
