//
//  CellViewTableViewCell.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/27.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "CellViewTableViewCell.h"
#import "tool.h"

@implementation CellViewTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addView];
    }
    return self;
    
}

-(void)addView{
    
    self.cellImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kscreenWidth/4-30, 18, 14, 14)];
    self.cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.cellImageView.frame)+10, 15, kscreenWidth/4, 20 )];
    self.cellLabel.font=[UIFont systemFontOfSize:14];
    UIView * HV=[[UIView alloc] initWithFrame:CGRectMake(kscreenWidth/2-0.5, 0, 1, 50)];
    HV.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:HV];
    self.SecondImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kscreenWidth/2 +kscreenWidth/4-30, 18, 14, 14)];
    self.secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.SecondImageView.frame)+10, 15, kscreenWidth/4, 20)];
    self.secondLabel.font=[UIFont systemFontOfSize:14];
    [self addSubview:self.cellImageView];
    [self addSubview:self.cellLabel];
    [self addSubview:self.SecondImageView];
    [self addSubview:self.secondLabel];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
