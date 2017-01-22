//
//  BettingListModel.h
//  Lottery
//
//  Created by 蒋远路 on 16/5/31.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BettingListModel : NSObject
/*
 @property (weak, nonatomic) IBOutlet UILabel *selectedNumbersLabel;
 @property (weak, nonatomic) IBOutlet UILabel *playCateryLabel;
 @property (weak, nonatomic) IBOutlet UILabel *bettingMoneyLabel;
 */

/**
*  选中的数字
*/
@property(nonatomic,copy) NSString *selectedNumbers;
/**
 *  选择的玩法
 */
@property(nonatomic,copy) NSString *playCatery;
/**
 *  注数
 */
@property(nonatomic,assign) NSUInteger bettingCount;
@end
