//
//  DetailTableViewCell.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/21.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "tool.h"
#import <UIImageView+WebCache.h>
@implementation DetailTableViewCell


-(void)setmodelData:(DetailModel *)model arr:(NSMutableArray *)arrTeammateData  indexPath:(NSIndexPath*)indexPath{
//    CGRect rect = self.labelEnd.frame;
//    rect.origin.x += 40;
    if (indexPath.row == 0) {
        self.labelEnd.text = model.teamTitle;
        self.imageV.hidden = YES;
        self.rightlabellayout.constant=10;
    }else if (indexPath.row == 1){
        self.labelEnd.hidden = YES;
        self.imageV.layer.cornerRadius = 15;
        self.imageV.layer.masksToBounds = YES;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.teamAvatar]];
    }else if (indexPath.row == 2){
        self.labelEnd.text = [NSString stringWithFormat:@"#%ld",model.teamId];
        self.imageV.hidden = YES;
       self.rightlabellayout.constant=10;
    }else if (indexPath.row == 3){
        self.labelEnd.text = model.city;
        self.imageV.hidden = YES;
        self.rightlabellayout.constant=10;
    }else if (indexPath.row == 4){
        self.labelEnd.text = [NSString stringWithFormat:@"%ld km",model.teamTotalMiles];
        self.imageV.hidden = YES;
        self.rightlabellayout.constant=10;
    }else if (indexPath.row == 5){
        self.labelEnd.text = [NSString stringWithFormat:@"%ld km",model.teamMonthMiles];
        self.imageV.hidden = YES;
       self.rightlabellayout.constant=10;
    }else if (indexPath.row == 6){
        self.labelEnd.text = model.username;
        self.imageV.layer.cornerRadius = 15;
        self.imageV.layer.masksToBounds = YES;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    }else if (indexPath.row == 7){
        self.labelEnd.hidden = YES;
        if (arrTeammateData.count > 5) {
            for (int i = 0; i < 4; i++) {
                DetailModel *model2 = arrTeammateData[i];
                
                UIImageView * imaView= [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.imageV.frame) - 40 * (i+1) ,CGRectGetMinY(self.imageV.frame),self.imageV.frame.size.width,self.imageV.frame.size.height)];
                [imaView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model2.avatar]]];
                
                imaView.layer.cornerRadius = 15;
                imaView.layer.masksToBounds = YES;
                [self.contentView addSubview:imaView];
            }
            self.imageV.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
            self.imageV.layer.cornerRadius = 15;
            self.imageV.layer.masksToBounds = YES;
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [NSString stringWithFormat:@"%ld",arrTeammateData.count - 4];
            [self.imageV addSubview:label];
            
        }else{
            DetailModel * modell = arrTeammateData[0];
            self.imageV.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
            self.imageV.layer.cornerRadius = 15;
            self.imageV.layer.masksToBounds = YES;
            
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:modell.avatar]];
            
            for (int i = 1; i < 4; i++) {
                DetailModel *model2 = arrTeammateData[i];
                
                UIImageView * imaView= [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.imageV.frame) - 40 * (i+1) ,CGRectGetMinY(self.imageV.frame),self.imageV.frame.size.width,self.imageV.frame.size.height)];
                [imaView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model2.avatar]]];
                
                imaView.layer.cornerRadius = 15;
                imaView.layer.masksToBounds = YES;
                [self.contentView addSubview:imaView];
            }
        }
    }else if (indexPath.row == 8){
        
        self.imageV.hidden = YES;
        self.labelEnd.hidden = YES;
//        self.cellstr = model.teamDesc;
        UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, kscreenWidth - 10, [[self class] cellHightWithString:model.teamDesc])];
        [self.contentView addSubview:label];
        label.numberOfLines = 0;
        label.text = [NSString stringWithFormat:@"%@",model.teamDesc];
        
        
    }




}

- (void)awakeFromNib {
//    // Initialization code
//    
//    self.labFront = [[ UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 40)];
//    [self.contentView addSubview:self.labFront];
//    
//    self.labEnd = [[UILabel alloc]initWithFrame:CGRectMake(kscreenWidth - 200, 10, 150, 40)];
//    [self.contentView addSubview:self.labEnd];
//    
//    self.imaV = [[UIImageView alloc]initWithFrame:CGRectMake(kscreenWidth - 50, 5, 30, 30)];
//    [self.contentView addSubview:self.imaV];
}




+(CGFloat)cellHightWithString:(NSString *)str{
    
    //限定宽度的参数
    //宽度也一定是跟你的控件设定的宽度一样
    CGSize size = CGSizeMake(kscreenWidth - 10, MAXFLOAT);
    
    //限定字体大小的参数
    //这里写的字体的大小一定要跟你控件中设定的字体大小一样
    NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    //计算一段文本在限定宽度和限定字体大小的情况下占据的矩形框的大小
    CGRect rect = [str boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    
    return rect.size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
