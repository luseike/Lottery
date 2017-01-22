//
//  ProductVo.h
//  Lottery
//
//  Created by 蒋远路 on 16/6/7.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductVo : NSObject
/**
 *  彩种ID(固定值，多个接口会用到)
 */
@property(nonatomic,copy) NSString *productId;

/**
 *  彩种名称
 */
@property(nonatomic,copy) NSString *name;
/**
 *  当前状态(0:正常 1: 停止销售)
 */
@property(nonatomic,assign) NSInteger state;
/**
 *  彩种图片
 */
@property(nonatomic,copy) NSString *pic;

@end
