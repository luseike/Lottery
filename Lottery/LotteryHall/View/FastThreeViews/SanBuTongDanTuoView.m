//
//  SanBuTongDanTuoView.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/25.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "SanBuTongDanTuoView.h"

@interface SanBuTongDanTuoView()
@property (weak, nonatomic) IBOutlet UIView *danMaContainerView;
@property (weak, nonatomic) IBOutlet UIView *tuoMaContainerView;

@end

@implementation SanBuTongDanTuoView

-(void)awakeFromNib{
    [super awakeFromNib];
    // 添加7个numberView
    for (NSInteger i = 0; i < 6; i++) {
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.userInteractionEnabled = YES;
        numberLabel.text = [NSString stringWithFormat:@"%zd",i+1];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = [UIFont systemFontOfSize:18];
        
        numberLabel.layer.borderWidth = 1;
        numberLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.layer.cornerRadius = 2.0;
        numberLabel.layer.masksToBounds = YES;
        [self.danMaContainerView addSubview:numberLabel];
        [numberLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(danMaNumberLabelClick:)]];
    }
    // 添加7个numberView
    for (NSInteger i = 0; i < 6; i++) {
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.userInteractionEnabled = YES;
        numberLabel.text = [NSString stringWithFormat:@"%zd",i+1];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = [UIFont systemFontOfSize:18];
        
        numberLabel.layer.borderWidth = 1;
        numberLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.layer.cornerRadius = 2.0;
        numberLabel.layer.masksToBounds = YES;
        [self.tuoMaContainerView addSubview:numberLabel];
        [numberLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tuoMaNumberLabelClick:)]];
    }
}

