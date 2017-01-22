//
//  LotteryNumberPanModel.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/16.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotteryNumberPanModel : NSObject
/**
 *  数字面板的类型
 */
@property (nonatomic,copy) NSString *numberPanType;
/**
 *  选中的数字，保存在selectNumbersDict字典中
 */
@property (nonatomic,copy) NSString *selectStrings;

@end
