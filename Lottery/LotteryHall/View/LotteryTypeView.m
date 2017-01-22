//
//  LotteryTypeView.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/10.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LotteryTypeView.h"
#import "UIImageView+WebCache.h"
#import "LotteryType.h"
#import "ProductVo.h"
#import "PeriodVo.h"

@interface LotteryTypeView()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation LotteryTypeView

-(void)setTypeModel:(LotteryType *)typeModel{
    _typeModel = typeModel;
//    NSLog(typeModel.productVo.name);
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:typeModel.productVo.pic] placeholderImage:nil];
    self.imgView.image = [UIImage imageNamed:typeModel.productVo.name];
    self.nameLabel.text = typeModel.productVo.name;
    self.statusLabel.text = typeModel.productVo.state == 0 ? @"火爆进行中" : @"暂停销售";
    self.statusLabel.textColor = typeModel.productVo.state == 0 ? RGB(220, 89, 96) : RGB(175, 175, 175);
  
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = RGBA(240, 240, 240, 1);//[UIColor grayColor];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = [UIColor whiteColor];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    self.backgroundColor = [UIColor whiteColor];
}

@end
