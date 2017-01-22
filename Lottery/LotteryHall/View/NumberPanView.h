//
//  NumberPanView.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NumberPanType) {
    NumberPanTypeWan = 0,
    NumberPanTypeQian,
    NumberPanTypeBai,
    NumberPanTypeShi,
    NumberPanTypeGe
};

@class NumberPanView;

@protocol NumberPanViewDelegate <NSObject>

- (void)NumberPanView:(NumberPanView *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn;

@end

@interface NumberPanView : UIView
/**
 *  选中的数字
 */
@property(nonatomic,copy) NSString *selectedNumbers;
/**
 *  数字面板的类别 个、十、百、千、万
 */
@property(nonatomic,assign) NSUInteger numberPanCategory;

@property(nonatomic,weak) id<NumberPanViewDelegate> delegate;

/**
 *  是否是大小双单面板
 */
@property (nonatomic,assign) BOOL isShuangDan;
/**
 *  清空选择的数字
 */
-(void)clearChoose;
@end
