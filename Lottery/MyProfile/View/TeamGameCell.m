//
//  TeamGameCell.m
//  Lottery
//
//  Created by jiangyuanlu on 16/9/8.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "TeamGameCell.h"
#import "TeamGameVo.h"
#import "UIImageView+WebCache.h"

@interface TeamGameCell()
@property (weak, nonatomic) IBOutlet UIImageView *avtorImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *periodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playedNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *bettingMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiangLabel;

@end

@implementation TeamGameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setTeamGame:(TeamGameVo *)teamGame{
    _teamGame = teamGame;
    
    UIColor *redColor = [UIColor colorWithHexString:@"C20000"];
    self.userNameLabel.text = teamGame.userUid;
    // 期次
    self.periodNameLabel.text = [NSString stringWithFormat:@"第%@期",teamGame.period];
    self.productIconImgView.image = [UIImage imageNamed:teamGame.productName];
//    [self.productIconImgView sd_setImageWithURL:[NSURL URLWithString:teamGame.productPic] placeholderImage:nil];
    // 开奖状态    //   状态： 0:待开奖 1:开奖中 2:未中奖 3:已派奖(即中奖了)
    switch (teamGame.state) {
        case 0:
            self.jiangLabel.text = @"待开奖";
            self.jiangLabel.textColor = [UIColor colorWithHexString:@"869941"];
            break;
        case 1:
            self.jiangLabel.text = @"开奖中";
            self.jiangLabel.textColor = [UIColor colorWithHexString:@"869941"];
            break;
        case 2:
            self.jiangLabel.text = @"未中奖";
            self.jiangLabel.textColor = RGB(157, 157, 157);
            break;
        case 3:
            self.jiangLabel.text = [NSString stringWithFormat:@"%f",teamGame.jiang];
            self.jiangLabel.textColor = RGB(193, 0, 18);;
            break;
        default:
            break;
    }
    
    // 投注详情
    self.playedNameLabel.text = teamGame.playedName;
    
    
    
    // 投注内容
    self.dataStrLabel.text = teamGame.data;
    
    NSString *bettingCount = [NSString stringWithFormat:@"%zd",teamGame.num];
    // 投注金额
    NSString *bettingMoney = [NSString stringWithFormat:@"%zd",teamGame.jg];
    NSString *beis = [NSString stringWithFormat:@"%zd",teamGame.beis];
    //元角分模式（ 1 :元 10 :角 100 :分）
    NSString *model = nil;
    switch (teamGame.unit) {
        case 1:
            model = @"元";
            break;
        case 10:
            model = @"角";
            break;
        case 100:
            model = @"分";
            break;
        default:
            break;
    }
    NSString *modelStr = model;
    NSString *tzjeStr = [NSString stringWithFormat:@"投注金额：共%@注 %@元 倍数：%@ 模式：%@",bettingCount,bettingMoney,beis,modelStr];
    
    NSMutableAttributedString *tzjeAttrStr = [[NSMutableAttributedString alloc] initWithString:tzjeStr];
    [tzjeAttrStr addAttribute:NSForegroundColorAttributeName value:redColor range:[tzjeStr rangeOfString:bettingCount]];
    [tzjeAttrStr addAttribute:NSForegroundColorAttributeName value:redColor range:[tzjeStr rangeOfString:bettingMoney]];
    [tzjeAttrStr addAttribute:NSForegroundColorAttributeName value:redColor range:[tzjeStr rangeOfString:beis options:NSBackwardsSearch]];
    [tzjeAttrStr addAttribute:NSForegroundColorAttributeName value:redColor range:[tzjeStr rangeOfString:model options:NSBackwardsSearch]];
    
    self.bettingMoneyLabel.attributedText = tzjeAttrStr;
    
    
    // 日期
    self.timeLabel.text = [teamGame.dtAdd substringToIndex:teamGame.dtAdd.length - 3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
