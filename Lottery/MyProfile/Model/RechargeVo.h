//
//  RechargeVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/7/18.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  充值记录Vo

#import <Foundation/Foundation.h>

@interface RechargeVo : NSObject
/**
 *  String	充值单号
 */
@property(nonatomic,copy) NSString *rechargeId;
/**
 *  double	充值金额
 */
@property(nonatomic,assign) CGFloat amount;
/**
 *  Date	充值时间（格式：yyyy-MM-dd HH:mm:ss）
 */
@property(nonatomic,copy) NSString *dtAdd;
/**
 int	支付类型,可用支付类型有(红色的为当前系统已开通了的支付方式)：
 0:未支付
 1:银联(未使用)
 2: 财富通(未使用)
 3:线下支付
 4:积分(未使用)
 5:支付宝(未使用)
 6:新生支付
 7:新贝支付
 */
@property(nonatomic,assign) NSInteger type;
/**
 *  String	在线支付流水单号
 */
@property(nonatomic,copy) NSString *payLshId;
/**
 *  String	备注
 */
@property(nonatomic,copy) NSString *remark;
/**
 *  申请时间是周几？
 */
@property(nonatomic,copy) NSString *weekDay;
/**
 *  申请时间的时分
 */
@property(nonatomic,copy) NSString *hourMinute;


@end
