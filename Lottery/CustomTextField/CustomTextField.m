//
//  CustomTextField.m
//  Lottery
//
//  Created by Chris Deng on 16/4/21.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "CustomTextField.h"

#define PlaceholderColor UIColorFromRGB(0xd2d2d2);

@implementation CustomTextField

- (void)drawRect:(CGRect)rect {
    self.font = [UIFont systemFontOfSize:16];
    self.textColor = [UIColor darkGrayColor];
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.enablesReturnKeyAutomatically = YES;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        self.leftView = paddingView;
    }
    return self;
}

-(void)setUp{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.leftView = paddingView;
}

//编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width, bounds.size.height);
    return inset;
}

//显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width, bounds.size.height);
    return inset;
}

/*override placeholder*/
- (void)drawPlaceholderInRect:(CGRect)rect{
    rect.origin.y += 10;
    UIColor *placeholderColor = PlaceholderColor;
    [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:placeholderColor}];
}

@end
