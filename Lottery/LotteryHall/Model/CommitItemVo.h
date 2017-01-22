//
//  CommitItemVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/7/4.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  用户选择的单条玩法投注信息

#import <Foundation/Foundation.h>

@interface CommitItemVo : NSObject
/**
 *  玩法ID
 */
@property(nonatomic,copy) NSString *playedId;
/**
 *  玩法名称
 */
@property(nonatomic,copy) NSString *playedName;
/**
 *  投注数据
 */
@property(nonatomic,copy) NSString *dataStr;
/**
 *  注数
 */
@property(nonatomic,assign) NSInteger num;
/**
 *  此条目的总价格
 */
@property(nonatomic,assign) double jg;
/**
 *  下注倍数(默认值为1)
 */
@property(nonatomic,assign) NSInteger beis;
/**
 *  返点百分比
 */
@property(nonatomic,assign) double fdPst;
/**
 *  元角分模式
 */
@property(nonatomic,assign) NSInteger unit;
@end
