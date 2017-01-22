//
//  CashVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/6/12.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CashVoStateToDo,
    CashVoStateConform,
    CashVoStateNotPass,
} CashVoState;

@interface CashVo : NSObject

/*
 cashId	long	提现申请ID
 amount	double	申请提现金额
 dtAdd	Date	申请时间。 格式：yyyy-MM-dd HH:mm:ss
 state	int	状态。 0:待处理 1:已确认 2：不通过
 */
/**
*  提现申请ID
*/
@property(nonatomic,copy) NSString *cashId;
/**
 *  申请提现金额
 */
@property(nonatomic,assign) CGFloat amount;
/**
 *  申请时间
 */
@property(nonatomic,copy) NSString *dtAdd;
/**
 *  申请时间是周几？
 */
@property(nonatomic,copy) NSString *weekDay;
/**
 *  申请时间的时分
 */
@property(nonatomic,copy) NSString *hourMinute;
/**
 *  状态。 0:待处理 1:已确认 2：不通过
 */
@property(nonatomic,assign) CashVoState state;
/**
 *  String	新增 （要提现到的）银行名称
 */
@property(nonatomic,copy) NSString *bankName;
/**
 *  String	新增 （要提现到的）银行卡号（或支付宝帐号）
 */
@property(nonatomic,copy) NSString *bankCard;
/**
 *  String	新增 （要提现到的）开户名
 */
@property(nonatomic,copy) NSString *bankUser;

/**
 审核失败备注
 */
@property (nonatomic,copy) NSString *cause;

@end
