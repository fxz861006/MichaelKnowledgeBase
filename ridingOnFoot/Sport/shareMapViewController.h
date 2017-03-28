//
//  mapViewController.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/22.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"
@class sportViewController;
@interface shareMapViewController :UIViewController<UMSocialUIDelegate>
@property(nonatomic,strong)UILabel *navtitle;
@property(nonatomic,strong)UIButton *backbtn;
@property(nonatomic,strong)UIView *navV;
@end
