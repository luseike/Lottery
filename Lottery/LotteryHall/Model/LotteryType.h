//
//  LotteryType.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/10.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  彩种模型

#import <Foundation/Foundation.h>
@class ProductVo,PeriodVo;

@interface LotteryType : NSObject

@property(nonatomic,strong) ProductVo *productVo;
@property(nonatomic,strong) PeriodVo *periodVo;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) BOOL isFirstItem;
@end
