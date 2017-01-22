//
//  UIBarButtonItem+extension.h
//  CarKey
//
//  Created by 蒋远路 on 15/8/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (extension)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;

@end
