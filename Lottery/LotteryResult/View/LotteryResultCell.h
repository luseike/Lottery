//
//  LotteryResultCell.h
//  Lottery
//
//  Created by Chris Deng on 16/4/12.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LotteryType;

@interface LotteryResultCell : UITableViewCell

@property (nonatomic,strong) LotteryType *result;

@end
