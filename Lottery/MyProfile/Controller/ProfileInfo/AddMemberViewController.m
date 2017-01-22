//
//  AddMemberViewController.m
//  Lottery
//
//  Created by jiangyuanlu on 16/8/1.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "AddMemberViewController.h"

@interface AddMemberViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PassWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *PassWordRepeatTextField;
@property (weak, nonatomic) IBOutlet UITextField *FanDianTextField;
@property (weak, nonatomic) IBOutlet UITextField *EmailTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property(nonatomic,strong) NSMutableArray *needTransformTextFields;
@end

@implementation AddMemberViewController

-(NSMutableArray *)needTransformTextFields{
    if (!_needTransformTextFields) {
        _needTransformTextFields = [NSMutableArray array];
    }
    return _needTransformTextFields;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"添加会员";
    self.view.backgroundColor = KBGColor;
    self.commitBtn.layer.cornerRadius = 5;
    self.commitBtn.layer.masksToBounds = YES;
    
    VipVo *vip = KGetVip;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*请输入至少4位的用户名，至少6位的密码，返点率为0-%.2f的一个数字，可为小数，保留两位小数点",vip.fdPst]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    self.tipLabel.attributedText = attrStr;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.userNameTextField becomeFirstResponder];
}

-(void)keyBoardWillHide:(NSNotification *)notifi{
    NSLog(@"%@",notifi.userInfo);
    if (self.view.y != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.delegate = self;
            CGFloat textMaxY = CGRectGetMaxY(textField.frame);
            CGFloat maxYFlag = KScreenHeight - 300;
            if (textMaxY > maxYFlag) {
                [self.needTransformTextFields addObject:textField];
            }
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.needTransformTextFields containsObject:textField]) {
        CGFloat transFormY = CGRectGetMaxY(textField.frame) - (KScreenHeight - 350);
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -transFormY);
        }];
    }
    return YES;
}

- (IBAction)commitBtnClick:(UIButton *)sender {
    NSString *userName = self.userNameTextField.text;
    NSString *pwd = self.PassWordTextField.text;
    NSString *pwdRepeat = self.PassWordRepeatTextField.text;
    NSString *fanDian = self.FanDianTextField.text;
    NSString *email = self.EmailTextField.text;
    if (userName.length < 4) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名且长度不得小于4位"];
        [self.userNameTextField becomeFirstResponder];
        return;
    }
    if (pwd.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码且长度不得小于6位"];
        [self.PassWordTextField becomeFirstResponder];
        return;
    }

    if (![pwd isEqualToString:pwdRepeat]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致，请重新输入"];
        [self.PassWordRepeatTextField becomeFirstResponder];
        return;
    }
    if (fanDian.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入返点率"];
        [self.FanDianTextField becomeFirstResponder];
        return;
    }
    
    VipVo *vip = KGetVip;
    if ([fanDian floatValue] > vip.fdPst) {
        [SVProgressHUD showErrorWithStatus:@"返点率不得大于13"];
        [self.FanDianTextField becomeFirstResponder];
        return;
    }
    
    NSMutableDictionary *addParamDict = [NSMutableDictionary dictionary];
    [addParamDict setValue:vip.vipId forKey:@"vipId"];
    [addParamDict setValue:vip.token forKey:@"vipToken"];
    [addParamDict setValue:userName forKey:@"uid"];
    [addParamDict setValue:pwd forKey:@"pwd"];
    [addParamDict setValue:fanDian forKey:@"fdPst"];
    if (email.length > 0) {
        [addParamDict setValue:email forKey:@"eml"];
    }
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/add"] parameters:addParamDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            [SVProgressHUD showSuccessWithStatus:[responseObject valueForKey:@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"会员添加失败"];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
