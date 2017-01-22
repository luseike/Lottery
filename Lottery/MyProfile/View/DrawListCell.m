//
//  DrawListCell.m
//  Lottery
//
//  Created by 蒋远路 on 16/6/12.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "DrawListCell.h"
#import "CashVo.h"

@interface DrawListCell()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UILabel *accountLabel;
@property (strong, nonatomic) UILabel *stateInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView *accountView;

@end

@implementation DrawListCell

-(UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.textColor = RGB(20, 20, 20);
        _accountLabel.font = [UIFont systemFontOfSize:14];
    }
    return _accountLabel;
}
-(UILabel *)stateInfoLabel{
    if (!_stateInfoLabel) {
        _stateInfoLabel = [[UILabel alloc] init];
        _stateInfoLabel.textColor = RGB(190, 190, 190);
        _stateInfoLabel.font = [UIFont systemFontOfSize:12];
    }
    return _stateInfoLabel;
}


-(void)setCash:(CashVo *)cash{
    _cash = cash;
    self.dateLabel.text = cash.dtAdd;
    
    self.dayLabel.text = cash.weekDay;
    self.dateLabel.text = cash.hourMinute;
    self.accountLabel.text = [NSString stringWithFormat:@"-%.2f",cash.amount];
    [self.accountView addSubview:self.accountLabel];
    if (cash.state != CashVoStateToDo) {
        self.stateInfoLabel.text = [NSString stringWithFormat:@"提现-审核%@",cash.state == CashVoStateConform ? @"成功" : @"失败，请联系客服"];
        [self.accountView addSubview:self.stateInfoLabel];
    }
    
    self.stateLabel.hidden = cash.state != CashVoStateToDo;
    if (cash.cause) {
        self.stateLabel.hidden = NO;
        self.stateLabel.text = cash.cause;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.accountView.subviews.count > 1) {
        self.accountLabel.frame = CGRectMake(0, 0, self.accountView.width, self.accountView.height * 0.6);
        self.stateInfoLabel.frame = CGRectMake(0, self.accountView.height * 0.6, self.accountView.width, self.accountView.height * 0.4);
    }else{
        self.accountLabel.frame = CGRectMake(0, 0, self.accountView.width, self.accountView.height);
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
