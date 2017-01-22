//
//  LotteryPK10NumberPanCell.h
//  Lottery
//
//  Created by 蒋远路 on 16/5/26.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LotteryPK10NumberPanCell,LotteryNumberPanModel;

@protocol LotteryPK10NumberPanCellDelegate <NSObject>

- (void)PK10NumberPanCell:(LotteryPK10NumberPanCell *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn;

- (void)PK10NumberPanCell:(LotteryPK10NumberPanCell *)numberPanView didSelectedSeperateBtn:(UIButton *)seperateBtn;

@end

@interface LotteryPK10NumberPanCell : UITableViewCell

@property (strong, nonatomic) UIView *numberBtnsView;

@property (nonatomic,strong) LotteryNumberPanModel *numberPanModel;


@property(nonatomic,weak) id<LotteryPK10NumberPanCellDelegate> pk10Delegate;

@property (nonatomic,assign) BOOL isShowSeperateBtns;

@end
