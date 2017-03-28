//
//  FindDetailTableViewCell.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/26.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "FindDetailTableViewCell.h"
#import "tool.h"

@implementation FindDetailTableViewCell
- (void)awakeFromNib {
    // Initialization code
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
