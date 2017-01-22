//
//  SinglePlayView.m
//  Lottery
//
//  Created by jiangyuanlu on 16/8/13.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "SinglePlayView.h"
#import "UIImage+ImageWithColor.h"

@interface SinglePlayView()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *playTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *playDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *bettingContentLabel;
@property (weak, nonatomic) IBOutlet UIView *unitBtnsView;
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnsViewHightContraint;

/**
 输入数字组成的数组
 */
@property (nonatomic,strong) NSMutableArray *bettingArr;
@end

@implementation SinglePlayView

-(NSMutableArray *)bettingArr{
    if (!_bettingArr) {
        _bettingArr = [NSMutableArray array];
    }
    return _bettingArr;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithHexString:@"f9f8f0"];
    self.playTipLabel.textColor = [UIColor orangeColor];
    self.selectedNumbersTextView.delegate = self;
    self.selectedNumbersTextView.layer.borderColor = [UIColor colorWithHexString:@"9e9e9e"].CGColor;
    self.selectedNumbersTextView.layer.borderWidth = 1;
    self.selectedNumbersTextView.layer.cornerRadius = 5;
    self.selectedNumbersTextView.layer.masksToBounds = YES;
    
    // 绘制任二、任三、任四的五个按钮
    NSArray *btnTitleArr = @[@"万位",@"千位",@"百位",@"十位",@"个位"];
    NSInteger btnsCount = btnTitleArr.count;
    CGFloat margin = 10;
    CGFloat totalW = KScreenWidth - 30;
    CGFloat btnW = (totalW - margin * (btnsCount - 1)) / btnsCount;
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake((btnW + margin) * i, 0, btnW, self.btnsViewHightContraint.constant);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"E03C1F"]] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [self.unitBtnsView addSubview:btn];
    }
    
    
    [self.selectedNumbersTextView becomeFirstResponder];
}

-(void)btnClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.layer.borderColor = [UIColor colorWithHexString:@"E03C1F"].CGColor;
    }else{
        btn.layer.borderColor = [UIColor grayColor].CGColor;
    }
    [self getBettingContentAndCountInTypeGrateEight];
    [self.delegate singlePlayViewClickDown:self.bettingCount bettingContent:self.bettingContent];
}

-(void)setSinglePlayViewType:(NSInteger)singlePlayViewType{
    _singlePlayViewType = singlePlayViewType;
    if (singlePlayViewType < 8) {
        self.unitBtnsView.hidden = YES;
        self.btnsViewHightContraint.constant = 0;
    }else{
        self.unitBtnsView.hidden = NO;
        self.btnsViewHightContraint.constant = 35;
        for (NSInteger i = 0; i < self.unitBtnsView.subviews.count; i++) {
            UIButton *btn = self.unitBtnsView.subviews[i];
            
            if (singlePlayViewType == 8 || singlePlayViewType == 9) {
                if (i > 2) {
                    btn.selected = YES;
                    btn.layer.borderColor = [UIColor colorWithHexString:@"E03C1F"].CGColor;
                }else{
                    btn.layer.borderColor = [UIColor grayColor].CGColor;
                }
            }else if (singlePlayViewType == 10 || singlePlayViewType == 11 || singlePlayViewType == 12){
                if (i > 1) {
                    btn.selected = YES;
                    btn.layer.borderColor = [UIColor colorWithHexString:@"E03C1F"].CGColor;
                }else{
                    btn.layer.borderColor = [UIColor grayColor].CGColor;
                }
            }else{
                if (i > 0) {
                    btn.selected = YES;
                    btn.layer.borderColor = [UIColor colorWithHexString:@"E03C1F"].CGColor;
                }else{
                    btn.layer.borderColor = [UIColor grayColor].CGColor;
                }
            }
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(singlePlayViewClickDown:bettingContent:)]) {
            
            [self validateSelectedNumbers:textView.text];
            [self.delegate singlePlayViewClickDown:self.bettingCount bettingContent:self.bettingContent];
        }
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.selectedNumbersTextView.isFirstResponder) {
        if ([self.delegate respondsToSelector:@selector(singlePlayViewClickDown:bettingContent:)]) {
            
            [self validateSelectedNumbers:self.selectedNumbersTextView.text];
            [self.delegate singlePlayViewClickDown:self.bettingCount bettingContent:self.bettingContent];
        }
    }
    
}


