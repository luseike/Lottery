//
//  OrderListCell.h
//  Lottery
//
//  Created by jiangyuanlu on 16/7/23.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderVo;

@interface OrderListCell : UITableViewCell
@property(nonatomic,strong) OrderVo *order;
@end
