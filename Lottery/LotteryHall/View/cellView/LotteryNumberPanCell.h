//
//  LotteryNumberPanCell.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/16.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NumberPanCellType) {
    NumberPanCellTypeWan = 0,
    NumberPanCellTypeQian,
    NumberPanCellTypeBai,
    NumberPanCellTypeShi,
    NumberPanCellTypeGe
};

@class LotteryNumberPanCell,LotteryNumberPanModel;

@protocol LotteryNumberPanCellDelegate <NSObject>

- (void)NumberPanCell:(LotteryNumberPanCell *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn;
- (void)NumberPanCell:(LotteryNumberPanCell *)numberPanView didSelectedSeperateBtn:(UIButton *)seperateBtn;
@end

@interface LotteryNumberPanCell : UITableViewCell

@property (strong, nonatomic) UIView *numberBtnsView;

@property (nonatomic,strong) LotteryNumberPanModel *numberPanModel;


@property(nonatomic,weak) id<LotteryNumberPanCellDelegate> customDelegate;

@property (nonatomic,assign) BOOL isShowSeperateBtns;

@end