/*
 singlePlayViewType = 2;    //前二、后二单式
 singlePlayViewType = 3;    //前三、中三、后三单式
 singlePlayViewType = 4;    //前三、中三、后三 组三单式
 singlePlayViewType = 5;    //前三、中三、后三 组六单式
 singlePlayViewType = 6;    //四星单式
 singlePlayViewType = 7;    //五星单式
 
 
 singlePlayViewType = 8;    //任二直选单式
 singlePlayViewType = 9;    //任二组选单式
 singlePlayViewType = 10;    //任三直选单式
 singlePlayViewType = 11;    //任三 组三单式
 singlePlayViewType = 12;    //任三 组六单式
 singlePlayViewType = 13;    //任四 直选单式
 */

- (void)validateSelectedNumbers:(NSString *)selectedNumbers{
    [self.bettingArr removeAllObjects];
    NSLog(@"%zd----%@",self.singlePlayViewType,self.category.playedId);
    NSString *regex = @"";
    NSInteger numberLength = 0;
    if (self.singlePlayViewType == 2 || self.singlePlayViewType == 8 || self.singlePlayViewType == 9) {
        regex = @"^[0-9]{2,}(([,.; ])?([0-9]{2,})?)+$";
        numberLength = 2;
    }else if (self.singlePlayViewType == 3 || self.singlePlayViewType == 4 || self.singlePlayViewType == 5  || self.singlePlayViewType == 10 || self.singlePlayViewType == 11 || self.singlePlayViewType == 12){
        regex = @"^[0-9]{3,}(([,.; ])?([0-9]{3,})?)+$";
        numberLength = 3;
    }else if (self.singlePlayViewType == 6 || self.singlePlayViewType == 13){
        regex = @"^[0-9]{4,}(([,.; ])?([0-9]{4,})?)+$";
        numberLength = 4;
    }else{
        regex = @"^[0-9]{5,}(([,.; ])?([0-9]{5,})?)+$";
        numberLength = 5;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:selectedNumbers];
    if (isValid) {
        NSError *error = NULL;
        NSRegularExpression *regexNumbers = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray<NSTextCheckingResult *> *results = [regexNumbers matchesInString:selectedNumbers options:0 range:NSMakeRange(0, [selectedNumbers length])];
        
        
//        NSMutableArray *bettingArr = [NSMutableArray array];
        for (NSInteger i = 0; i < results.count; i++) {
            NSTextCheckingResult *result = results[i];
            if (result.range.length == numberLength) {
                NSString *singleCode= [selectedNumbers substringWithRange:result.range];
                if (self.singlePlayViewType == 4 || self.singlePlayViewType == 11) {
                    //如果是组三单式 输入的三个号码，必须有2个相同、1个不同，才算1注
                    NSInteger repeatCount = 0;
                    for (NSInteger i = 0; i < singleCode.length; i++) {
                        NSString *targetNumber = [singleCode substringWithRange:NSMakeRange(i, 1)];
                        for (NSInteger j = 0; j < singleCode.length; j++) {
                            if ([targetNumber isEqualToString:[singleCode substringWithRange:NSMakeRange(j, 1)]]) {
                                repeatCount++;
                            }
                        }
                        
                        if (repeatCount != 2) {
                            repeatCount = 0;
                        }else{
                            break;
                        }
                    }
                    if (repeatCount == 2) {
                        if (![self.bettingArr containsObject:singleCode]) {
                            [self.bettingArr addObject:singleCode];
                        }
                    }
                }else if (self.singlePlayViewType == 5 || self.singlePlayViewType == 12){
                    //组六单式玩法，输入3个号码，必须每个号码均不相同，才是1注
                    NSInteger repeatCount = 0;
                    // 拿出第一个数字
                    NSString *firstNumber = [singleCode substringWithRange:NSMakeRange(0, 1)];
                    for (NSInteger i = 1; i < singleCode.length; i++) {
                        NSString *targetNumber = [singleCode substringWithRange:NSMakeRange(i, 1)];
                        if ([firstNumber isEqualToString:targetNumber]) {
                            repeatCount++;
                            break;
                            
                        }
                    }
                    if (repeatCount == 0) {
                        if (![self.bettingArr containsObject:singleCode]) {
                            [self.bettingArr addObject:singleCode];
                        }
                    }
                }else{
                    if (![self.bettingArr containsObject:singleCode]) {
                        [self.bettingArr addObject:singleCode];
                    }
                }
            }
        }
        NSMutableString *bettingContent = [NSMutableString string];
        for (NSInteger i = 0; i < self.bettingArr.count; i++) {
            [bettingContent appendString:self.bettingArr[i]];
            if (i != self.bettingArr.count - 1) {
                [bettingContent appendString:@","];
            }
        }
        
        if (self.bettingArr.count > 0) {
            if (self.singlePlayViewType < 8) {
                NSString *bettingContentStr = [NSString stringWithFormat:@"投注内容：[%@]",bettingContent];
                NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:bettingContentStr];
                [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[bettingContentStr rangeOfString:bettingContent]];
                self.bettingContentLabel.attributedText = attriStr;
                
                self.bettingContent = bettingContent;
                self.bettingCount = self.bettingArr.count;
            }else{
                [self getBettingContentAndCountInTypeGrateEight];
            }
            
        }else{
            self.selectedNumbersTextView.text = @"";
            self.bettingContentLabel.text = @"";
        }
        
    }else{
        self.selectedNumbersTextView.text = @"";
        self.bettingContentLabel.text = @"";
    }
}

