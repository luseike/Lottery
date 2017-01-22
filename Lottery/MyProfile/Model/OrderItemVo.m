//
//  OrderItemVo.m
//  Lottery
//
//  Created by 蒋远路 on 16/6/13.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "OrderItemVo.h"

@implementation OrderItemVo

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"dataStr":@"data"};
}

@end
