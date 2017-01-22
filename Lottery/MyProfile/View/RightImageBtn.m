//
//  RightImageBtn.m
//  MarshaLottery
//
//  Created by 蒋远路 on 17/1/13.
//  Copyright © 2017年 jiangyuanlu. All rights reserved.
//

#import "RightImageBtn.h"

@implementation RightImageBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.x -= self.imageView.width * 0.5;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 2;
}

@end
