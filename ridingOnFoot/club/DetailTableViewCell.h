//
//  DetailTableViewCell.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
@interface DetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelFront;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *labelEnd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightlabellayout;
@property(strong,nonatomic)DetailModel *model;

+(CGFloat)cellHightWithString:(NSString *)str;
-(void)setmodelData:(DetailModel *)model arr:(NSMutableArray *)arrTeammateData  indexPath:(NSIndexPath*)indexPath;
//
//@property(nonatomic,strong) UILabel * labFront;
//@property(nonatomic,strong) UILabel * labEnd;
//@property(nonatomic,strong) UIImageView * imaV;
//

@end
