//
//  BandBankInfoViewController.h
//  Lottery
//
//  Created by 蒋远路 on 16/8/16.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LotteryNavigationController;

@interface BankInfoViewController : UIViewController
@property(nonatomic,assign) BOOL isModal;

@property(nonatomic,strong) LotteryNavigationController *nav;
@end
