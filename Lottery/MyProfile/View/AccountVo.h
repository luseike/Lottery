//
//  AccountVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/7/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  余额变动流水帐Vo

#import <Foundation/Foundation.h>

@interface AccountVo : NSObject


/**
 *  String	流水单据ID
 */
@property(nonatomic,copy) NSString *accountId;
/**
 *  Date	余额变动发生时间（格式：yyyy-MM-dd HH:mm:ss）
 */
@property(nonatomic,copy) NSString *dtAdd;
/**
 *  int	类型（暂定为：0: 购买, 1:充值, 2: 提现, 3:返点）
 */
@property(nonatomic,assign) NSInteger type;
/**
 *  double	变动金额。 正数为收入，负数为支出。
 */
@property(nonatomic,assign) CGFloat amount;
/**
 *  String	备注
 */
@property(nonatomic,copy) NSString *remark;

@end
