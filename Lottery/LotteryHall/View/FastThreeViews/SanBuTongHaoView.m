//
//  SanBuTongHaoView.m
//  Lottery
//
//  Created by 蒋远路 on 16/5/24.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "SanBuTongHaoView.h"

@interface SanBuTongHaoView()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *lianHaoLabel;

@end

@implementation SanBuTongHaoView

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
        
        [self.containerView addSubview:numberLabel];
        [numberLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberLabelClick:)]];
    }
    
    self.lianHaoLabel.textColor = RGB(86, 86, 86);
    [self.lianHaoLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberLabelClick:)]];
    self.lianHaoLabel.layer.borderWidth = 1;
    self.lianHaoLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
    self.lianHaoLabel.backgroundColor = [UIColor whiteColor];
    self.lianHaoLabel.layer.cornerRadius = 2.0;
}

-(void)clearAllSelected{
    for (UILabel *label in self.containerView.subviews) {
        if (label.backgroundColor != [UIColor whiteColor]) {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = RGB(86, 86, 86);
            label.layer.borderWidth = 1;
            label.layer.borderColor = RGB(221, 222, 226).CGColor;
            self.selectedNumbers = @"";
        }
    }
    self.lianHaoLabel.textColor = RGB(86, 86, 86);
    self.lianHaoLabel.layer.borderWidth = 1;
    self.lianHaoLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
    self.lianHaoLabel.backgroundColor = [UIColor whiteColor];
    self.lianHaoLabel.layer.cornerRadius = 2.0;
}

-(void)numberLabelClick:(UITapGestureRecognizer *)tapGesture{
    UILabel *numberLabel = (UILabel *)tapGesture.view;
    if (numberLabel.backgroundColor == [UIColor whiteColor]) {
        numberLabel.backgroundColor = [UIColor colorWithHexString:@"eb5228"];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.layer.borderWidth = 0;
//        self.selectedNumbers = [NSString appendObjStr:numberLabel.text toSelectedStr:self.selectedNumbers];
    }else{
        numberLabel.backgroundColor = [UIColor whiteColor];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.layer.borderWidth = 1;
        numberLabel.layer.borderColor = RGB(221, 222, 226).CGColor;
//        self.selectedNumbers = [NSString deleteObjStr:numberLabel.text fromSelectedStr:self.selectedNumbers];
    }
    
    self.selectedNumbers = @"";
    for (UILabel *subNumberView in self.containerView.subviews) {
        //背景不是白色，说明已经被选中
        if (subNumberView.backgroundColor != [UIColor whiteColor]) {
            self.selectedNumbers = [NSString appendObjStr:subNumberView.text toSelectedStr:self.selectedNumbers];
        }
    }
    if (self.lianHaoLabel.backgroundColor != [UIColor whiteColor]) {
        self.selectedNumbers = [NSString appendObjStr:self.lianHaoLabel.text toSelectedStr:self.selectedNumbers];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SanBuTongHaoNumberViewClickNotification" object:nil userInfo:@{@"selectedNumbers":self.selectedNumbers}];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat viewMargin = 10;
    NSInteger maxColumn = 6;
    CGFloat viewWidth = (self.containerView.width - (maxColumn - 1) * viewMargin) / maxColumn;
    CGFloat viewHeight = viewWidth * 0.8;
    
    for (NSInteger i = 0; i < self.containerView.subviews.count; i++) {
        UILabel *numberLabel = (UILabel *)self.containerView.subviews[i];
        NSUInteger column = i % maxColumn;
        
        
        numberLabel.frame = CGRectMake((viewWidth + viewMargin) * column, 0,viewWidth, viewHeight);
    }
    
    self.lianHaoLabel.height = viewHeight;
}

@end
