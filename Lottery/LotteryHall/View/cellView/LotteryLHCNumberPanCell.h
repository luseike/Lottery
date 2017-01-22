//
//  LotteryLHCNumberPanCellCell.h
//  Lottery
//
//  Created by 蒋远路 on 16/5/27.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LotteryLHCNumberPanCell,LotteryNumberPanModel;

@protocol LotteryLHCNumberPanCellDelegate <NSObject>

- (void)LHCNumberPanCell:(LotteryLHCNumberPanCell *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn;

- (void)LHCNumberPanCell:(LotteryLHCNumberPanCell *)numberPanView didSelectedSeperateBtn:(UIButton *)seperateBtn;

@end

@interface LotteryLHCNumberPanCell : UITableViewCell

@property (strong, nonatomic) UIView *numberBtnsView;
@property (nonatomic,strong) UIView *underBtnLabelView;

@property (nonatomic,strong) LotteryNumberPanModel *numberPanModel;


@property(nonatomic,weak) id<LotteryLHCNumberPanCellDelegate> lhcDelegate;

@property (nonatomic,assign) BOOL isShowSeperateBtns;
@end
