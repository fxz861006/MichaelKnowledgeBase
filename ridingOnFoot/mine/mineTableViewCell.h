//
//  mineTableViewCell.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/18.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelData;
@property (weak, nonatomic) IBOutlet UIImageView *rigthImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ringthImageVlayout;

-(void)setCellindexpath:(NSIndexPath *)indexpath;
@end
