//
//  UIButton+Extension.m
//  CarKey
//
//  Created by jiangyuanlu on 15/5/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import "UIButton+Extension.h"
#import "UIColor+Extension.h"

@implementation UIButton (Extension)

+(instancetype)buttonWithTitle:(NSString *)title color:(UIColor *)color rect:(CGRect)rect target:(id)target action:(SEL)action{
    UIButton *button=[[UIButton alloc] init];
    
    button.frame = rect;
    
//    button.backgroundColor = JYLColorWithA(250, 104, 27, 1);
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setBackgroundImage:[self buttonImageFromColor:color colorSize:rect.size] forState:UIControlStateNormal];
    [button setBackgroundImage:[self buttonImageFromColor:[UIColor grayColor] colorSize:rect.size] forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIImage *)buttonImageFromColor:(UIColor *)color colorSize:(CGSize)colorSize{
    
    CGRect rect = CGRectMake(0, 0, colorSize.width, colorSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
