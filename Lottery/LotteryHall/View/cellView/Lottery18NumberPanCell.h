//
//  LotteryNumberPanCell.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/16.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Lottery18NumberPanCell,LotteryNumberPanModel;

@protocol Lottery18NumberPanCellDelegate <NSObject>

- (void)NumberPanCell:(Lottery18NumberPanCell *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn;
- (void)NumberPanCell:(Lottery18NumberPanCell *)numberPanView didSelectedSeperateBtn:(UIButton *)seperateBtn;
@end

@interface Lottery18NumberPanCell : UITableViewCell


@property (strong, nonatomic) UIView *numberBtnsView;

@property (nonatomic,strong) LotteryNumberPanModel *numberPanModel;

/**
 *  按钮是否从1开始
 */
@property(nonatomic,assign) BOOL isFromOne;


@property(nonatomic,weak) id<Lottery18NumberPanCellDelegate> number18PanCellDelegate;

@property (nonatomic,assign) BOOL isShowSeperateBtns;

@end
