//
//  NavigationTitleView.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "NavigationTitleView.h"

@implementation NavigationTitleView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"navigation_title_bg"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"navigation_title_bg"] forState:UIControlStateHighlighted];
        
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    self.height = 20;
    self.width = textSize.width + 30;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.width - 15, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
}

@end
