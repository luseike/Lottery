//
//  ProductFormVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/7/28.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  进入彩票购买页,返回的某彩票Form信息VO。

#import <Foundation/Foundation.h>
@class ProductVo,PeriodVo;

@interface ProductFormVo : NSObject
/**
 *  服务器系统的当前时间,为保证服务器和客户端时间一致，请客户端务必使用此字段来进行计时操作。
 */
@property(nonatomic,copy) NSString *now;
/**
 *  彩种基本信息
 */
@property(nonatomic,strong) ProductVo *product;
/**
 *  彩种当前期次信息
 */
@property(nonatomic,strong) PeriodVo *period;
/**
 *  新增 最近已开奖的的几个期次信息(期次内含开奖号码, 按时间降序排列)
 */
@property(nonatomic,strong) NSArray *periods;
@end
