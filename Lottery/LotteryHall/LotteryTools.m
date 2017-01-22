//
//  LotteryTools.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/14.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LotteryTools.h"

@implementation LotteryTools

static LotteryTools * lotteryTool = nil;

+(LotteryTools *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lotteryTool = [[LotteryTools alloc] init];
        
    });
    return lotteryTool;
}

@end
