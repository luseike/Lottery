//
//  ErTongHaoView.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/25.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "ErTongHaoView.h"

@interface ErTongHaoView()
@property (weak, nonatomic) IBOutlet UIView *tongHaoContainerView;
@property (weak, nonatomic) IBOutlet UIView *buTongHaoContainerView;
@property (weak, nonatomic) IBOutlet UIView *fuXuanContainerView;

@end

@implementation ErTongHaoView

-(void)awakeFromNib{
    [super awakeFromNib];
    // 添加6个numberView
    for (NSInteger i = 0; i < 6; i++) {
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.userInteractionEnabled = YES;
        numberLabel.text = [NSString stringWithFormat:@"%ld%ld",i+1,i+1];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = [UIFont systemFontOfSize:18];
        
        numberLabel.layer.borderWidth = 1;
        numberLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.layer.cornerRadius = 2.0;
        numberLabel.layer.masksToBounds = YES;
        [self.tongHaoContainerView addSubview:numberLabel];
        [numberLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tongHaoNumberLabelClick:)]];
    }
    // 添加6个numberView
    for (NSInteger i = 0; i < 6; i++) {
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.userInteractionEnabled = YES;
        numberLabel.text = [NSString stringWithFormat:@"%ld",i+1];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = [UIFont systemFontOfSize:18];
        
        numberLabel.layer.borderWidth = 1;
        numberLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.layer.cornerRadius = 2.0;
        numberLabel.layer.masksToBounds = YES;
        [self.buTongHaoContainerView addSubview:numberLabel];
        [numberLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buTongHaoNumberLabelClick:)]];
    }
    
    // 添加7个numberView
    for (NSInteger i = 0; i < 6; i++) {
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.userInteractionEnabled = YES;
        numberLabel.text = [NSString stringWithFormat:@"%ld%ld*",i+1,i+1];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = [UIFont systemFontOfSize:18];
        
        numberLabel.layer.borderWidth = 1;
        numberLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.layer.cornerRadius = 2.0;
        numberLabel.layer.masksToBounds = YES;
        
        [self.fuXuanContainerView addSubview:numberLabel];
        [numberLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fuXuanNumberLabelClick:)]];
    }
}

-(void)tongHaoNumberLabelClick:(UITapGestureRecognizer *)tapGesture{
    UILabel *numberLabel = (UILabel *)tapGesture.view;
    if (numberLabel.backgroundColor == [UIColor whiteColor]) {
        numberLabel.backgroundColor = [UIColor colorWithHexString:@"eb5228"];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.layer.borderWidth = 0;
        
        //选中同号数字的索引
        NSInteger index = [self.tongHaoContainerView.subviews indexOfObject:numberLabel];
        // 取出不同号
        UILabel *butongHaoLabel = self.buTongHaoContainerView.subviews[index];
        // 选中状态
        if (butongHaoLabel.backgroundColor != [UIColor whiteColor]) {
            butongHaoLabel.backgroundColor = [UIColor whiteColor];
            butongHaoLabel.textColor = RGB(86, 86, 86);
            butongHaoLabel.layer.borderWidth = 1;
            butongHaoLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
        }
    }else{
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.layer.borderWidth = 1;
        numberLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
    }
    
    [self setSelectedNumbers];
}

-(void)buTongHaoNumberLabelClick:(UITapGestureRecognizer *)tapGesture{
    UILabel *numberLabel = (UILabel *)tapGesture.view;
    if (numberLabel.backgroundColor == [UIColor whiteColor]) {
        numberLabel.backgroundColor = [UIColor colorWithHexString:@"eb5228"];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.layer.borderWidth = 0;
        //选中同号数字的索引
        NSInteger index = [self.buTongHaoContainerView.subviews indexOfObject:numberLabel];
        // 取出不同号
        UILabel *tongHaoLabel = self.tongHaoContainerView.subviews[index];
        // 选中状态
        if (tongHaoLabel.backgroundColor != [UIColor whiteColor]) {
            tongHaoLabel.backgroundColor = [UIColor whiteColor];
            tongHaoLabel.textColor = RGB(86, 86, 86);
            tongHaoLabel.layer.borderWidth = 1;
            tongHaoLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
        }
    }else{
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.layer.borderWidth = 1;
        numberLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
    }
    [self setSelectedNumbers];
}

