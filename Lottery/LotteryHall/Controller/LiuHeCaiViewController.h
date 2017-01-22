//
//  LiuHeCaiViewController.h
//  Lottery
//
//  Created by 蒋远路 on 16/5/27.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiuHeCaiViewController : UIViewController
/**
 *  彩种模型
 */
@property (nonatomic,strong) LotteryType *lotteryType;
/**
 *  六合彩控制器是否已经被modal过
 */
@property(nonatomic,assign) BOOL isLiuHeRepeatModal;

@end
