//
//  CellView.m
//  ridingOnFoot
//
//  Created by lanou3g on 16/3/27.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "CellView.h"
#import "tool.h"

@implementation CellView


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addView];
    }
    
    return self;
}



-(void)addView{
    
    self.firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,18, 14, 14)];
//    self.firstImageView.backgroundColor = [UIColor redColor];
    [self addSubview:self.firstImageView];
    
   self.contextLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.firstImageView.frame) + 10, 18, kscreenWidth/2 - 45, 20)];
    self.contextLabel.font = [UIFont systemFontOfSize:13];
    self.contextLabel.textColor = [UIColor grayColor];
    [self addSubview:self.contextLabel];
    

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
