//
//  OrderCheckView.m
//  Lottery
//
//  Created by 蒋远路 on 16/6/27.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "OrderCheckView.h"
#import "CommitVo.h"
#import "CommitItemVo.h"
#import "MJExtension.h"
#import "LotteryNavigationController.h"

@interface OrderCheckView()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bettingContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *bettingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bettingMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *multipleLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;

@property(nonatomic,strong) NSDictionary *repeatCommitParamDict;

@end

@implementation OrderCheckView

-(void)setOrderCheckDict:(NSDictionary *)orderCheckDict{
    _orderCheckDict = orderCheckDict;
    self.productNameLabel.text = [orderCheckDict valueForKey:@"productName"];
    self.periodNameLabel.text = [orderCheckDict valueForKey:@"periodName"];
    self.bettingContentLabel.text = [orderCheckDict valueForKey:@"bettingContent"];
    self.bettingCountLabel.text = [orderCheckDict valueForKey:@"bettingCount"];
    self.bettingMoneyLabel.text = [orderCheckDict valueForKey:@"bettingMoney"];
    self.multipleLabel.text = [orderCheckDict valueForKey:@"multiple"];
    self.modelLabel.text = [orderCheckDict valueForKey:@"model"];
}
- (IBAction)cancel:(UIButton *)sender {
    [self removeFromSuperview];
}

/**
 *  提交订单
 */
- (IBAction)conformOrder:(UIButton *)sender {
    VipVo *vip = KGetVip;
    if (vip.uid == nil) {
        [SVProgressHUD showErrorWithStatus:@"您好未登录"];
        return;
    }else{
        
        [SVProgressHUD showWithStatus:@"订单提交中……"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        
        
        NSString *model = [self.orderCheckDict valueForKey:@"model"];
        NSInteger unit = 0;
        if ([model isEqualToString:@"元"]) {
            unit = 1;
        }else if ([model isEqualToString:@"角"]){
            unit = 10;
        }else{
            unit = 100;
        }
        
        NSDictionary *commitDataDict = [NSDictionary dictionary];
        if (self.isKuaiSan) {
            commitDataDict = self.kuaiSanDictParam;
        }else{
            commitDataDict = @{
                                             @"productId":[self.orderCheckDict valueForKey:@"productId"],
                                             @"period":[self.orderCheckDict valueForKey:@"periodName"],
                                             @"jg":[self.orderCheckDict valueForKey:@"bettingMoney"],
                                             @"dataList":@[
                                                     @{
                                                         @"playedId":[self.orderCheckDict valueForKey:@"playedId"],
                                                         @"playedName":[self.orderCheckDict valueForKey:@"playedName"],
                                                         @"data":[self.orderCheckDict valueForKey:@"bettingContent"],
                                                         @"num":[self.orderCheckDict valueForKey:@"bettingCount"],
                                                         @"jg":[self.orderCheckDict valueForKey:@"bettingMoney"],
                                                         @"beis":[self.orderCheckDict valueForKey:@"multiple"],
                                                         @"unit":@(unit)
                                                         }
                                                     ],
                                             };
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:commitDataDict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *paramDict = @{@"vipId":vip.vipId,@"vipToken":vip.token,@"commitData":jsonStr};
        [[AFHTTPSessionManager manager] POST:[KServerUrl stringByAppendingPathComponent:@"order/commit"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject valueForKey:@"statusCode"] integerValue] == 200){
                [SVProgressHUD dismiss];
                [self removeFromSuperview];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KOrderCheckDidConformNotification" object:self];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KLoginSuccessNotification" object:nil];
            }else if ([[responseObject valueForKey:@"statusCode"] integerValue] == 201){
                
                [SVProgressHUD dismiss];
                [self removeFromSuperview];
                
                //期次已过投注期限
                NSDictionary *dict = [responseObject valueForKey:@"result"];
                PeriodVo *period = [PeriodVo mj_objectWithKeyValues:[dict valueForKey:@"period"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KOrderCheckRepeatConformNotification" object:self userInfo:@{@"newPeriod":period.name,@"commitParam":commitDataDict}];
            }else{
                [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"订单提交失败"];
            [SVProgressHUD dismiss];
        }];
//        [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"order/commit"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [SVProgressHUD showErrorWithStatus:@"订单提交失败"];
//            [SVProgressHUD dismiss];
//        }];
    }
}

-(void)repeatCommitWithParamDict:(NSDictionary *)commitParam{
    VipVo *vip = KGetVip;
    NSData *data = [NSJSONSerialization dataWithJSONObject:commitParam options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *paramDict = @{@"vipId":vip.vipId,@"vipToken":vip.token,@"commitData":jsonStr};
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"order/commit"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            [SVProgressHUD dismiss];
            [self removeFromSuperview];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KOrderCheckDidConformNotification" object:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"订单提交失败"];
        [SVProgressHUD dismiss];
    }];
}

@end
