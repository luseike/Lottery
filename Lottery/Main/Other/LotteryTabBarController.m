//
//  LotteryTabBarController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/10.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LotteryTabBarController.h"
#import "LotteryHallViewController.h"
#import "LotteryResultViewController.h"
#import "PersonalViewController.h"
//#import "MyProfileViewController.h"
#import "LotteryNavigationController.h"

@implementation LotteryTabBarController

+ (void)initialize{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"fecb10"];
    
    UITabBarItem *item = [UITabBarItem appearance];
    UITabBar *tabbar = [UITabBar appearance];
    
    [tabbar setBarTintColor:[UIColor blackColor]];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加所有的子控制器
    [self addAllChildVcs];
}


-(void)addAllChildVcs{
    LotteryHallViewController *hallViewController = [[LotteryHallViewController alloc] init];
    [self addOneChlildVc:hallViewController title:@"大厅" imageName:@"tab_tool_home" selectedImageName:@"tab_tool_home_selected"];
    
    LotteryResultViewController *resultViewController = [[LotteryResultViewController alloc] init];
    [self addOneChlildVc:resultViewController title:@"开奖" imageName:@"tab_tool_trophy" selectedImageName:@"tab_tool_trophy_selected"];
    
//    MyProfileViewController *profileViewController = [[MyProfileViewController alloc] init];
    
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    PersonalViewController *profileInfoVc = (PersonalViewController *)sb.instantiateInitialViewController;
    
    
    
    
    [self addOneChlildVc:profileInfoVc title:@"个人" imageName:@"tab_tool_myprofile" selectedImageName:@"tab_tool_myprofile_selected"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    // 设置标题
    childVc.title = title;
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (IS_OS_7) {
        // 声明这张图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 添加为tabbar控制器的子控制器
    LotteryNavigationController *nav = [[LotteryNavigationController alloc] initWithRootViewController:childVc];
    [nav.navigationBar setTranslucent:NO];
    [self addChildViewController:nav];
}


@end
