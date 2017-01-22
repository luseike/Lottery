//
//  LotterylotteryCell.m
//  Lottery
//
//  Created by Chris Deng on 16/4/12.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LotteryResultCell.h"
#import "LotteryType.h"

@interface LotteryResultCell()
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodNameLabel;
@property (weak, nonatomic) IBOutlet UIView *numbersView;

@end

@implementation LotteryResultCell

//static const CGFloat numberW = 30;

-(void)setResult:(LotteryType *)result{
    _result = result;
    self.productNameLabel.text = result.productVo.name;
    if (result.periodVo.name.length > 0) {
        self.periodNameLabel.text = [NSString stringWithFormat:@"第%@期",result.periodVo.name];
        self.addTimeLabel.text = [NSString stringWithFormat:@"%@",[result.periodVo.timeEnd substringToIndex:result.periodVo.timeEnd.length - 3]];
    }else{
        self.periodNameLabel.text = @"敬请期待";
        self.addTimeLabel.text = @"";
    }
    
    NSArray *kjArr = [result.periodVo.kjNum componentsSeparatedByString:@" "];
    for (UIView *subView in self.numbersView.subviews) {
        [subView removeFromSuperview];
    }
    for (NSInteger i = 0; i < kjArr.count; i++) {
        if ([result.productVo.productId isEqualToString:@"sk3"] || [result.productVo.productId isEqualToString:@"jsk3"]) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"kuai3_%@",kjArr[i]]];
            imgView.frame = CGRectMake((30 + 10) * i, 0, 30, 30);
            [self.numbersView addSubview:imgView];
        }else{
            
            UILabel *numberLabel = [[UILabel alloc] init];
            numberLabel.text = kjArr[i];
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.textColor = [UIColor whiteColor];
            CGFloat numberW = 30;
            CGFloat maxW = KScreenWidth - 40;
            if ((numberW * kjArr.count + 10 * (kjArr.count - 1)) >= maxW) {
                numberW = (maxW - kjArr.count * 10) / (kjArr.count - 1);
                numberLabel.font = [UIFont systemFontOfSize:12];
                numberLabel.frame = CGRectMake((numberW + 5) * i, 0, numberW, 30);
                UIImageView *backImgView = [[UIImageView alloc] initWithFrame:numberLabel.frame];
                backImgView.image = [UIImage imageNamed:@"pk10_bg"];
                [self.numbersView addSubview:backImgView];
            }else{
                numberLabel.font = [UIFont systemFontOfSize:14];
                numberLabel.layer.cornerRadius = numberW * 0.5;
                numberLabel.layer.masksToBounds = YES;
                numberLabel.backgroundColor = RGB(224, 60, 31);
                numberLabel.frame = CGRectMake((numberW + 10) * i, 0, numberW, 30);
            }
            
            
            [self.numbersView addSubview:numberLabel];
        }
    }
}


@end
