//
//  userinfoTableViewCell.m
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/23.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import "userinfoTableViewCell.h"
#import "tool.h"
@implementation userinfoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllview];
    }

    return self;


}
-(void)addAllview{
    self.leftlabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 30)];
    [self.contentView addSubview:self.leftlabel];
    self.righttextfield=[[UITextField alloc] initWithFrame:CGRectMake(100, 15, kscreenWidth-120, 30)];
    self.righttextfield.placeholder=@"编辑";
    self.righttextfield.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:self.righttextfield];




}





@end
