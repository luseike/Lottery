//
//  OrderListTabButton.m
//  Lottery
//
//  Created by 蒋远路 on 16/9/1.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "OrderListTabButton.h"

@implementation OrderListTabButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(self.titleLabel.x, self.height - 1, self.titleLabel.width, 1);
}
@end
