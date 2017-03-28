//
//  mineTableViewCell.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/18.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "mineTableViewCell.h"

@implementation mineTableViewCell


-(void)setCellindexpath:(NSIndexPath *)indexpath{
    if (indexpath.section==0 && indexpath.row==0) {
        self.imageV.image=[UIImage imageNamed:@"lishijilu.png"] ;
        self.labelName.text=@"历史记录";
        self.labelData.hidden=YES;
    } if (indexpath.section==0 &&indexpath.row==1) {
        self.imageV.image=[UIImage imageNamed:@"1182213.gif"] ;
        self.labelName.text=@"分享推荐";
        self.labelData.hidden=YES;
    } if (indexpath.section==0 &&indexpath.row==2) {
        self.imageV.image=[UIImage imageNamed:@"BIA5]E(8~4KB~A)JT}3D)AA.png"];
        self.labelName.text=@"问题反馈";
        self.labelData.hidden=YES;
        
            }
    
   if (indexpath.section==1 &&indexpath.row==0) {
        self.imageV.image=[UIImage imageNamed:@"club_location@3x.png"];
        self.labelName.text=@"离线地图";
        self.labelData.hidden=YES;
        
    }
    if (indexpath.section==1 &&indexpath.row==1) {
        
        self.imageV.image=[UIImage imageNamed:@"89P~@KE[4]6QQAV2T4IVMLP.png"];
        self.labelName.text=@"清理缓存";
        self.labelData.text=[NSString stringWithFormat:@"%0.2fkm",4.0];
    }
    if (indexpath.section==1 &&indexpath.row==2) {
        self.imageV.image=[UIImage imageNamed:@"shiyongbangzhu.png"];
        self.labelName.text=@"用户协议";
        self.labelData.hidden=YES;
    }
    if (indexpath.section==1 &&indexpath.row==3) {
        self.imageV.image=[UIImage imageNamed:@"login_ remind@2x.png"];
        self.labelName.text=@"版本信息";
        self.labelData.text=@"1.0(0321)";
        self.rigthImageV.hidden=YES;
    }


}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
