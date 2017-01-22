//
//  LotteryNumberPanCell.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/16.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Lottery27NumberPanCell,LotteryNumberPanModel;

@protocol Lottery27NumberPanCellDelegate <NSObject>

- (void)NumberPanCell:(Lottery27NumberPanCell *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn;
- (void)NumberPanCell:(Lottery27NumberPanCell *)numberPanView didSelectedSeperateBtn:(UIButton *)seperateBtn;
@end

@interface Lottery27NumberPanCell : UITableViewCell


@property (strong, nonatomic) UIView *numberBtnsView;

@property (nonatomic,strong) LotteryNumberPanModel *numberPanModel;

/**
 *  按钮是否从1开始
 */
@property(nonatomic,assign) BOOL isFromOne;


@property(nonatomic,weak) id<Lottery27NumberPanCellDelegate> number27PanCellDelegate;

@property (nonatomic,assign) BOOL isShowSeperateBtns;

@end
