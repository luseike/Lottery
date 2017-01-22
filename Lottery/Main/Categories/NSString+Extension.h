//
//  NSString+timerStr.h
//  CarKey
//
//  Created by 远路蒋 on 15/7/13.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  @param timeStamp 时间戳
 */
+(NSString *)dateWithTimeStamp:(NSString *)timeStamp withFormat:(NSString *)format;

+(NSString *)dateSinceNowWithTimeStamp:(NSString *)timeStamp withFormat:(NSString *)format;

+ (NSString *)stringWith:(long long)seconds;

#pragma mark - 从数字字符串中删除掉一个数字字符串
+(NSString *)deleteObjStr:(NSString *)objStr fromSelectedStr:(NSString *)selectedStr;

#pragma mark - 向数字字符串中添加一个数字字符串
+(NSString *)appendObjStr:(NSString *)objStr toSelectedStr:(NSString *)selectedStr;

#pragma mark - 直接向数字字符串中添加一个数字字符串（不用空格分隔）
+(NSString *)directAppendObjStr:(NSString *)objStr toSelectedStr:(NSString *)selectedStr;

#pragma mark - 将数组里的所有元素，用分隔符串联起来
+(NSString *)stringFromArray:(NSArray *)arr useSeperator:(NSString *)seperator;

#pragma mark - 将数组里的所有元素，用分隔符串联起来，内部字符串的空格用subSeperator替换
+(NSString *)stringFromArray:(NSArray *)arr useSeperator:(NSString *)seperator subSeperator:(NSString *)subSeperator;


@end
