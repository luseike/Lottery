//
//  LotteryElevenChooseFiveNumberPanCell.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/17.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LotteryElevenChooseFiveNumberPanCell,LotteryNumberPanModel;

@protocol LotteryElevenChooseFiveNumberPanCellDelegate <NSObject>

- (void)ElevenChooseFiveNumberPanCell:(LotteryElevenChooseFiveNumberPanCell *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn;
- (void)ElevenChooseFiveNumberPanCell:(LotteryElevenChooseFiveNumberPanCell *)numberPanView didSelectedSeperateBtn:(UIButton *)seperateBtn;
@end

@interface LotteryElevenChooseFiveNumberPanCell : UITableViewCell
/**
 *  选中的数字
 */
@property(nonatomic,copy) NSString *selectedNumbers;


@property (strong, nonatomic) UIView *numberBtnsView;

@property (nonatomic,strong) LotteryNumberPanModel *numberPanModel;


@property(nonatomic,weak) id<LotteryElevenChooseFiveNumberPanCellDelegate> customDelegate;

@property (nonatomic,assign) BOOL isShowSeperateBtns;

@property (nonatomic,assign) CGFloat cellHeight;

@end
