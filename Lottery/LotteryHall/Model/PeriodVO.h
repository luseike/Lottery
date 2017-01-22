//
//  PeriodVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/6/7.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  彩票期次信息

#import <Foundation/Foundation.h>

@interface PeriodVo : NSObject

/**
 *  期次名称
 */
@property(nonatomic,copy) NSString *name;
/**
 *  该期次时间跨度（起始时间）。 格式：yyyy-MM-dd HH:mm:ss
 */
@property(nonatomic,copy) NSString *timeStart;
/**
 *  该期次时间跨度（结束时间）。 格式：yyyy-MM-dd HH:mm:ss
 */
@property(nonatomic,copy) NSString *timeEnd;
/**
 *  是否开奖 0:未开奖 1:已开奖
 */
@property(nonatomic,assign) NSInteger kjFlag;
/**
 *  开奖号码
 */
@property(nonatomic,copy) NSString *kjNum;

@end
