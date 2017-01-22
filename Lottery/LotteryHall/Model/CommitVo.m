//
//  CommitVo.m
//  Lottery
//
//  Created by 蒋远路 on 16/7/4.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "CommitVo.h"
#import "CommitItemVo.h"

@implementation CommitVo

+(NSDictionary *)mj_objectClassInArray{
    return @{@"CommitItemVo":[CommitItemVo class]};
}
@end
