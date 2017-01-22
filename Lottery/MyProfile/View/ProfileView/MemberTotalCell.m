//
//  MemberTotalCell.m
//  Lottery
//
//  Created by Chris Deng on 16/4/23.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "MemberTotalCell.h"
#import "AccountTotalVo.h"

@interface MemberTotalCell()
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fdAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiangAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *zykAmoutLabel;


@end

@implementation MemberTotalCell

-(void)setAccount:(AccountTotalVo *)account{
    _account = account;
    self.nickNameLabel.text = account.nickName==nil ? @"" : account.nickName;
    self.rechargeAmountLabel.text = [NSString stringWithFormat:@"%@",account.rechargeAmount];
    self.orderAmountLabel.text = [NSString stringWithFormat:@"%@",account.orderAmount];
    self.fdAmountLabel.text = [NSString stringWithFormat:@"%@",account.fdAmount];
    self.cashAmountLabel.text = [NSString stringWithFormat:@"%@",account.cashAmount];
    self.jiangAmountLabel.text = [NSString stringWithFormat:@"%@",account.jiangAmount];
    
    //总盈亏 下注（负数）+返点+奖金
    self.zykAmoutLabel.text = [NSString stringWithFormat:@"%.2f",[self.orderAmountLabel.text floatValue]+[self.fdAmountLabel.text floatValue] + [self.jiangAmountLabel.text floatValue]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
