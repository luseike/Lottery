//
//  OrderVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/6/13.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PeriodVo,ProductVo;
@interface OrderVo : NSObject
/**
 *  订单ID
 */
@property(nonatomic,copy) NSString *orderId;

/**
 *  ProductVo
 */
@property(nonatomic,strong) ProductVo *product;

/**
 *  下单时间。格式：yyyy-MM-dd HH:mm:ss
 */
@property(nonatomic,copy) NSString *dtAdd;
/**
 *  期次
 */
@property(nonatomic,strong) PeriodVo *period;
/**
 *  下注倍数(默认值为1)
 */
@property(nonatomic,assign) NSInteger beis;
/**
 *  总注数(不含倍数)
 */
@property(nonatomic,assign) NSInteger num;
/**
 *  总金额
 */
@property(nonatomic,strong) NSNumber *jg;
/**
 *  下注条目明细项数组 OrderItemVo
 */
@property(nonatomic,strong) NSArray *items;
/**
 *  返点金额（仅在开奖后有值）
 */
@property(nonatomic,assign) double fd;
/**
 *  若中奖，则此字段显示中奖金额。
 */
@property(nonatomic,strong) NSNumber *jiang;
/**
 *   状态： 0:待开奖 1:开奖中 2:未中奖 3:已派奖(即中奖了)
 */
@property(nonatomic,assign) NSInteger state;
/**
 *   是(true)否(false)允许撤单
 */
@property(nonatomic,assign) BOOL canKillOrder;

@end