-(void)fuXuanNumberLabelClick:(UITapGestureRecognizer *)tapGesture{
    UILabel *numberLabel = (UILabel *)tapGesture.view;
    if (numberLabel.backgroundColor == [UIColor whiteColor]) {
        numberLabel.backgroundColor = [UIColor colorWithHexString:@"eb5228"];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.layer.borderWidth = 0;
    }else{
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.layer.borderWidth = 1;
        numberLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
    }
    [self setSelectedNumbers];
}

-(void)setSelectedNumbers{
    self.tongHaoSelectedNumbers = @"";
    for (UILabel *label in self.tongHaoContainerView.subviews) {
        //当前label是选中的
        if (label.backgroundColor != [UIColor whiteColor]) {
            self.tongHaoSelectedNumbers = [NSString appendObjStr:label.text toSelectedStr:self.tongHaoSelectedNumbers];
        }
    }
    self.buTongHaoSelectedNumbers = @"";
    for (UILabel *label in self.buTongHaoContainerView.subviews) {
        //当前label是选中的
        if (label.backgroundColor != [UIColor whiteColor]) {
           self.buTongHaoSelectedNumbers = [NSString appendObjStr:label.text toSelectedStr:self.buTongHaoSelectedNumbers];
        }
    }
    self.fuXuanSelectedNumbers = @"";
    for (UILabel *label in self.fuXuanContainerView.subviews) {
        //当前label是选中的
        if (label.backgroundColor != [UIColor whiteColor]) {
           self.fuXuanSelectedNumbers = [NSString appendObjStr:label.text toSelectedStr:self.fuXuanSelectedNumbers];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ErTongHaoNumberViewClickNotification" object:nil userInfo:@{@"selectedNumbers":[NSString stringWithFormat:@"%@ %@ %@",self.tongHaoSelectedNumbers,self.buTongHaoSelectedNumbers,self.fuXuanSelectedNumbers]}];
}

-(void)clearAllSelected{
    for (UILabel *label in self.tongHaoContainerView.subviews) {
        if (label.backgroundColor != [UIColor whiteColor]) {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = RGB(86, 86, 86);
            label.layer.borderWidth = 1;
            label.layer.borderColor = RGB(221, 222, 226).CGColor;
            self.tongHaoSelectedNumbers = @"";
        }
    }
    for (UILabel *label in self.buTongHaoContainerView.subviews) {
        if (label.backgroundColor != [UIColor whiteColor]) {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = RGB(86, 86, 86);
            label.layer.borderWidth = 1;
            label.layer.borderColor = RGB(221, 222, 226).CGColor;
            self.buTongHaoSelectedNumbers = @"";
        }
    }
    for (UILabel *label in self.fuXuanContainerView.subviews) {
        if (label.backgroundColor != [UIColor whiteColor]) {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = RGB(86, 86, 86);
            label.layer.borderWidth = 1;
            label.layer.borderColor = RGB(221, 222, 226).CGColor;
            self.fuXuanSelectedNumbers = @"";
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat viewMargin = 10;
    NSInteger maxColumn = 6;
    CGFloat viewWidth = (self.tongHaoContainerView.width - (maxColumn - 1) * viewMargin) / maxColumn;
    CGFloat viewHeight = viewWidth * 0.8;
    
    for (NSInteger i = 0; i < self.tongHaoContainerView.subviews.count; i++) {
        UILabel *numberLabel = (UILabel *)self.tongHaoContainerView.subviews[i];
        //        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        
        
        numberLabel.frame = CGRectMake((viewWidth + viewMargin) * column, 0,viewWidth, viewHeight);
    }
    for (NSInteger i = 0; i < self.buTongHaoContainerView.subviews.count; i++) {
        UILabel *numberLabel = (UILabel *)self.buTongHaoContainerView.subviews[i];
        //        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        
        
        numberLabel.frame = CGRectMake((viewWidth + viewMargin) * column, 0,viewWidth, viewHeight);
    }
    for (NSInteger i = 0; i < self.fuXuanContainerView.subviews.count; i++) {
        UILabel *numberLabel = (UILabel *)self.fuXuanContainerView.subviews[i];
        //        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        
        
        numberLabel.frame = CGRectMake((viewWidth + viewMargin) * column, 0,viewWidth, viewHeight);
    }
}

@end
