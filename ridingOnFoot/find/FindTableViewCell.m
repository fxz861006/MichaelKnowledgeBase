//
//  FindTableViewCell.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/25.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "FindTableViewCell.h"
#import "tool.h"
#import <UIImageView+WebCache.h>
@implementation FindTableViewCell


-(void)setmodel:(FindModel *)model indexpath:(NSIndexPath *)indexpath{
    self.activityType.layer.masksToBounds = YES;
    if (model.activityType == 0) {
        self.activityType.backgroundColor = kColor(26,0 ,255 ,1);
        self.activityType.text = @"简单";
    }else if (model.activityType == 1){
        self.activityType.backgroundColor = kColor(58, 255, 0, 1);
        self.activityType.text = @"休闲";
    }else if (model.activityType == 2){
        self.activityType.backgroundColor = kColor(245, 128, 2, 1);
        self.activityType.text = @"困难";
    }else if (model.activityType == 3){
        self.activityType.backgroundColor = kColor(243, 21, 3, 1);
        self.activityType.text = @"疯狂";
    }else if (model.activityType == 4){
        self.activityType.backgroundColor = [UIColor blackColor];
        self.activityType.text = @"地狱";
    }
     self.leftlayoutt.constant=(self.activityMiles.frame.origin.x-CGRectGetMaxX(self.activityTime.frame)-15)/2-(self.activityCount.frame.size.width+15)/2+CGRectGetMaxX(self.activityTime.frame);
    self.activityTitle.text = model.activityTitle;
    self.activityAddress.text = model.activityAddress;
    self.activityCount.text = [NSString stringWithFormat:@"%ld/%ld人",model.activityUsersCount,model.activityUserMaxCount];
    self.activityMiles.text = [NSString stringWithFormat:@"%ldkm",model.activityMiles/1000];
    if ([model.activityCoverPic containsString:@";"]) {
        
        NSArray * array = [model.activityCoverPic componentsSeparatedByString:@";"];
        NSString * picStr = array.firstObject;
        
        [self.activityCoverPic sd_setImageWithURL:[NSURL URLWithString:picStr]];
    }else if(model.activityCoverPic.length == 0 ){
        
        self.activityCoverPic.image = [UIImage imageNamed:@"xing.jpg"];
        
    }else{
        [self.activityCoverPic sd_setImageWithURL:[NSURL URLWithString:model.activityCoverPic]];
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
