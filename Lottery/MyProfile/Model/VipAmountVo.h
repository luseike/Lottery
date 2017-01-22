//
//  VipAmountVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/7/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  会员管理中的会员模型

#import <Foundation/Foundation.h>

@class AccountTotalVo;

@interface VipAmountVo : NSObject

@property(nonatomic,strong) VipVo *vip;

@property(nonatomic,strong) AccountTotalVo *amount;

@end
