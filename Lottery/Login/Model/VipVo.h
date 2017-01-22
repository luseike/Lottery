//
//  VipVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/6/6.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  会员信息VO.

#import <Foundation/Foundation.h>

@interface VipVo : NSObject
/**
 *  用户ID
 */
@property(nonatomic,strong) NSNumber *vipId;
/**
 *  用户名
 */
@property(nonatomic,copy) NSString *uid;
/**
 *  用户唯一token安全校验码
 */
@property(nonatomic,copy) NSString *token;
/**
 *  用户当前可用余额
 */
@property(nonatomic,assign) CGFloat balance;
/**
 *  用户返点百分比上限值
 */
@property (nonatomic,assign) CGFloat    fdPst;
/**
 *  手机号
 */
@property(nonatomic,copy) NSString *mt;
/**
 *  电子邮件
 */
@property(nonatomic,copy) NSString *eml;
/**
 *  (推荐者)上级会员ID
 */
@property(nonatomic,assign) NSInteger tid;
/**
 *  （要提现到的）银行名称
 */
@property(nonatomic,copy) NSString *bankName;
/**
 *  （要提现到的）银行卡号（或支付宝帐号）
 */
@property(nonatomic,copy) NSString *bankCard;
/**
 *  （要提现到的）开户名
 */
@property(nonatomic,copy) NSString *bankUser;
/**
 *  QQ号码
 */
@property(nonatomic,copy) NSString *qq;
/**
 *  注册日期（格式：yyyy-MM-dd HH:mm:ss）
 */
@property(nonatomic,copy) NSString *dtAdd;
@end