-(void)getBettingContentAndCountInTypeGrateEight{
    NSInteger selectBtnCount = 0;
    NSMutableString *selectBtnStr = [NSMutableString string];
    for (UIButton *btn in self.unitBtnsView.subviews) {
        if (btn.selected == YES) {
            selectBtnCount += 1;
            [selectBtnStr appendString:[[btn currentTitle] substringToIndex:1]];
        }
    }
    
    NSMutableString *numberContent = [NSMutableString string];
    for (NSInteger i = 0; i < self.bettingArr.count; i++) {
        [numberContent appendString:self.bettingArr[i]];
        if (i != self.bettingArr.count - 1) {
            [numberContent appendString:@","];
        }
    }
    
    /*
     singlePlayViewType = 8;    //任二直选单式
     singlePlayViewType = 9;    //任二组选单式
     singlePlayViewType = 10;    //任三直选单式
     singlePlayViewType = 11;    //任三 组三单式
     singlePlayViewType = 12;    //任三 组六单式
     singlePlayViewType = 13;    //任四 直选单式
     */
    switch (self.singlePlayViewType) {
        case 8: case 9:{
            if (selectBtnCount >= 2 && self.bettingArr.count > 0) {
                self.bettingCount = self.bettingArr.count * selectBtnCount * (selectBtnCount - 1) / 2;//selectBtnCount * self.bettingArr.count;
                self.bettingContent = [NSString stringWithFormat:@"%@ %@",selectBtnStr,numberContent];
                self.bettingContentLabel.text = [NSString stringWithFormat:@"投注内容：[%@]",self.bettingContent];
            }else{
                self.bettingCount = 0;
                self.bettingContent = @"";
                self.bettingContentLabel.text = @"";
            }
        }
            break;
        case 10: case 11: case 12:{
            if (selectBtnCount >= 3 && self.bettingArr.count > 0) {
                self.bettingCount = self.bettingArr.count * selectBtnCount * (selectBtnCount - 1) *(selectBtnCount - 2) / 6;
                self.bettingContent = [NSString stringWithFormat:@"%@ %@",selectBtnStr,numberContent];
                self.bettingContentLabel.text = [NSString stringWithFormat:@"投注内容：[%@]",self.bettingContent];
            }else{
                self.bettingCount = 0;
                self.bettingContent = @"";
                self.bettingContentLabel.text = @"";
            }
        }
            break;
        case 13:{
            if (selectBtnCount >= 4 && self.bettingArr.count > 0) {
                self.bettingCount = self.bettingArr.count * selectBtnCount * (selectBtnCount - 1) *(selectBtnCount - 2)*(selectBtnCount - 3) / 24;
                self.bettingContent = [NSString stringWithFormat:@"%@ %@",selectBtnStr,numberContent];
                self.bettingContentLabel.text = [NSString stringWithFormat:@"投注内容：[%@]",self.bettingContent];
            }else{
                self.bettingCount = 0;
                self.bettingContent = @"";
                self.bettingContentLabel.text = @"";
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)clearBettingContent{
    self.bettingContentLabel.text = @"";
    self.selectedNumbersTextView.text = @"";
}

-(void)setCategory:(PlayCategory *)category{
    _category = category;
    self.playDescLabel.text = category.playDesc;
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    
}

@end
