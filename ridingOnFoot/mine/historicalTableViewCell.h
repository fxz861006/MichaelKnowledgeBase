//
//  historicalTableViewCell.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/26.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sportmodel.h"
@interface historicalTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * labeltimeDate;
@property(nonatomic,strong)UILabel * labelstartpoint;
@property(nonatomic,strong)UILabel *labelstoppoint;
@property(nonatomic,strong)UILabel *labeldistance;
@property(nonatomic,strong)UILabel *labeltime;
@property(nonatomic,strong)UIImageView *imgVType;
@property(nonatomic,strong)sportmodel *model;
+ (CGFloat)customStartpointHeight:(sportmodel *)model;
+ (CGFloat)customlabelstoppointHeight:(sportmodel *)model;
@end
