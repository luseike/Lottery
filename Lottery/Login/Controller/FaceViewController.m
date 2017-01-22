//
//  FaceViewController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/16.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "FaceViewController.h"
#import "LotteryTabBarController.h"
#import "TuYeTextField.h"
#import "MJExtension.h"
#import "RechargeActionViewController.h"

@interface FaceViewController ()<TuYeTextFieldDelegate>
@property (weak, nonatomic) IBOutlet TuYeTextField *userTextField;
@property (weak, nonatomic) IBOutlet TuYeTextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;

@end

@implementation FaceViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_userTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
   
    
    UIButton *holderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    holderBtn.frame = CGRectMake(0, 0, 45, 45);
    UIBarButtonItem *holderBarItem = [[UIBarButtonItem alloc]initWithCustomView:holderBtn];
    self.navigationItem.rightBarButtonItem = holderBarItem;
    
    UIImageView *leftUserImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 5, 23, 23)];
    [leftUserImageView setImage:[UIImage imageNamed:@"login_user"]];
    _userTextField.leftView = leftUserImageView;
    _userTextField.delegate = self;
    
    UIImageView *leftPwdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 5, 23, 23)];
    [leftPwdImageView setImage:[UIImage imageNamed:@"login_password"]];
    _pwdTextField.leftView = leftPwdImageView;
    _pwdTextField.delegate = self;
    
    _loginBtn.layer.cornerRadius = 3.0;
    [_loginBtn addTarget:self action:@selector(faceLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_forgetPwdBtn addTarget:self action:@selector(faceForgetPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


//button actions
- (void)cancelBtnClicked:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 登录

 @param sender 测试账号 xunihao  123456
 */
- (void)faceLoginBtnClicked:(UIButton *)sender{
    if (self.userTextField.text.length == 0) {
        SVProgressHUD.defaultMaskType = SVProgressHUDMaskTypeBlack;
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    if (self.pwdTextField.text.length == 0) {
        SVProgressHUD.defaultMaskType = SVProgressHUDMaskTypeBlack;
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    [SVProgressHUD show];
    [self.view endEditing:YES];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/login"] parameters:@{@"uid":self.userTextField.text,@"pwd":self.pwdTextField.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            [SVProgressHUD dismiss];
            VipVo *vip = [VipVo mj_objectWithKeyValues:[responseObject valueForKey:@"result"]];
            
            KSavePath(vip);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KLoginSuccessNotification" object:nil];
//            [self dismissViewControllerAnimated:YES completion:nil];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = [[LotteryTabBarController alloc] init];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];
}

- (void)faceForgetPwdBtnClick:(UIButton *)sender{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"请联系客服，找回登录密码" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alertVc) weakAlert = alertVc;
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
        NSString *baseUrl = @"http://kefu.qycn.com/vclient/chat/?m=m&websiteid=121720";
        RechargeActionViewController *rechargeVc = [[RechargeActionViewController alloc] init];
        rechargeVc.rechargeUrl = baseUrl;
        [self.navigationController pushViewController:rechargeVc animated:YES];
        
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - textField
- (BOOL)textFieldShouldReturn:(TuYeTextField *)textField{
    if(textField == _userTextField){
        return [_pwdTextField becomeFirstResponder];
    }else{
        return [_pwdTextField resignFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_userTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
