//
//  LotteryTypeView.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/10.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LotteryType;

@interface LotteryTypeView : UIView
@property (nonatomic,strong) LotteryType *typeModel;
@property (weak, nonatomic) IBOutlet UILabel *rightLineLabel;
@end
