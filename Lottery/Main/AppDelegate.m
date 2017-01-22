//
//  AppDelegate.m
//  Lottery
//
//  Created by Chris Deng on 16/4/10.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "AppDelegate.h"
#import "LotteryTabBarController.h"
#import "LotteryNavigationController.h"
#import "FaceViewController.h"
#import "PersonalViewController.h"
//#import "SDGridItemCacheTool.h"

@interface AppDelegate (){
    UIImageView *luanchImageView;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [self checkNewVersion];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[LotteryTabBarController alloc] init];
    
    //用户是否登陆过
    VipVo *vip = KGetVip;
    if (vip == nil || vip.uid.length == 0) {
        //引导登录
        FaceViewController *faceVC = [[FaceViewController alloc]init];
        
        LotteryNavigationController *navVc = [[LotteryNavigationController alloc] initWithRootViewController:faceVC];
        faceVC.navigationItem.leftBarButtonItem = nil;
        navVc.navigationItem.title = @"登录";
        self.window.rootViewController = navVc;
    }else{
        [self checkNewVersion];
    }

    
    [self.window makeKeyAndVisible];
 
//    [self checkNewVersion];
    
    return YES;
}


-(void)checkNewVersion{
    NSString *appId = @"57a6f39d959d69147a0003fd";
    NSString *bundleIdUrlString = [NSString stringWithFormat:@"http://api.fir.im/apps/latest/%@?api_token=bc97f518cc22f22f18dda8cc53bef2bc&type=ios", appId];
    http://api.fir.im/apps/:id/download_token?api_token=xxxxx
    [[AFHTTPSessionManager manager] GET:bundleIdUrlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        __block NSString *newVersion = nil;
        __block NSString *changelog = nil;
        __block NSString *installUrl = nil;
        [responseObject enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"versionShort"]) {
                newVersion = obj;
            }
            if ([key isEqualToString:@"changelog"]) {
                changelog = obj;
            }
            if ([key isEqualToString:@"installUrl"]) {
                /* 这种方法没有排除掉URL里的=
                installUrl = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                
                */
                
                installUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                                NULL,
                                                                                                                (__bridge CFStringRef) obj,
                                                                                                                NULL,
                                                                                                                CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                                kCFStringEncodingUTF8));
            }
        }];
        
        
        NSString *localVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        
        if (![newVersion isEqualToString:localVersion]) {
            NSString *showStr = changelog.length == 0 ? @"有新版本了，建议您及时更新": changelog;
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"检测到新版本V%@！",newVersion] message:showStr preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(alertVc) weakAlertVc = alertVc;
            [alertVc addAction:[UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [weakAlertVc dismissViewControllerAnimated:YES completion:nil];
                
                NSString *downLoadUrlStr = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",installUrl];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downLoadUrlStr]];
            }]];
            
            [alertVc addAction:[UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakAlertVc dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [self.window.rootViewController presentViewController:alertVc animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}



- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


//弹出控制器
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion{
    [self.window.rootViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
}

#pragma mark - 异常信息打印
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}


@end
