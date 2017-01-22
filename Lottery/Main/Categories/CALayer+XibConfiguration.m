//
//  CALayer+XibConfiguration.m
//  Lottery
//
//  Created by 蒋远路 on 16/6/13.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor *)borderUIColor{
    self.borderColor = borderUIColor.CGColor;
}

-(UIColor *)borderUIColor{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
