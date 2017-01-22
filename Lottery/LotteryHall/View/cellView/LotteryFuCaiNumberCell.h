//
//  LotteryFuCaiNumberCell.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/17.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  福彩3D的自定义cell，与时时彩的cell很类似，逻辑复杂，所有另起一个

#import <UIKit/UIKit.h>

@class LotteryFuCaiNumberCell,LotteryNumberPanModel;

@protocol LotteryFuCaiNumberPanCellDelegate <NSObject>

- (void)FuCaiNumberPanCell:(LotteryFuCaiNumberCell *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn;
- (void)FuCaiNumberPanCell:(LotteryFuCaiNumberCell *)numberPanView didSelectedSeperateBtn:(UIButton *)seperateBtn;
@end

@interface LotteryFuCaiNumberCell : UITableViewCell
/**
 *  选中的数字
 */
//@property(nonatomic,copy) NSString *selectedNumbers;


@property (strong, nonatomic) UIView *numberBtnsView;

@property (nonatomic,strong) LotteryNumberPanModel *numberPanModel;


@property(nonatomic,weak) id<LotteryFuCaiNumberPanCellDelegate> customDelegate;

@property (nonatomic,assign) BOOL isShowSeperateBtns;
@end
