//
//  CustomTextField.h
//  Lottery
//
//  Created by Chris Deng on 16/4/21.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTextField;

@protocol CustomTextFieldDelegate <UITextFieldDelegate>

@optional
- (BOOL)textFieldShouldBeginEditing:(CustomTextField *)textField;
- (void)textFieldDidBeginEditing:(CustomTextField *)textField;

- (BOOL)textFieldShouldEndEditing:(CustomTextField *)textField;
- (void)textFieldDidEndEditing:(CustomTextField *)textField;

- (BOOL)textFieldShouldReturn:(CustomTextField *)textField;

@end
@interface CustomTextField : UITextField

@end
