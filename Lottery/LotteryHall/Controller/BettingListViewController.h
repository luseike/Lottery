//
//  BettingListViewController.h
//  Lottery
//
//  Created by 蒋远路 on 16/5/30.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BettingListViewController : UIViewController
@property(nonatomic,strong) NSMutableArray *bettingData;

@property(nonatomic,strong) UIViewController *lotteryController;


@property (nonatomic,copy) NSString *lotteryTypeName;
@end
