//
//  NSString+timerStr.m
//  CarKey
//
//  Created by 远路蒋 on 15/7/13.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import "NSString+Extension.h"
#import "LotteryNumberPanModel.h"

@implementation NSString (Extension)

/**
 *   时间戳转时间的方法:
 *
 *  @param timeStamp 时间戳
 */
+(NSString *)dateWithTimeStamp:(NSString *)timeStamp withFormat:(NSString *)format{
    NSTimeInterval time=([timeStamp doubleValue]+28800)*0.001;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:format];
    NSString *resTime = [dateFormatter stringFromDate: detaildate];
    return resTime;
    
}


+(NSString *)dateSinceNowWithTimeStamp:(NSString *)timeStamp withFormat:(NSString *)format{
    NSTimeInterval time=([timeStamp doubleValue]+28800)*0.001;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSinceNow:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:format];
    NSString *resTime = [dateFormatter stringFromDate: detaildate];
    return resTime;
    
}

+ (NSString *)stringWith:(long long)seconds
{
    NSUInteger days = seconds / (3600 *24);
    
    NSUInteger hours = (seconds % (3600 * 24)) / 3600 ;
    
    NSUInteger mins =  (seconds % 3600 ) / 60;
    
    NSUInteger secs = (seconds % 3600 ) % 60;
    
    NSMutableString *dateStr = [NSMutableString new];
//    if (days > 0) {
//        [dateStr appendString:[NSString stringWithFormat:@"%lu天",(unsigned long)days]];
//    }
    if (hours > 0){
        [dateStr appendString:[NSString stringWithFormat:@"%lu小时",hours + days *24]];
    }
    if (mins >0){
        [dateStr appendString:[NSString stringWithFormat:@"%lu分",mins]];
    }
    if (secs > 0){
        [dateStr appendString:[NSString stringWithFormat:@"%lu秒",secs]];
    }
    
    return dateStr;
}


#pragma mark - 从数字字符串中删除掉一个数字字符串
+(NSString *)deleteObjStr:(NSString *)objStr fromSelectedStr:(NSString *)selectedStr{
    NSArray *selectedNumbers = [selectedStr componentsSeparatedByString:@" "];
    NSInteger index = [selectedNumbers indexOfObject:objStr];
    if ([selectedNumbers containsObject:objStr]) {
        if (selectedNumbers.count == 1) {
            // 如果要删除的字符串转成数组后只有一个元素，就没有“，”了，直接置空
            selectedStr = @"";
        }else{
            // 要删除objStr是在selectedStr的最后一个元素
            if (index == selectedNumbers.count - 1) {
                selectedStr = [selectedStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@",objStr] withString:@""];
            }else{
                selectedStr = [selectedStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ ",objStr] withString:@""];
            }
        }
    }
    return selectedStr;
}
#pragma mark - 向数字字符串中添加一个数字字符串
+(NSString *)appendObjStr:(NSString *)objStr toSelectedStr:(NSString *)selectedStr{
    NSString *tempStr = [[NSString alloc] init];
    if (selectedStr.length > 0) {
        tempStr = [NSString stringWithFormat:@"%@ %@",selectedStr,objStr];
    }else{
        tempStr = objStr;
    }
    return tempStr;
}

#pragma mark - 向数字字符串中添加一个数字字符串
+(NSString *)directAppendObjStr:(NSString *)objStr toSelectedStr:(NSString *)selectedStr{
    NSString *tempStr = [[NSString alloc] init];
    if (selectedStr.length > 0) {
        tempStr = [NSString stringWithFormat:@"%@%@",selectedStr,objStr];
    }else{
        tempStr = objStr;
    }
    return tempStr;
}

#pragma mark - 将数组里的所有元素，用分隔符串联起来
+(NSString *)stringFromArray:(NSArray *)arr useSeperator:(NSString *)seperator{
    NSInteger arrCount = arr.count;
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < arrCount; i++) {
        LotteryNumberPanModel *panM = arr[i];
        NSString *current = [panM.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (arrCount == 1) {
            resultStr.string = current;
        }else if(i < arrCount - 1){
            [resultStr appendString:current];
            [resultStr appendString:seperator];
        }else{
            [resultStr appendString:current];
        }
    }
    return resultStr;
}


+(NSString *)stringFromArray:(NSArray *)arr useSeperator:(NSString *)seperator subSeperator:(NSString *)subSeperator{
    NSInteger arrCount = arr.count;
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < arrCount; i++) {
        LotteryNumberPanModel *panM = arr[i];
        NSString *current = [panM.selectStrings stringByReplacingOccurrencesOfString:@" " withString:subSeperator];
        if (arrCount == 1) {
            resultStr.string = current;
        }else if(i < arrCount - 1){
            [resultStr appendString:current];
            [resultStr appendString:seperator];
        }else{
            [resultStr appendString:current];
        }
    }
    return resultStr;
}

@end
