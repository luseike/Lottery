//
//  MemberManagementCell.m
//  Lottery
//
//  Created by Chris Deng on 16/4/23.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "MemberManagementCell.h"

@interface MemberManagementCell()

//会员昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//会员级别
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
//余额
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
//QQ号
@property (weak, nonatomic) IBOutlet UILabel *QQLabel;
//返点
@property (weak, nonatomic) IBOutlet UILabel *rebateLabel;
//注册时间
@property (weak, nonatomic) IBOutlet UILabel *registeTime;
@end

@implementation MemberManagementCell


-(void)setVip:(VipVo *)vip{
    _vip = vip;
    
    self.nickNameLabel.text = vip.uid;
    self.levelLabel.text = @"普通会员";
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f元",vip.balance];
    self.QQLabel.text = vip.qq;
    self.rebateLabel.text = [NSString stringWithFormat:@"%.2f",vip.fdPst];
    self.registeTime.text = [vip.dtAdd substringToIndex:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
