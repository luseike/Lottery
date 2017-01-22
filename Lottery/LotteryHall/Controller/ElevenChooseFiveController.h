//
//  LotteryElevenChooseFiveController.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/17.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElevenChooseFiveController : UIViewController
/**
 *  彩种模型
 */
@property (nonatomic,strong) LotteryType *lotteryType;
/**
 *  十一选五控制器是否已经被modal过
 */
@property(nonatomic,assign) BOOL isElevenChooseFiveRepeatModal;;

@end
