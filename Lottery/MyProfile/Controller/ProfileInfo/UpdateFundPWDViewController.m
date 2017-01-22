//
//  UpdateFundPWDViewController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/22.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "UpdateFundPWDViewController.h"
#import "CustomTextField.h"
#import "RechargeActionViewController.h"

@interface UpdateFundPWDViewController ()<CustomTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *fundOriPWDTextField;
@property (weak, nonatomic) IBOutlet UITextField *fundNewPWDTextField;
@property (weak, nonatomic) IBOutlet UIButton *fundSubmitBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetFundPWDBtn;

@end

@implementation UpdateFundPWDViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_fundOriPWDTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理资金密码";
    self.view.backgroundColor = KBGColor;
    _fundOriPWDTextField.placeholder = @"请输入当前资金密码";
    _fundOriPWDTextField.delegate = self;
    _fundNewPWDTextField.delegate = self;
    
        
}

- (IBAction)fundSubmitBtnClicked:(UIButton *)sender{
    if (self.fundOriPWDTextField.text.length == 0) {
        [self.fundOriPWDTextField becomeFirstResponder];
        [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
        return;
    }
    if (self.fundNewPWDTextField.text.length < 8 || self.fundNewPWDTextField.text.length > 12) {
        [self.fundNewPWDTextField becomeFirstResponder];
        [SVProgressHUD showErrorWithStatus:@"密码长度在8-12位之间"];
        return;
    }
    VipVo *vip = KGetVip;
    [SVProgressHUD show];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/editPwd"] parameters:@{@"vipId":vip.vipId,@"vipToken":vip.token,@"type":@"2",@"old":self.fundOriPWDTextField.text,@"pwd":self.fundNewPWDTextField.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] == 200) {
            [SVProgressHUD showSuccessWithStatus:@"资金密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"修改资金密码失败"];
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)forgetFundPWDBtnClicked:(UIButton *)sender{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"请联系客服，找回资金密码" preferredStyle:UIAlertControllerStyleAlert];
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
- (BOOL)textFieldShouldReturn:(CustomTextField *)textField{
    if(textField == _fundOriPWDTextField){
        return [_fundNewPWDTextField becomeFirstResponder];
    }else{
        return [_fundNewPWDTextField resignFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_fundOriPWDTextField resignFirstResponder];
    [_fundNewPWDTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
