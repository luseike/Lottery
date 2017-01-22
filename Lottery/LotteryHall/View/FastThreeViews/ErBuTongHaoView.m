//
//  ErBuTongHaoView.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/25.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "ErBuTongHaoView.h"

@interface ErBuTongHaoView()
@property (weak, nonatomic) IBOutlet UIView *numberContainerView;

@end

@implementation ErBuTongHaoView

-(void)awakeFromNib{
    [super awakeFromNib];
    // 添加7个numberView
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
        
        [self.numberContainerView addSubview:numberLabel];
        [numberLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberLabelClick:)]];
    }
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
    for (UILabel *subNumberView in self.numberContainerView.subviews) {
        //背景不是白色，说明已经被选中
        if (subNumberView.backgroundColor != [UIColor whiteColor]) {
            self.selectedNumbers = [NSString appendObjStr:subNumberView.text toSelectedStr:self.selectedNumbers];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ErBuTongHaoNumberViewClickNotification" object:nil userInfo:@{@"selectedNumbers":self.selectedNumbers}];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat viewMargin = 10;
    NSInteger maxColumn = 6;
    CGFloat viewWidth = (self.numberContainerView.width - (maxColumn - 1) * viewMargin) / maxColumn;
    CGFloat viewHeight = viewWidth * 0.8;
    
    for (NSInteger i = 0; i < self.numberContainerView.subviews.count; i++) {
        UILabel *numberLabel = (UILabel *)self.numberContainerView.subviews[i];
        //        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        
        
        numberLabel.frame = CGRectMake((viewWidth + viewMargin) * column, 0,viewWidth, viewHeight);
    }
}

-(void)clearAllSelected{
    for (UILabel *label in self.numberContainerView.subviews) {
        if (label.backgroundColor != [UIColor whiteColor]) {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = RGB(86, 86, 86);
            label.layer.borderWidth = 1;
            label.layer.borderColor = RGB(221, 222, 226).CGColor;
            self.selectedNumbers = @"";
        }
    }
}

@end
