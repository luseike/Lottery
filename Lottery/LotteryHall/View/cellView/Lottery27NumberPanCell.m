//
//  LotteryNumberPanCell.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/16.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "Lottery27NumberPanCell.h"
#import "UIImage+ImageWithColor.h"
#import "LotteryNumberPanModel.h"

@interface Lottery27NumberPanCell()
@property (strong, nonatomic) UILabel *numberPanTypeLabel;
@property(nonatomic,strong) UIImageView *typeBgImgView;
@property(nonatomic,strong) UILabel *lineLabel;
@property(nonatomic,strong) UIView *seperateBtnsView;

@end

@implementation Lottery27NumberPanCell

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
        
        UIView *numberBtnsView = [[UIView alloc] init];
        [self addSubview:numberBtnsView];
        self.numberBtnsView = numberBtnsView;
        
        UIView *seperateBtnsView = [[UIView alloc] init];
        [self addSubview:seperateBtnsView];
        self.seperateBtnsView = seperateBtnsView;
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = RGB(230, 230, 224);
        [self addSubview:lineLabel];
        self.lineLabel = lineLabel;
        
        for (NSInteger i = 0 ; i < 28; i++) {
            UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            numberBtn.adjustsImageWhenHighlighted = NO;
            [numberBtn setTitle:[NSString stringWithFormat:@"%ld",(long)i] forState:UIControlStateNormal];
            
            
            numberBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            numberBtn.layer.borderColor = RGB(198, 198, 198).CGColor;
            numberBtn.layer.borderWidth = 1.0;
            [numberBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [numberBtn setBackgroundImage:[UIImage imageWithColor:RGB(203, 82, 46)] forState:UIControlStateSelected];
            [numberBtn setTitleColor:RGB(135, 135, 135) forState:UIControlStateNormal];
            [numberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [numberBtn addTarget:self action:@selector(numberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.numberBtnsView addSubview:numberBtn];
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

-(void)setIsFromOne:(BOOL)isFromOne{
    if (isFromOne) {
        [[self.numberBtnsView.subviews firstObject] removeFromSuperview];
        [[self.numberBtnsView.subviews firstObject] removeFromSuperview];
        
        for (NSInteger i = 0; i < self.numberBtnsView.subviews.count; i++) {
            UIButton *numberBtn = self.numberBtnsView.subviews[i];
            [numberBtn setTitle:[NSString stringWithFormat:@"%ld",(long)i + 1] forState:UIControlStateNormal];
        }

    }
}

-(void)numberBtnClick:(UIButton *)numberBtn{
    
    if ([self.number27PanCellDelegate respondsToSelector:@selector(NumberPanCell:didSelectedNumberBtn:)]) {
        [self.number27PanCellDelegate NumberPanCell:self didSelectedNumberBtn:numberBtn];
    }
}

-(void)seperateBtnClick:(UIButton *)seperateBtn{
    if ([self.number27PanCellDelegate respondsToSelector:@selector(NumberPanCell:didSelectedSeperateBtn:)]) {
        [self.number27PanCellDelegate NumberPanCell:self didSelectedSeperateBtn:seperateBtn];
    }
}


-(void)setNumberPanModel:(LotteryNumberPanModel *)numberPanModel{
    _numberPanModel = numberPanModel;
    self.numberPanTypeLabel.text = numberPanModel.numberPanType;
    
    NSArray *selectedArr = [numberPanModel.selectStrings componentsSeparatedByString:@" "];
    if (numberPanModel.selectStrings.length > 0) {
        NSString *tempStr = [[NSString alloc] init];
        for (NSInteger j = 0; j < self.numberBtnsView.subviews.count; j++) {
            UIButton *btn = [self.numberBtnsView.subviews objectAtIndex:j];
            
            for (NSString *selectedEleStr in selectedArr) {
                if ([selectedEleStr isEqualToString:btn.currentTitle]) {
                    btn.selected = YES;
                    btn.layer.borderColor = RGB(203, 82, 46).CGColor;
                    tempStr = [NSString appendObjStr:btn.currentTitle toSelectedStr:tempStr];
                    break;
                }else{
                    btn.selected = NO;
                    btn.layer.borderColor = RGB(198, 198, 198).CGColor;
                }
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

-(void)setIsShowSeperateBtns:(BOOL)isShowSeperateBtns{
    self.seperateBtnsView.hidden = !isShowSeperateBtns;
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
    self.numberBtnsView.height = numberBtnH * 6 + numberBtnRowMargin * 5;
    self.numberBtnsView.width = contentW;
    self.numberBtnsView.x = self.seperateBtnsView.x;
    if (self.seperateBtnsView.hidden) {
        self.numberBtnsView.y = self.numberPanTypeLabel.y;
    }else{
        self.numberBtnsView.y = CGRectGetMaxY(self.numberPanTypeLabel.frame) + 10;
    }
    // 水平间距
    NSUInteger numberBtnColumnMargin = (self.numberBtnsView.width - numberBtnW * maxColumn) / (maxColumn - 1);
    for (NSInteger i = 0; i < self.numberBtnsView.subviews.count; i++) {
        UIButton *numberBtn = self.numberBtnsView.subviews[i];
        numberBtn.layer.cornerRadius = numberBtnH * 0.5;
        numberBtn.layer.masksToBounds = YES;
        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        numberBtn.frame = CGRectMake((numberBtnW + numberBtnColumnMargin) * column,(numberBtnH + numberBtnRowMargin) * row,numberBtnW, numberBtnH);
    }
    
    self.lineLabel.frame = CGRectMake(0, self.height, self.width, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
