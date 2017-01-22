//
//  LotteryNavigationController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LotteryNavigationController.h"
#import "UIBarButtonItem+extension.h"

@interface LotteryNavigationController ()

@end

@implementation LotteryNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = nil;
    
    [self setNavigationBarStyle];
}

-(void)setNavigationBarStyle{
    UINavigationBar *bar = [UINavigationBar appearance];
    
    [bar setBarTintColor:[UIColor colorWithHexString:@"FC9D2B"]];
    bar.translucent = NO;
    //导航栏文字属性
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [bar setTitleTextAttributes:barAttrs];
    
    //barButtonItem 文字样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
//    [itemAttrs setObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    [itemAttrs setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    
}


/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back" highImageName:@"back" target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [SVProgressHUD dismiss];
    [self popViewControllerAnimated:YES];
}

@end
