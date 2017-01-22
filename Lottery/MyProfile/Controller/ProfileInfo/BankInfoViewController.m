//
//  BandBankInfoViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/8/16.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "BankInfoViewController.h"
#import "LotteryNavigationController.h"

@interface BankInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankUserTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation BankInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"银行账户信息";
    self.view.backgroundColor = KBGColor;
    VipVo *vip = KGetVip;
    if (vip.bankUser.length > 0) {
        self.bankNameTextField.text = vip.bankName;
        self.bankNameTextField.enabled = NO;
        self.bankCardTextField.text = vip.bankCard;
        self.bankCardTextField.enabled = NO;
        self.bankUserTextField.text = vip.bankUser;
        self.bankUserTextField.enabled = NO;
        self.commitBtn.hidden = YES;
    }else{
        self.bankNameTextField.placeholder = @"请输入开户银行";
        self.bankCardTextField.placeholder = @"请输入银行卡号";
        self.bankUserTextField.placeholder = @"请输入用户名";
    }
}

/**
 *  提交银行开户信息
 */
- (IBAction)commitBankInfo:(UIButton *)sender {
    if (self.bankNameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入开户银行"];
        [self.bankNameTextField becomeFirstResponder];
        return;
    }
    if (self.bankCardTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        [self.bankCardTextField becomeFirstResponder];
        return;
    }
    if (self.bankUserTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入开户名"];
        [self.bankUserTextField becomeFirstResponder];
        return;
    }
    VipVo *vip = KGetVip;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setValue:vip.mt forKey:@"mt"];
    [paramDict setValue:vip.eml forKey:@"eml"];
    [paramDict setValue:self.bankNameTextField.text forKey:@"bankName"];
    [paramDict setValue:self.bankCardTextField.text forKey:@"bankCard"];
    [paramDict setValue:self.bankUserTextField.text forKey:@"bankUser"];
    
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/editInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"银行账户信息提交成功！"];
//            [self.navigationController popViewControllerAnimated:YES];
            if (self.isModal) {
                [self.navigationController popViewControllerAnimated:YES];
                [self.nav popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {[SVProgressHUD showErrorWithStatus:@"银行账户信息提交失败"];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)setIsModal:(BOOL)isModal{
    _isModal = isModal;
    
    if (isModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
        [self.nav popToRootViewControllerAnimated:YES];
    }];
}


@end
