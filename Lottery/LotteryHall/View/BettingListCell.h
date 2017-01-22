//
//  BettingListCell.h
//  Lottery
//
//  Created by 蒋远路 on 16/5/31.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BettingListModel,BettingListCell;

@protocol BettingListCellClickDelegate <NSObject>

-(void)BettingListCellDidClick:(BettingListCell *)listCell;

@end

@interface BettingListCell : UITableViewCell
@property(nonatomic,strong) BettingListModel *listModel;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,weak) id<BettingListCellClickDelegate> bettingListCellDelegate;
@end
