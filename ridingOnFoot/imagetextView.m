//
//  imagetextView.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/22.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "imagetextView.h"

@implementation imagetextView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addAllview];
    }
    return self;


}
-(void)addAllview{
    self.imageV=[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    [self addSubview:self.imageV];
    self.textField=[[UITextField alloc] initWithFrame:CGRectMake(50, 2, self.frame.size.width-50, self.frame.size.height-4)];
    [self addSubview:self.textField];



}

@end
