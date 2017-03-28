//
//  scrollAddView.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/14.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scrollAddView : UIView
/**
 *  时速
 */
@property (weak, nonatomic) IBOutlet UILabel *labelspeedhour;
/**
 *  里程
 */
@property (weak, nonatomic) IBOutlet UILabel *labelmileage;
/**
 *  时间
 */
@property (weak, nonatomic) IBOutlet UILabel *labeltime;
/**
 *  均速
 */
@property (weak, nonatomic) IBOutlet UILabel *labelacerage;
/**
 *  热量
 */
@property (weak, nonatomic) IBOutlet UILabel *labelheat;
/**
 *  极速
 */
@property (weak, nonatomic) IBOutlet UILabel *labelspeed;
/**
 *  海拔
 */
@property (weak, nonatomic) IBOutlet UILabel *labelelevation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *high;



@end
