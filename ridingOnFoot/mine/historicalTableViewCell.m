//
//  historicalTableViewCell.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/26.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "historicalTableViewCell.h"
#import "tool.h"
@implementation historicalTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllview];
    }
    
    return self;
    
    
}
-(void)addAllview{
    self.labeltimeDate=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, kscreenWidth-50, 30)];
    self.labeltimeDate.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.labeltimeDate];
    self.imgVType=[[UIImageView alloc] initWithFrame:CGRectMake(kscreenWidth-40, 10, 30, 30)];
    [self.contentView addSubview:self.imgVType];
    self.labelstartpoint=[[UILabel alloc] initWithFrame:CGRectMake(10, 65,120,40)];
    self.labelstartpoint.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.labelstartpoint];
    self.labelstoppoint=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth-130, 65, 120, 30)];
    self.labelstoppoint.font=[UIFont systemFontOfSize:14];
    self.labelstoppoint.numberOfLines=0;
    [self.contentView addSubview:self.labelstoppoint];
    UIView *HV=[[UIView alloc] initWithFrame:CGRectMake(kscreenWidth/2-(kscreenWidth-280)/2, 80, kscreenWidth-280, 1)];
    HV.backgroundColor=[UIColor lightGrayColor];
    [self.contentView addSubview:HV];
    self.labeldistance=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-(kscreenWidth-280)/2, 50, kscreenWidth-280, 20)];
    self.labeldistance.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.labeldistance];
    self.labeltime=[[UILabel alloc] initWithFrame:CGRectMake(kscreenWidth/2-(kscreenWidth-280)/2, 90, kscreenWidth-280, 20)];
    self.labeltime.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.labeltime];
    
    

}
//model 的set方法
-(void)setModel:(sportmodel *)model{
    self.labeltimeDate.text=model.timeDate;
    self.labelstartpoint.text=model.startpoint;
    self.labelstoppoint.text=model.stoppoint;
    self.labeldistance.text=[NSString stringWithFormat:@"%ld",model.distance];
    
    self.labeltime.text=[NSString stringWithFormat:@"%0ld:%02ld:%02ld",(long)(model.time/3600)%24,(long)(model.time/60)%60,(long)model.time%60];
    CGRect labelstartpointFram = self.labelstartpoint.frame;
    labelstartpointFram.size.height = [[self class] customStartpointHeight:model];
    self.labelstartpoint.frame = labelstartpointFram;
    CGRect labelstoppointFram = self.labelstoppoint.frame;
    labelstoppointFram.size.height = [[self class] customlabelstoppointHeight:model];
    self.labelstoppoint.frame = labelstoppointFram;

}

+ (CGFloat)customStartpointHeight:(sportmodel *)model {
    
    CGRect rect = [model.startpoint boundingRectWithSize:CGSizeMake(120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    return rect.size.height;
}
+ (CGFloat)customlabelstoppointHeight:(sportmodel *)model {
    
    CGRect rect = [model.stoppoint boundingRectWithSize:CGSizeMake(120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    return rect.size.height;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
