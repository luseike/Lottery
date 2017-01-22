//
//  LotteryLHCNumberPanCellCell.m
//  Lottery
//
//  Created by 蒋远路 on 16/5/27.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LotteryLHCNumberPanCell.h"
#import "UIImage+ImageWithColor.h"
#import "LotteryNumberPanModel.h"

@interface LotteryLHCNumberPanCell()
@property (strong, nonatomic) UILabel *numberPanTypeLabel;
@property(nonatomic,strong) UIImageView *typeBgImgView;
@property (nonatomic,strong) UIView *seperateBtnsView;

@end


@implementation LotteryLHCNumberPanCell




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *typeBgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_pan_bg"]];
        self.typeBgImgView = typeBgImgView;
        [self addSubview:typeBgImgView];
        
        // 数字所在的位数
        UILabel *numberPanTypeLabel = [[UILabel alloc] init];
        numberPanTypeLabel.font = [UIFont systemFontOfSize:14];
        numberPanTypeLabel.textAlignment = NSTextAlignmentCenter;
        numberPanTypeLabel.textColor = RGB(145, 145, 145);
        [self addSubview:numberPanTypeLabel];
        self.numberPanTypeLabel = numberPanTypeLabel;
        
        UIView *seperateBtnsView = [[UIView alloc] init];
        [self addSubview:seperateBtnsView];
        self.seperateBtnsView = seperateBtnsView;
        
        UIView *underBtnLabelView = [[UIView alloc] init];
        [self addSubview:underBtnLabelView];
        self.underBtnLabelView = underBtnLabelView;
        
        UIView *numberBtnsView = [[UIView alloc] init];
        [self addSubview:numberBtnsView];
        self.numberBtnsView = numberBtnsView;
        
        NSArray *btnsArr = @[
                             @"01 DC3C32 猴",
                             @"11 8CC828 狗",
                             @"21 8CC828 鼠",
                             @"31 46AAE6 虎",
                             @"41 46AAE6 龙",
                             @"02 DC3C32 羊",
                             @"12 DC3C32 鸡",
                             @"22 8CC828 猪",
                             @"32 8CC828 牛",
                             @"42 46AAE6 兔",
                             @"03 46AAE6 马",
                             @"13 DC3C32 猴",
                             @"23 DC3C32 狗",
                             @"33 8CC828 鼠",
                             @"43 8CC828 虎",
                             @"04 46AAE6 蛇",
                             @"14 46AAE6 羊",
                             @"24 DC3C32 鸡",
                             @"34 DC3C32 猪",
                             @"44 8CC828 牛",
                             @"05 8CC828 龙",
                             @"15 46AAE6 马",
                             @"25 46AAE6 猴",
                             @"35 DC3C32 狗",
                             @"45 DC3C32 鼠",
                             @"06 8CC828 兔",
                             @"16 8CC828 蛇",
                             @"26 46AAE6 羊",
                             @"36 46AAE6 鸡",
                             @"46 DC3C32 猪",
                             @"07 DC3C32 虎",
                             @"17 8CC828 龙",
                             @"27 8CC828 马",
                             @"37 46AAE6 猴",
                             @"47 46AAE6 狗",
                             @"08 DC3C32 牛",
                             @"18 DC3C32 兔",
                             @"28 8CC828 蛇",
                             @"38 8CC828 羊",
                             @"48 46AAE6 鸡",
                             @"09 46AAE6 鼠",
                             @"19 DC3C32 虎",
                             @"29 DC3C32 龙",
                             @"39 8CC828 马",
                             @"49 8CC828 猴",
                             @"10 46AAE6 猪",
                             @"20 46AAE6 牛",
                             @"30 DC3C32 兔",
                             @"40 DC3C32 蛇"
                             ];
        
        //添加1到49  十个按钮
        for (NSInteger i = 0 ; i < btnsArr.count; i++) {
            NSArray *btnInfoArr = [btnsArr[i] componentsSeparatedByString:@" "];
            
            UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            numberBtn.adjustsImageWhenHighlighted = NO;
            
            [numberBtn setTitle:[btnInfoArr firstObject] forState:UIControlStateNormal];
            
            numberBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            numberBtn.layer.borderColor = RGB(198, 198, 198).CGColor;
            numberBtn.layer.borderWidth = 1.0;
            
            
            [numberBtn setTitleColor:[UIColor colorWithHexString:btnInfoArr[1]] forState:UIControlStateNormal];
            [numberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [numberBtn setBackgroundImage:[UIImage imageWithColor:numberBtn.currentTitleColor] forState:UIControlStateSelected];
            
            [numberBtn addTarget:self action:@selector(numberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.numberBtnsView addSubview:numberBtn];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = [btnInfoArr lastObject];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            [self.underBtnLabelView addSubview:label];
            if ([label.text isEqualToString:@"猴"]) {
                label.textColor = RGB(230, 160, 70);
            }else{
                label.textColor = RGB(135, 135, 135);
            }
        }
        
        NSArray *seperateArr = @[@"全",@"大",@"小",@"单",@"双",@"清"];
        for (NSString *str in seperateArr) {
            UIButton *seperateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [seperateBtn setTitle:str forState:UIControlStateNormal];
            
            
            seperateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [seperateBtn setTitleColor:RGB(135, 135, 135) forState:UIControlStateNormal];
            [seperateBtn addTarget:self action:@selector(seperateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.seperateBtnsView addSubview:seperateBtn];
        }
    }
    return self;
}

-(void)numberBtnClick:(UIButton *)numberBtn{
    if ([self.lhcDelegate respondsToSelector:@selector(LHCNumberPanCell:didSelectedNumberBtn:)]) {
        [self.lhcDelegate LHCNumberPanCell:self didSelectedNumberBtn:numberBtn];
    }
}

-(void)seperateBtnClick:(UIButton *)seperateBtn{
    if ([self.lhcDelegate respondsToSelector:@selector(LHCNumberPanCell:didSelectedSeperateBtn:)]) {
        [self.lhcDelegate LHCNumberPanCell:self didSelectedSeperateBtn:seperateBtn];
    }
}

-(void)setIsShowSeperateBtns:(BOOL)isShowSeperateBtns{
    self.seperateBtnsView.hidden = !isShowSeperateBtns;
}

-(void)setNumberPanModel:(LotteryNumberPanModel *)numberPanModel{
    _numberPanModel = numberPanModel;
    self.numberPanTypeLabel.text = numberPanModel.numberPanType;
    
    
    if (numberPanModel.selectStrings.length > 0) {
        NSString *tempStr = [[NSString alloc] init];        
        
        NSArray *selectedArr = [numberPanModel.selectStrings componentsSeparatedByString:@" "];
        for (NSInteger j = 0; j < self.numberBtnsView.subviews.count; j++) {
            UIButton *btn = [self.numberBtnsView.subviews objectAtIndex:j];
            if ([selectedArr containsObject:btn.currentTitle]) {
                btn.selected = YES;
                btn.layer.borderColor = [UIColor clearColor].CGColor;//RGB(203, 82, 46).CGColor;
                tempStr = [NSString appendObjStr:btn.currentTitle toSelectedStr:tempStr];//[NSString stringWithFormat:@"%@%@",tempStr,btn.currentTitle];
            }else{
                btn.selected = NO;
                btn.layer.borderColor = RGB(198, 198, 198).CGColor;
            }
        }
        numberPanModel.selectStrings = tempStr;
    }else{
        for (UIButton *btn in self.numberBtnsView.subviews) {
            btn.selected = NO;
            btn.layer.borderColor = RGB(198, 198, 198).CGColor;
        }
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.width = KScreenWidth;
    self.numberPanTypeLabel.x = 10;
    self.numberPanTypeLabel.y = 10;
    self.numberPanTypeLabel.width = KScreenWidth * 60 / KIPhone6Width;
    self.numberPanTypeLabel.height = KScreenHeight * 28 / KIPhone6Height;
    
    self.typeBgImgView.frame = self.numberPanTypeLabel.frame;
    CGFloat contentW = KScreenWidth - CGRectGetMaxX(self.typeBgImgView.frame) - 40;
    self.seperateBtnsView.frame = CGRectMake(CGRectGetMaxX(self.typeBgImgView.frame) + 20, self.typeBgImgView.y, contentW, self.numberPanTypeLabel.height);
    CGFloat seperateBtnW = self.numberPanTypeLabel.height;
    NSInteger seperateBtnsCount = self.seperateBtnsView.subviews.count;
    CGFloat seperateBtnMargin = (contentW - seperateBtnW * seperateBtnsCount) / (seperateBtnsCount - 1);
    for (NSInteger i = 0; i < self.seperateBtnsView.subviews.count; i++) {
        UIButton *btn = self.seperateBtnsView.subviews[i];
        btn.frame = CGRectMake((seperateBtnW + seperateBtnMargin) * i, 0, seperateBtnW, seperateBtnW);
    }
    
    // 数字按钮宽度
    CGFloat numberBtnW = (35 / KIPhone6Width) * KScreenWidth;
    // 数字按钮高度
    CGFloat numberBtnH = numberBtnW;
    // 列数
    NSUInteger maxColumn = 5;
    // 垂直间距
    NSInteger numberBtnRowMargin = (15 / KIPhone6Height) * KScreenHeight;//15;
    self.numberBtnsView.height = numberBtnH * 10 + numberBtnRowMargin * 9;
    self.numberBtnsView.width = contentW;
    self.numberBtnsView.x = self.seperateBtnsView.x;
    
    
    self.underBtnLabelView.width = contentW;
    self.underBtnLabelView.height = self.numberBtnsView.height;
    self.underBtnLabelView.x = self.numberBtnsView.x;
    
    if (self.seperateBtnsView.hidden) {
        self.numberBtnsView.y = self.numberPanTypeLabel.y;
    }else{
        self.numberBtnsView.y = CGRectGetMaxY(self.numberPanTypeLabel.frame) + 10;
    }
    self.underBtnLabelView.y = self.numberBtnsView.y;
    
    // 水平间距
    NSUInteger numberBtnColumnMargin = (self.numberBtnsView.width - numberBtnW * maxColumn) / (maxColumn - 1);
    for (NSInteger i = 0; i < self.numberBtnsView.subviews.count; i++) {
        UIButton *numberBtn = self.numberBtnsView.subviews[i];
        
        UILabel *label = self.underBtnLabelView.subviews[i];
        
        numberBtn.layer.cornerRadius = numberBtnH * 0.5;
        numberBtn.layer.masksToBounds = YES;
        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        numberBtn.frame = CGRectMake((numberBtnW + numberBtnColumnMargin) * column,(numberBtnH + numberBtnRowMargin + 10) * row,numberBtnW, numberBtnH);
        
        label.frame = CGRectMake(numberBtn.x, CGRectGetMaxY(numberBtn.frame) + 3, numberBtn.width, 12);
        if (i == self.numberBtnsView.subviews.count - 1) {
            self.numberBtnsView.height = CGRectGetMaxY(numberBtn.frame);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
