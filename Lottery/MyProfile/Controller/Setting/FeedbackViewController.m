//
//  FeedbackViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/5/30.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIImage+ImageWithColor.h"

@interface FeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *suggestionTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneQQNumberField;
@property (weak, nonatomic) IBOutlet UIButton *feedbackBtn;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, copy) NSString *feedbackText;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    
    [self setupUI];
}

- (void)setupUI {
    
    self.placeholderText = @"请输入反馈信息";
    
    self.suggestionTextView.layer.borderWidth = 1;
    self.suggestionTextView.layer.borderColor = RGB(217, 184, 129).CGColor;
    self.suggestionTextView.layer.cornerRadius = 3;
    self.suggestionTextView.textColor = RGB(178, 178, 185);
    self.suggestionTextView.text = self.placeholderText;
    self.suggestionTextView.delegate = self;
    
    self.phoneQQNumberField.layer.borderWidth = 1;
    self.phoneQQNumberField.layer.borderColor = RGB(217, 184, 129).CGColor;
    self.phoneQQNumberField.layer.cornerRadius = 3;
    self.phoneQQNumberField.delegate = self;
    
    self.feedbackBtn.layer.cornerRadius = 3;
    [self.feedbackBtn setBackgroundImage:[UIImage imageWithColor:RGB(250, 193, 18)] forState:UIControlStateNormal];
    [self.feedbackBtn setBackgroundImage:[UIImage imageWithColor:RGB(243, 229, 166)] forState:UIControlStateDisabled];
    self.feedbackBtn.enabled = YES;
    
    [self.suggestionTextView becomeFirstResponder];
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:self.placeholderText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

//-(void)textViewDidEndEditing:(UITextView *)textView {
//    if ([textView.text isEqualToString:@""]) {
//        textView.textColor = RGB(178, 178, 185);
//        textView.text = self.placeholderText;
//        self.feedbackBtn.enabled = NO;
//    } else {
//        if (self.phoneQQNumberField.text.length > 0 && ![textView.text isEqualToString:self.placeholderText]) {
//            self.feedbackBtn.enabled = YES;
//        }
//    }
//}

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.text.length > 0 && ![self.suggestionTextView.text isEqualToString:self.placeholderText]) {
//        self.feedbackBtn.enabled = YES;
//    }else{
//        self.feedbackBtn.enabled = NO;
//    }
//}

- (IBAction)submitFeedback:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.suggestionTextView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请您输入反馈信息"];
        [self.suggestionTextView becomeFirstResponder];
        return;
    }
    if (self.phoneQQNumberField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请您输入手机或QQ号"];
        [self.phoneQQNumberField becomeFirstResponder];
        return;
    }
    [SVProgressHUD showWithStatus:@"提交中..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)submitFeedback {
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.suggestionTextView isFirstResponder]) {
        [self.suggestionTextView resignFirstResponder];
    }
    if ([self.phoneQQNumberField isFirstResponder]) {
        [self.phoneQQNumberField resignFirstResponder];
    }
}

@end
