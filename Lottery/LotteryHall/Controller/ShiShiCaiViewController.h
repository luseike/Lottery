//
//  ShiShiCaiViewController.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RightImageBtn.h"

@interface ShiShiCaiViewController : UIViewController
/**
 *  彩种模型
 */
@property (nonatomic,strong) LotteryType *lotteryType;

@property (nonatomic,strong) NSArray *shishicaiDataSource;
/**
 *  时时彩控制器是否已经被modal过
 */
@property(nonatomic,assign) BOOL isShiShiCaiRepeatModal;
@end
