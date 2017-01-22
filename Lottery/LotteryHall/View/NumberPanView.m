//
//  NumberPanView.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "NumberPanView.h"
#import "UIImage+ImageWithColor.h"

@interface NumberPanView()
@property(nonatomic,strong) UILabel *typeLabel;
@property (strong, nonatomic) UIView *numbersView;
@property(nonatomic,strong) UIImageView *typeBgImgView;
@property(nonatomic,strong) UILabel *lineLabel;
@end

@implementation NumberPanView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *typeBgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_pan_bg"]];
        self.typeBgImgView = typeBgImgView;
        [self addSubview:typeBgImgView];
        
        // 数字所在的位数
        UILabel *typeLabel = [[UILabel alloc] init];
        typeLabel.font = [UIFont systemFontOfSize:14];
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.textColor = RGB(145, 145, 145);
        [self addSubview:typeLabel];
        self.typeLabel = typeLabel;
        
        UIView *numbersView = [[UIView alloc] init];
        [self addSubview:numbersView];
        self.numbersView = numbersView;
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = RGB(230, 230, 224);
        [self addSubview:lineLabel];
        self.lineLabel = lineLabel;
        
        //添加0到9  十个按钮
        for (NSInteger i = 0 ; i < 10; i++) {
            UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [numberBtn setTitle:[NSString stringWithFormat:@"%ld",(long)i] forState:UIControlStateNormal];
            
            
            numberBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            numberBtn.layer.borderColor = RGB(198, 198, 198).CGColor;
            numberBtn.layer.borderWidth = 1.0;
            [numberBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [numberBtn setBackgroundImage:[UIImage imageWithColor:RGB(203, 82, 46)] forState:UIControlStateSelected];
            [numberBtn setTitleColor:RGB(135, 135, 135) forState:UIControlStateNormal];
            [numberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [numberBtn addTarget:self action:@selector(numberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.numbersView addSubview:numberBtn];
        }
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}
-(void)setNumberPanCategory:(NSUInteger)numberPanCategory{
    switch (numberPanCategory) {
        case NumberPanTypeWan:
            self.typeLabel.text = @"万位";
            break;
        case NumberPanTypeQian:
            self.typeLabel.text = @"千位";
            break;
        case NumberPanTypeBai:
            self.typeLabel.text = @"百位";
            break;
        case NumberPanTypeShi:
            self.typeLabel.text = @"十位";
            break;
        case NumberPanTypeGe:
            self.typeLabel.text = @"个位";
            break;
        default:
            self.typeLabel.text = @"选号";
            break;
    }
}

-(void)numberBtnClick:(UIButton *)numberBtn{
    NSString *selectedNumber = numberBtn.currentTitle;
    if (self.numbersView.subviews.count == 4) {
        if (numberBtn.selected) {
            numberBtn.selected = NO;
            self.selectedNumbers = @"";
            
        }else{
            
            numberBtn.selected = YES;
            for (UIButton *btn in self.numbersView.subviews) {
                if (btn != numberBtn) {
                    btn.selected = NO;
                }
            }
            
            self.selectedNumbers = numberBtn.currentTitle;
        }
    }else{
        if (numberBtn.selected) {
            numberBtn.selected = NO;
            self.selectedNumbers = [self.selectedNumbers stringByReplacingOccurrencesOfString:selectedNumber withString:@""];
            
        }else{
            numberBtn.selected = YES;
            
            NSString *tempStr = [[NSString alloc] init];
            // 按照从小到大的顺序构建选择的数字
            for (UIButton *btn in self.numbersView.subviews) {
                if (btn.selected) {
                    tempStr = [NSString stringWithFormat:@"%@%@",tempStr,btn.currentTitle];
                }else{
                    continue;
                }
            }
            
            self.selectedNumbers = tempStr;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(NumberPanView:didSelectedNumberBtn:)]) {
        [self.delegate NumberPanView:self didSelectedNumberBtn:numberBtn];
    }
}

-(void)setIsShuangDan:(BOOL)isShuangDan{
    // 如果设定了是大小单双面板，删掉6个按钮，只保留四个
    NSLog(@"%zd",self.numbersView.subviews.count);
    for (NSInteger i = 0; i < 6; i++) {
        [[self.numbersView.subviews lastObject] removeFromSuperview];
    }
    // 修改按钮的文案
    for (NSInteger i = 0; i < self.numbersView.subviews.count; i++) {
        UIButton *btn = self.numbersView.subviews[i];
        if (i == 0) {
            [btn setTitle:@"大" forState:UIControlStateNormal];
        }else if (i == 1){
            [btn setTitle:@"小" forState:UIControlStateNormal];
        }else if (i == 2){
            [btn setTitle:@"单" forState:UIControlStateNormal];
        }else if (i == 3){
            [btn setTitle:@"双" forState:UIControlStateNormal];
        }
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.width = KScreenWidth;
    self.typeLabel.x = 10;
    self.typeLabel.y = 20;
    self.typeLabel.width = self.typeBgImgView.width;
    self.typeLabel.height = self.typeBgImgView.height;
    
    self.typeBgImgView.frame = self.typeLabel.frame;
    
    self.numbersView.width = self.width - self.typeBgImgView.width - self.typeBgImgView.x - 20 - 20;
    self.numbersView.height = self.height - 20 - 20;
    self.numbersView.x = CGRectGetMaxX(self.typeLabel.frame) + 20;
    self.numbersView.y = self.typeLabel.y;
    
    // 数字按钮宽度
    CGFloat numberBtnW = (40 / KIPhone6Width) * KScreenWidth;//(self.numbersView.width - ((maxColumn - 1) * columnMargin)) / maxColumn;
    // 数字按钮高度
    CGFloat numberBtnH = numberBtnW;
    // 列数
    NSUInteger maxColumn = 5;
    // 间距
    NSUInteger numberBtnColumnMargin = (self.numbersView.width - numberBtnW * maxColumn) / (maxColumn - 1);// (numberBtnW * 2);//10;
    if (self.numbersView.subviews.count == 4) {
        numberBtnColumnMargin = (self.numbersView.width - numberBtnW * 4) / (4 - 1);
    }
    NSInteger numberBtnRowMargin = self.numbersView.height - numberBtnH * 2;
    
    for (NSInteger i = 0; i < self.numbersView.subviews.count; i++) {
        UIButton *numberBtn = self.numbersView.subviews[i];
        numberBtn.layer.cornerRadius = numberBtnH * 0.5;
        numberBtn.layer.masksToBounds = YES;
        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        numberBtn.frame = CGRectMake((numberBtnW + numberBtnColumnMargin) * column,(numberBtnH + numberBtnRowMargin) * row,numberBtnW, numberBtnH);
    }
    self.lineLabel.frame = CGRectMake(0, self.height, self.width, 1);
}

-(void)clearChoose{
    for (UIButton *btn in self.numbersView.subviews) {
        if (btn.selected) {
            btn.selected = NO;
        }
    }
    self.selectedNumbers = @"";
}

@end
