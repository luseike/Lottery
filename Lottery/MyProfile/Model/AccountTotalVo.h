//
//  AccountTotalVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/7/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  帐目汇总统计

#import <Foundation/Foundation.h>

@interface AccountTotalVo : NSObject
/**
 *  double	投资(即下注)总金额. 投资属于支出,此字段值一般为负数.
 */
@property(nonatomic,strong) NSNumber *orderAmount;
/**
 *  double	充值总额.
 */
@property(nonatomic,strong) NSNumber *rechargeAmount;
/**
 *  double	提现总额. 此字段值一般为负数.
 */
@property(nonatomic,strong) NSNumber *cashAmount;
/**
 *  double	返点总额.
 */
@property(nonatomic,strong) NSNumber *fdAmount;
/**
 *  double	中奖总额.
 */
@property(nonatomic,strong) NSNumber *jiangAmount;
/**
 *  String	统计时段(起始时间). 此字段值可能为空,为客户端调用接口时指定的dtB_参数的值原样返回.
 */
@property(nonatomic,copy) NSString *dtB;
/**
 *  String	统计时段(结束时间). 此字段值可能为空,为客户端调用接口时指定的dtE_参数的值原样返回.
 */
@property(nonatomic,copy) NSString *dtE;
/**
 *  辅助属性，当前amount对应的用户名
 */
@property(nonatomic,copy) NSString *nickName;


@end
