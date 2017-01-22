//
//  AccountTotalCell.m
//  Lottery
//
//  Created by 蒋远路 on 16/7/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "AccountListCell.h"
#import "AccountVo.h"


@interface AccountListCell()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiangJinInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTypeLabel;

@end

@implementation AccountListCell

-(void)setAccount:(AccountVo *)account{
    _account = account;
    
    NSString *dateStr =  account.dtAdd;
    NSDate *addDate = [NSDate getDateFromDateString:dateStr];
    if (addDate.isToday) {
        self.dayLabel.text = @"今天";
    }else if (addDate.isYeaterday){
        self.dayLabel.text = @"昨天";
    }else{
        self.dayLabel.text = [addDate weekDay];
    }
    
    self.timeLabel.text = [dateStr substringWithRange:NSMakeRange(11, 5)];
//    
    self.accountLabel.text = account.amount > 0 ? [NSString stringWithFormat:@"+%.2f", account.amount] : [NSString stringWithFormat:@"%.2f", account.amount];
    //（暂定为：0: 购买, 1:充值, 2: 提现, 3:返点）
    switch (account.type) {
        case 0:
            self.accountTypeLabel.text = @"购买";
            break;
        case 1:
            self.accountTypeLabel.text = @"充值";
            break;
        case 2:
            self.accountTypeLabel.text = @"提现";
            break;
        case 3:
            self.accountTypeLabel.text = @"返点";
            break;
            
        default:
            break;
    }
    self.jiangJinInfoLabel.text = account.remark;
//    self.jiangJinInfoLabel.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
