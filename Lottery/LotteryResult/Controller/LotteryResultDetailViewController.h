//
//  LotteryResultDetailViewController.h
//  Lottery
//
//  Created by Chris Deng on 16/4/17.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LotteryType;

@interface LotteryResultDetailViewController : UIViewController

@property (nonatomic,strong) LotteryType *result;
    
@property(nonatomic, assign) BOOL hiddenBottomView;



@end
