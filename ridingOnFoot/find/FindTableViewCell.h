//
//  FindTableViewCell.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/25.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindModel.h"
@interface FindTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityCoverPic;
@property (weak, nonatomic) IBOutlet UILabel *activityType;
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityAddress;
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UILabel *activityCount;


@property (weak, nonatomic) IBOutlet UILabel *activityMiles;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftlayoutt;

-(void)setmodel:(FindModel *)model indexpath:(NSIndexPath *)indexpath;

@end
