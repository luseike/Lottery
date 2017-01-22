//
//  LotteryType.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/10.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LotteryType.h"

@implementation LotteryType

-(CGFloat)cellHeight{
    NSLog(@"%@",self.periodVo.kjNum);
    if (self.periodVo.kjNum == nil) {
        return 40;
    }else{
        return 80;
    }
}

@end
