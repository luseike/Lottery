//
//  rechargeListCell.m
//  Lottery
//
//  Created by 蒋远路 on 16/7/18.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "rechargeListCell.h"
#import "RechargeVo.h"

@interface rechargeListCell()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) UILabel *rechargeAccountLabel;
@property (strong, nonatomic) UILabel *stateInfoLabel;
@end

@implementation rechargeListCell
-(UILabel *)rechargeAccountLabel{
    if (!_rechargeAccountLabel) {
        _rechargeAccountLabel = [[UILabel alloc] init];
        _rechargeAccountLabel.textColor = RGB(20, 20, 20);
        _rechargeAccountLabel.font = [UIFont systemFontOfSize:14];
    }
    return _rechargeAccountLabel;
}
-(UILabel *)stateInfoLabel{
    if (!_stateInfoLabel) {
        _stateInfoLabel = [[UILabel alloc] init];
        _stateInfoLabel.textColor = RGB(190, 190, 190);
        _stateInfoLabel.font = [UIFont systemFontOfSize:12];
    }
    return _stateInfoLabel;
}
-(void)setRechargeVo:(RechargeVo *)rechargeVo{
    _rechargeVo = rechargeVo;
    // 只有type ＝ 0是失败  其他都是成功
    self.dateLabel.text = rechargeVo.dtAdd;
    
    self.dayLabel.text = rechargeVo.weekDay;
    self.dateLabel.text = rechargeVo.hourMinute;
    self.rechargeAccountLabel.text = [NSString stringWithFormat:@"+%.2f",rechargeVo.amount];
    [self.accountView addSubview:self.rechargeAccountLabel];
    
    self.stateInfoLabel.text = [NSString stringWithFormat:@"充值%@",rechargeVo.type != 0 ? @"成功" : @"失败"];
    if (rechargeVo.type == 0) {
        self.stateLabel.hidden = NO;
    }else{
        self.stateLabel.hidden = YES;
    }
    [self.accountView addSubview:self.stateInfoLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.accountView.subviews.count > 1) {
        self.rechargeAccountLabel.frame = CGRectMake(0, 0, self.accountView.width, self.accountView.height * 0.6);
        self.stateInfoLabel.frame = CGRectMake(0, self.accountView.height * 0.6, self.accountView.width, self.accountView.height * 0.4);
    }else{
        self.rechargeAccountLabel.frame = CGRectMake(0, 0, self.accountView.width, self.accountView.height);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
