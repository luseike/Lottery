//
//  WithDrawViewController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/20.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "WithDrawViewController.h"
#import "CustomTextField.h"
#import <MJExtension.h>
#import "BankInfoViewController.h"
#import "BankInfoViewController.h"
#import "LotteryNavigationController.h"

@interface WithDrawViewController ()<CustomTextFieldDelegate>

//可提现金额
@property (weak, nonatomic) IBOutlet UILabel *canWithDrawLabel;
//输入提现金额
@property (weak, nonatomic) IBOutlet CustomTextField *withDrawTextField;
//确认提现
@property (weak, nonatomic) IBOutlet UIButton *withDrawConfirmBtn;
//资金密码
@property (weak, nonatomic) IBOutlet CustomTextField *pwd2TextField;
@end

@implementation WithDrawViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_withDrawTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    
    [self getUserInfo];
    
    
}

-(void)getUserInfo{
    /*
     vipId	int	是	当前登录会员的ID.
     vipToken	String	是	当前登录会员的token安全校验码。此值在会员登录时由服务器端返回(即VipVo.token).
     theVipId	Integer	否	要获取信息的会员ID,若不指定，则获取当前用户信息。
     */
    VipVo *vip = KGetVip;
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/getInfo"] parameters:@{@"vipId":vip.vipId,@"vipToken":vip.token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            VipVo *vip = [VipVo mj_objectWithKeyValues:[responseObject valueForKey:@"result"]];
            KSavePath(vip);
            _canWithDrawLabel.text = [NSString stringWithFormat:@"%.2f元",vip.balance];
            
            if (vip.bankCard.length == 0) {
                BankInfoViewController *bankInfoVc = [[BankInfoViewController alloc] init];
                bankInfoVc.isModal = YES;
                bankInfoVc.nav = (LotteryNavigationController *)self.navigationController;
                LotteryNavigationController *nav = [[LotteryNavigationController alloc] initWithRootViewController:bankInfoVc];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"获取个人信息失败"];
    }];
}

- (IBAction)withDrawConfirmBtnClicked:(UIButton *)sender{
    VipVo *vip = KGetVip;
    if (self.withDrawTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入提现金额"];
        [self.withDrawTextField becomeFirstResponder];
        return;
    }
    if (self.pwd2TextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入资金密码"];
        [self.pwd2TextField becomeFirstResponder];
        return;
    }
    if ([self.withDrawTextField.text doubleValue] > [self.canWithDrawLabel.text doubleValue]) {
        [SVProgressHUD showErrorWithStatus:@"提现金额不足，请重新输入"];
        self.withDrawTextField.text = @"";
        [self.withDrawTextField becomeFirstResponder];
        return;
    }
    /*
     vipId	int	是	当前登录会员的ID.
     vipToken	String	是	当前登录会员的token安全校验码。此值在会员登录时由服务器端返回(即VipVo.token).
     amount	提现金额
     */
    [SVProgressHUD show];
    NSDictionary *paramDict = @{
                                @"vipId":vip.vipId,
                                @"vipToken":vip.token,
                                @"amount":self.withDrawTextField.text,
                                @"bankName":vip.bankName,
                                @"bankCard":vip.bankCard,
                                @"bankUser":vip.bankUser,
                                @"pwd2":self.pwd2TextField.text
                                };
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"cash/add"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] == 200) {
            [self getUserInfo];
            [SVProgressHUD showSuccessWithStatus:@"提现成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"提现失败"];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(CustomTextField *)textField{
    return [_withDrawTextField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_withDrawTextField resignFirstResponder];
}


@end
