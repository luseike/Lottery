//
//  WithDrawDetailViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/6/13.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "WithDrawDetailViewController.h"
#import "CashVo.h"


@interface WithDrawDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation WithDrawDetailViewController

- (void)viewDidLoad {
    self.title = @"提现详情";
    self.amountLabel.text = [NSString stringWithFormat:@"-%.2f元",self.cash.amount];
    self.dateLabel.text = self.cash.dtAdd;
    //CashVoStateToDo,
//    CashVoStateConform,
//    CashVoStateNotPass,
    switch (self.cash.state) {
        case CashVoStateToDo:
            self.stateLabel.text = @"待审核";
            break;
        case CashVoStateConform:
            self.stateLabel.text = @"已确认";
        default:
            self.stateLabel.text = @"不通过";
            break;
    }
    [super viewDidLoad];
}
/**
 *  取消提现
 */
- (IBAction)cancleGetCash:(UIButton *)sender {
    
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setObject:self.cash.cashId forKey:@"id"];
    [SVProgressHUD show];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"cash/delete"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"取消提现申请成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {[SVProgressHUD showErrorWithStatus:@"删除提现申请失败"];
    }];
}



@end
