//
//  OrderItemVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/6/13.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  下注条目明细

#import <Foundation/Foundation.h>

@interface OrderItemVo : NSObject
/**
 *  订单明细ID
 */
@property(nonatomic,copy) NSString *orderItemId;
/**
 *  玩法ID
 */
@property(nonatomic,copy) NSString *playedId;
/**
 *  玩法名称
 */
@property(nonatomic,copy) NSString *playedName;
/**
 *  订购内容
 */
@property(nonatomic,copy) NSString *dataStr;//*data;
/**
 *  注数
 */
@property(nonatomic,assign) NSInteger num;
/**
 *  价格(一般是一注2元,也就是2x注数)
 */
@property(nonatomic,assign) NSInteger jg;
/**
 *  下注倍数(默认值为1)
 */
@property (nonatomic,assign) NSInteger beis;
/**
 *  返点百分比（默认为0, 其值不得大于当前会员的VipVo.fdPst值）
 */
@property (nonatomic,assign) double fdPst;
/**
 *  元角分模式（ 1 :元 10 :角 100 :分）
 */
@property (nonatomic,assign) NSInteger unit;
@end
