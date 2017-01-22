//
//  UpdateLoginPWDViewController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/22.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "UpdateLoginPWDViewController.h"
#import "CustomTextField.h"
#import "RechargeActionViewController.h"

@interface UpdateLoginPWDViewController ()<CustomTextFieldDelegate>
//原始密码
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *replyPwdTextField;
//提交
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
//忘记密码
@property (weak, nonatomic) IBOutlet UIButton *forgetPWDBtn;

@end

@implementation UpdateLoginPWDViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.oldPwdTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理登录密码";
    self.oldPwdTextField.delegate = self;
    self.replyPwdTextField.delegate = self;
    self.view.backgroundColor = KBGColor;
}

/**
 *  忘记密码
 */
- (IBAction)forgetPWDBtnClicked:(UIButton *)sender{
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

/**
 *  提交密码修改
 */
- (IBAction)submitBtnClicked:(UIButton *)sender{
    if (self.oldPwdTextField.text.length == 0) {
        [self.oldPwdTextField becomeFirstResponder];
        [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
        return;
    }
    if (self.replyPwdTextField.text.length < 6 || self.replyPwdTextField.text.length > 12) {
        [self.replyPwdTextField becomeFirstResponder];
        [SVProgressHUD showErrorWithStatus:@"密码长度在6-12位之间"];
        return;
    }
    
    VipVo *vip = KGetVip;
    [SVProgressHUD show];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/editPwd"] parameters:@{@"vipId":vip.vipId,@"vipToken":vip.token,@"type":@"1",@"old":self.oldPwdTextField.text,@"pwd":self.replyPwdTextField.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"修改密码失败"];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - textField
- (BOOL)textFieldShouldReturn:(CustomTextField *)textField{
    if(textField == self.oldPwdTextField){
        return [self.replyPwdTextField becomeFirstResponder];
    }else{
        return [self.replyPwdTextField resignFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.oldPwdTextField resignFirstResponder];
    [self.replyPwdTextField resignFirstResponder];
}

@end