-(void)danMaNumberLabelClick:(UITapGestureRecognizer *)tapGesture{
    UILabel *numberLabel = (UILabel *)tapGesture.view;
    if (numberLabel.backgroundColor == [UIColor whiteColor]) {
        if (self.danMaSelectedNumbers.length > 0) {
            NSArray *selectedDanMaArr = [self.danMaSelectedNumbers componentsSeparatedByString:@" "];
            if (selectedDanMaArr.count == 2) {
                [SVProgressHUD showInfoWithStatus:@"三不同号最多只能选择2个胆码"];
                return;
            }
        }
        numberLabel.backgroundColor = [UIColor colorWithHexString:@"eb5228"];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.layer.borderWidth = 0;
        
        
        //选中同号数字的索引
        NSInteger index = [self.danMaContainerView.subviews indexOfObject:numberLabel];
        UILabel *tuoMaAtIndexLabel = self.tuoMaContainerView.subviews[index];
        // 选中状态
        if (tuoMaAtIndexLabel.backgroundColor != [UIColor whiteColor]) {
            self.tuoMaSelectedNumbers = [NSString deleteObjStr:numberLabel.text fromSelectedStr:self.tuoMaSelectedNumbers];
            tuoMaAtIndexLabel.backgroundColor = [UIColor whiteColor];
            tuoMaAtIndexLabel.textColor = RGB(86, 86, 86);
            tuoMaAtIndexLabel.layer.borderWidth = 1;
            tuoMaAtIndexLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
        }
    }else{
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.layer.borderWidth = 1;
        numberLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
    }
    
    self.danMaSelectedNumbers = @"";
    for (UILabel *subNumberView in self.danMaContainerView.subviews) {
        //背景不是白色，说明已经被选中
        if (subNumberView.backgroundColor != [UIColor whiteColor]) {
            self.danMaSelectedNumbers = [NSString appendObjStr:subNumberView.text toSelectedStr:self.danMaSelectedNumbers];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SanBuTongDanTuoNumberViewClickNotification" object:nil userInfo:@{@"selectedNumbers":[NSString stringWithFormat:@"%@ %@",self.danMaSelectedNumbers.length > 0 ? self.danMaSelectedNumbers : @"",self.tuoMaSelectedNumbers.length > 0 ? self.tuoMaSelectedNumbers : @""]}];
}

-(void)tuoMaNumberLabelClick:(UITapGestureRecognizer *)tapGesture{
    UILabel *numberLabel = (UILabel *)tapGesture.view;
    if (numberLabel.backgroundColor == [UIColor whiteColor]) {
        
        if (self.tuoMaSelectedNumbers.length > 0) {
            NSArray *selectedTuoMaArr = [self.tuoMaSelectedNumbers componentsSeparatedByString:@" "];
            if (selectedTuoMaArr.count == 5) {
                [SVProgressHUD showInfoWithStatus:@"二不同号最多只能选择5个拖码"];
                return;
            }
        }
        
        numberLabel.backgroundColor = [UIColor colorWithHexString:@"eb5228"];
        numberLabel.layer.borderWidth = 0;
        numberLabel.textColor = [UIColor whiteColor];
//        self.tuoMaSelectedNumbers = [NSString appendObjStr:numberLabel.text toSelectedStr:self.tuoMaSelectedNumbers];
        
        //选中同号数字的索引
        NSInteger index = [self.tuoMaContainerView.subviews indexOfObject:numberLabel];
        UILabel *danMaAtIndexLabel = self.danMaContainerView.subviews[index];
        // 选中状态
        if (danMaAtIndexLabel.backgroundColor != [UIColor whiteColor]) {
            self.danMaSelectedNumbers = [NSString deleteObjStr:numberLabel.text fromSelectedStr:self.danMaSelectedNumbers];
            danMaAtIndexLabel.backgroundColor = [UIColor whiteColor];
            danMaAtIndexLabel.textColor = RGB(86, 86, 86);
            danMaAtIndexLabel.layer.borderWidth = 1;
            danMaAtIndexLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
        }
    }else{
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.layer.borderWidth = 1;
        numberLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
//        self.tuoMaSelectedNumbers = [NSString deleteObjStr:numberLabel.text fromSelectedStr:self.tuoMaSelectedNumbers];
    }
    
    self.tuoMaSelectedNumbers = @"";
    for (UILabel *subNumberView in self.tuoMaContainerView.subviews) {
        //背景不是白色，说明已经被选中
        if (subNumberView.backgroundColor != [UIColor whiteColor]) {
            self.tuoMaSelectedNumbers = [NSString appendObjStr:subNumberView.text toSelectedStr:self.tuoMaSelectedNumbers];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SanBuTongDanTuoNumberViewClickNotification" object:nil userInfo:@{@"selectedNumbers":[NSString stringWithFormat:@"%@ %@",self.danMaSelectedNumbers.length > 0 ? self.danMaSelectedNumbers : @"",self.tuoMaSelectedNumbers.length > 0 ? self.tuoMaSelectedNumbers : @""]}];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat viewMargin = 10;
    NSInteger maxColumn = 6;
    CGFloat viewWidth = (self.danMaContainerView.width - (maxColumn - 1) * viewMargin) / maxColumn;
    CGFloat viewHeight = viewWidth * 0.8;
    
    for (NSInteger i = 0; i < self.danMaContainerView.subviews.count; i++) {
        UILabel *numberLabel = (UILabel *)self.danMaContainerView.subviews[i];
        //        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        
        
        numberLabel.frame = CGRectMake((viewWidth + viewMargin) * column, 0,viewWidth, viewHeight);
    }
    for (NSInteger i = 0; i < self.tuoMaContainerView.subviews.count; i++) {
        UILabel *numberLabel = (UILabel *)self.tuoMaContainerView.subviews[i];
        //        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        
        
        numberLabel.frame = CGRectMake((viewWidth + viewMargin) * column, 0,viewWidth, viewHeight);
    }
}

-(void)clearAllSelected{
    for (UILabel *label in self.danMaContainerView.subviews) {
        if (label.backgroundColor != [UIColor whiteColor]) {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = RGB(86, 86, 86);
            label.layer.borderWidth = 1;
            label.layer.borderColor = RGB(221, 222, 226).CGColor;
            self.danMaSelectedNumbers = @"";
        }
    }
    for (UILabel *label in self.tuoMaContainerView.subviews) {
        if (label.backgroundColor != [UIColor whiteColor]) {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = RGB(86, 86, 86);
            label.layer.borderWidth = 1;
            label.layer.borderColor = RGB(221, 222, 226).CGColor;
            self.tuoMaSelectedNumbers = @"";
        }
    }
}


@end
