//
//  BeiJingPK10ViewController.h
//  Lottery
//
//  Created by 蒋远路 on 16/5/25.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeiJingPK10ViewController : UIViewController
/**
 *  彩种模型
 */
@property (nonatomic,strong) LotteryType *lotteryType;
/**
 *  PK10控制器是否已经被modal过
 */
@property(nonatomic,assign) BOOL isPK10RepeatModal;

@end
