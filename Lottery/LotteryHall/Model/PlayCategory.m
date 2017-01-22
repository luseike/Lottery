//
//  PlayCategory.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/13.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "PlayCategory.h"
#import "MJExtension.h"

@implementation PlayCategory

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(NSDictionary *)mj_objectClassInArray{
    return @{@"numberPanModels":@"LotteryNumberPanModel"};
}

@end
