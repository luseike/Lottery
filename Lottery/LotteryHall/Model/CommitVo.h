//
//  CommitVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/7/4.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  下单投注时,客户端向服务器端传输的投注信息

#import <Foundation/Foundation.h>

@interface CommitVo : NSObject

/**
*  所属彩种的ID
*/
@property(nonatomic,copy) NSString *productId;
/**
 *  期次名称
 */
@property(nonatomic,copy) NSString *period;
/**
 *  下注条目明细项数组
 */
@property(nonatomic,strong) NSArray *CommitItemVo;
/**
 *  本次投注的总金额
 */
@property(nonatomic,assign) double jg;
@end
