//
//  NSDate+Extension.h
//  Lottery
//
//  Created by 蒋远路 on 16/6/8.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 *  传入日期，返回转换为当前时区的日期
 */
+ (NSDate *)getDateFromDateString:(NSString *)dateString;

/**
 *  比较from和self的时间差
 */
-(NSDateComponents *)deltaFrom:(NSDate *)from;
/**
 *  是否为今年
 */
-(BOOL)isThisYear;
/**
 *  是否为今天
 */
-(BOOL)isToday;
/**
 *  是否为昨天
 */
-(BOOL)isYeaterday;
/**
 *  是周几
 */
-(NSString *)weekDay;
@end
