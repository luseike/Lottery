//
//  UIImage+ImageWithColor.m
//  CarKey
//
//  Created by 蒋远路 on 15/12/3.
//  Copyright © 2015年 JYL. All rights reserved.
//

#import "UIImage+ImageWithColor.h"

@implementation UIImage (ImageWithColor)
+(UIImage *)imageWithColor:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, 10, 10));
    UIImage *pressedColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImage;
}
@end
