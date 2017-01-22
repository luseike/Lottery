//
//  OrderCheckView.h
//  Lottery
//
//  Created by 蒋远路 on 16/6/27.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCheckView : UIView
/**
 *  传一个字典，给订单确认view赋值
 */
@property(nonatomic,strong) NSDictionary *orderCheckDict;

@property(nonatomic,assign) BOOL isKuaiSan;

@property (nonatomic,strong) NSDictionary *kuaiSanDictParam;

-(void)repeatCommitWithParamDict:(NSDictionary *)commitParam;
@end
