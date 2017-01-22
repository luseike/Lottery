//
//  OrderListCell.m
//  Lottery
//
//  Created by jiangyuanlu on 16/7/23.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "OrderListCell.h"
#import "OrderVo.h"
#import "OrderItemVo.h"
#import "UIImageView+WebCache.h"

@interface OrderListCell()
/**
 *  彩种图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *productIconImgView;
/**
 *  期次
 */
@property (weak, nonatomic) IBOutlet UILabel *periodNameLabel;

/**
 *  投注详情
 */
@property (weak, nonatomic) IBOutlet UILabel *playedNameLabel;
/**
 *  投注内容
 */
@property (weak, nonatomic) IBOutlet UILabel *dataStrLabel;

/**
 中奖金额
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

/**
 *  投注日期
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bettingMoneyLabel;
@end

@implementation OrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setOrder:(OrderVo *)order{
    _order = order;
    UIColor *redColor = [UIColor colorWithHexString:@"C20000"];
    // 要显示的第一条订单记录
    OrderItemVo *itemVo = [order.items firstObject];
    
    [self.productIconImgView sd_setImageWithURL:[NSURL URLWithString:order.product.pic] placeholderImage:nil];
    
    // 期次
    self.periodNameLabel.text = [NSString stringWithFormat:@"第%@期",order.period.name];
    
    // 开奖状态    //   状态： 0:待开奖 1:开奖中 2:未中奖 3:已派奖(即中奖了) 4:已撤单
    switch (order.state) {
        case 0:
            self.moneyLabel.text = @"待开奖";
            self.moneyLabel.textColor = [UIColor colorWithHexString:@"869941"];
            break;
        case 1:
            self.moneyLabel.text = @"开奖中";
            self.moneyLabel.textColor = [UIColor colorWithHexString:@"869941"];
            break;
        case 2:
            self.moneyLabel.text = @"未中奖";
            self.moneyLabel.textColor = RGB(157, 157, 157);
            break;
        case 3:
            self.moneyLabel.text = [NSString stringWithFormat:@"%@",order.jiang];
            self.moneyLabel.textColor = RGB(193, 0, 18);;
            break;
        case 4:
            self.moneyLabel.text = @"已撤单";
            self.moneyLabel.textColor = RGB(193, 0, 18);;
            break;
        default:
            break;
    }
    
    // 投注详情
    self.playedNameLabel.text = itemVo.playedName;
    
    
    
    // 投注内容
    self.dataStrLabel.text = itemVo.dataStr;
    
    NSString *bettingCount = [NSString stringWithFormat:@"%zd",itemVo.num];
    // 投注金额
    NSString *bettingMoney = [NSString stringWithFormat:@"%zd",itemVo.jg];
    NSString *beis = [NSString stringWithFormat:@"%zd",itemVo.beis];
    //元角分模式（ 1 :元 10 :角 100 :分）
    NSString *model = nil;
    switch (itemVo.unit) {
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
    self.timeLabel.text = [order.dtAdd substringToIndex:order.dtAdd.length - 3];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
