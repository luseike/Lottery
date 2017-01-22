//
//  PlayedVo.h
//  Lottery
//
//  Created by jiangyuanlu on 16/11/6.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayedVo : NSObject


/**
 赔率
 */
@property (nonatomic,assign) CGFloat jiang;

@property (nonatomic,assign) NSInteger numLimit;

@property (nonatomic,copy) NSString *playedId;
@end
