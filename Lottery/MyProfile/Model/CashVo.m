//
//  CashVo.m
//  Lottery
//
//  Created by 蒋远路 on 16/6/12.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "CashVo.h"

@implementation CashVo

-(NSString *)dtAdd{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *addDate = [fmt dateFromString:_dtAdd];
    
    self.weekDay = addDate.weekDay;
    if (addDate.isThisYear) {
        if (addDate.isToday || addDate.isYeaterday) { // 昨天
            fmt.dateFormat = @"HH:mm";
            self.hourMinute = [fmt stringFromDate:addDate];
        } else { // 其他
            fmt.dateFormat = @"MM-dd";
            self.hourMinute = [fmt stringFromDate:addDate];
        }
    } else { // 非今年
        
    }
    return _dtAdd;
}

@end
