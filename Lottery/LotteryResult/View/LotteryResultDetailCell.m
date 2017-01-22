//
//  LotteryResultDetailCell.m
//  Lottery
//
//  Created by jiangyuanlu on 16/6/27.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LotteryResultDetailCell.h"

@interface LotteryResultDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodNameLabel;
@property (weak, nonatomic) IBOutlet UIView *numbersView;

@end

@implementation LotteryResultDetailCell

-(void)setResult:(LotteryType *)result{
    _result = result;
//    self.productNameLabel.text = result.ProductVo.name;
    self.periodNameLabel.text = [NSString stringWithFormat:@"第%@期",result.periodVo.name];
    self.addTimeLabel.text = [NSString stringWithFormat:@"%@",[result.periodVo.timeEnd substringToIndex:result.periodVo.timeEnd.length - 3]];
    NSArray *kjArr = [result.periodVo.kjNum componentsSeparatedByString:@" "];
    for (UIView *subView in self.numbersView.subviews) {
        [subView removeFromSuperview];
    }
    for (NSInteger i = 0; i < kjArr.count; i++) {
        if ([result.productVo.productId isEqualToString:@"sk3"] || [result.productVo.productId isEqualToString:@"jsk3"]) {
            if (result.isFirstItem) {
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"kuai3_%@",kjArr[i]]];
                imgView.frame = CGRectMake((30 + 10) * i, 0, 30, 30);
                [self.numbersView addSubview:imgView];
            }else{
                UILabel *kuai3View = [[UILabel alloc] init];
                kuai3View.text = kjArr[i];
                kuai3View.font = [UIFont systemFontOfSize:17];
                kuai3View.textColor = RGB(224, 60, 31);
                kuai3View.textAlignment = NSTextAlignmentCenter;
                kuai3View.frame = CGRectMake((30 + 10) * i, 0, 30, 30);
                [self.numbersView addSubview:kuai3View];
            }
            
        }else{
            
            UILabel *numberLabel = [[UILabel alloc] init];
            numberLabel.text = kjArr[i];
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.textColor = [UIColor whiteColor];
            CGFloat numberW = 30;
            CGFloat maxW = KScreenWidth - 40;
            if ((numberW * kjArr.count + 10 * (kjArr.count - 1)) >= maxW) {
                numberW = (maxW - kjArr.count * 10) / (kjArr.count - 1);
                numberLabel.frame = CGRectMake((numberW + 5) * i, 0, numberW, 30);
                UIImageView *backImgView = [[UIImageView alloc] initWithFrame:numberLabel.frame];
                if (result.isFirstItem) {
                    backImgView.image = [UIImage imageNamed:@"pk10_bg"];
                    numberLabel.font = [UIFont systemFontOfSize:12];
                }else{
                    numberLabel.textColor = [UIColor redColor];
                    numberLabel.font = [UIFont systemFontOfSize:14];
                }
                
                [self.numbersView addSubview:backImgView];
            }else{
                
                numberLabel.layer.cornerRadius = numberW * 0.5;
                
                if (result.isFirstItem) {
                    numberLabel.font = [UIFont systemFontOfSize:14];
                    numberLabel.layer.masksToBounds = YES;
                    numberLabel.backgroundColor = RGB(224, 60, 31);
                }else{
                    numberLabel.font = [UIFont systemFontOfSize:16];
                    numberLabel.backgroundColor = [UIColor clearColor];
                    numberLabel.textColor = RGB(224, 60, 31);
                }
                
                numberLabel.frame = CGRectMake((numberW + 10) * i, 0, numberW, 30);
            }
            
            
            [self.numbersView addSubview:numberLabel];
        }
    }
}

@end
