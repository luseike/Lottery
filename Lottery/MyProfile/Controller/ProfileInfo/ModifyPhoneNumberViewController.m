//
//  ModifyPhoneNumberViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/7/20.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "ModifyPhoneNumberViewController.h"

@interface ModifyPhoneNumberViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@end

@implementation ModifyPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号码修改";
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(modifyNumber)];
    
    VipVo *vip = KGetVip;
    self.phoneNumberTextField.text = vip.mt;
    
}

-(void)modifyNumber{
    VipVo *vip = KGetVip;
    if ([self.phoneNumberTextField.text isEqualToString:vip.mt]) {
        [SVProgressHUD showErrorWithStatus:@"请输入新手机号"];
        self.phoneNumberTextField.text = @"";
        [self.phoneNumberTextField becomeFirstResponder];
        return;
    }
    if ([self.phoneNumberTextField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        [self.phoneNumberTextField becomeFirstResponder];
        return;
    }
    
    NSString *mobileRegex = @"^(13|15|17|18|14)\\d{9}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileRegex];
    BOOL n = [mobileTest evaluateWithObject:self.phoneNumberTextField.text];
    
    if (n == NO) {
        [self.phoneNumberTextField becomeFirstResponder];
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
        return;
    }else{
        NSDictionary *paramDict = @{
                                    @"vipId": vip.vipId,
                                    @"vipToken": vip.token,
                                    @"mt": self.phoneNumberTextField.text,
                                    @"eml": vip.eml,
                                    @"bankName": vip.bankName,
                                    @"bankCard": vip.bankCard,
                                    @"bankUser": vip.bankUser
                                    };
        [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/editInfo"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"手机号码修改成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {[SVProgressHUD showErrorWithStatus:@"手机号码修改失败"];
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
