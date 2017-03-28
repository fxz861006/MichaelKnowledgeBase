//
//  ClubTableViewCell.h
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/15.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teamTitle;
@property (weak, nonatomic) IBOutlet UILabel *teamMiles;
@property (weak, nonatomic) IBOutlet UILabel *teamUserCounts;
@property (weak, nonatomic) IBOutlet UILabel *teamCityName;
@property (weak, nonatomic) IBOutlet UIImageView *teamAvatar;
@property (weak, nonatomic) IBOutlet UILabel *teamNumber;
@property (weak, nonatomic) IBOutlet UIImageView *teamCitynameImageView;

@end
