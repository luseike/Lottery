//
//  AccountTotalViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/7/18.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "AccountTotalViewController.h"
#import "NSDate+YYAdd.h"
#import "RightImageBtn.h"

typedef enum : NSUInteger {
    ChangeDateEnumToday,
    ChangeDateEnumLastThreeDay,
    ChangeDateEnumLastSenvenDay,
    ChangeDateEnumLastMonth
} ChangeDateEnum;

@interface AccountTotalViewController ()
@property (weak, nonatomic) IBOutlet UILabel *zykTotalAcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *czTotalAcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *txTotalAcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tzTotalAcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *zjTotalAcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fzTotalAcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *hdTotalAcountLabel;
@property(nonatomic, assign) ChangeDateEnum selectedDateType;
@property(nonatomic, assign) BOOL loadedData;   // 是否已经加载过数据

@end



@implementation AccountTotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBarBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBarBtn setTitle:@"今天" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    [rightBarBtn addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    self.title = self.isTeamZhangMu ? @"团队账目一览" : @"总账目一览";
    
    [self getAcountTotalInfoWithDate:ChangeDateEnumToday];
}
- (void)changeDate:(UIButton *)sender {
    UIAlertController *changeDateAlert = [UIAlertController alertControllerWithTitle:@"请选择查询时间段" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(changeDateAlert) weakAlert = changeDateAlert;
    [changeDateAlert addAction:[UIAlertAction actionWithTitle:@"今天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"今天" forState:UIControlStateNormal];
        [self getAcountTotalInfoWithDate:ChangeDateEnumToday];
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [changeDateAlert addAction:[UIAlertAction actionWithTitle:@"最近3天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"最近3天" forState:UIControlStateNormal];
        [self getAcountTotalInfoWithDate:ChangeDateEnumLastThreeDay];
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [changeDateAlert addAction:[UIAlertAction actionWithTitle:@"最近7天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"最近7天" forState:UIControlStateNormal];
        [self getAcountTotalInfoWithDate:ChangeDateEnumLastSenvenDay];
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [changeDateAlert addAction:[UIAlertAction actionWithTitle:@"最近1个月" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"最近1个月" forState:UIControlStateNormal];
        [self getAcountTotalInfoWithDate:ChangeDateEnumLastMonth];
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }]];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [changeDateAlert addAction:cancleAction];
    changeDateAlert.view.tintColor = [UIColor colorWithHexString:@"4E5151"];
    [self presentViewController:changeDateAlert animated:YES completion:nil];
}

-(void)getAcountTotalInfoWithDate:(ChangeDateEnum)date{
    if (date == self.selectedDateType && self.loadedData) {
        return;
    }
    VipVo *vip = KGetVip;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    
    if (date != ChangeDateEnumToday) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    
        
        [paramDict setValue:today forKey:@"dtE_"];
        switch (date) {
            case ChangeDateEnumLastThreeDay:
                
                [paramDict setValue:[dateFormatter stringFromDate:[[NSDate date] dateByAddingDays:-3]] forKey:@"dtB_"];
                break;
            case ChangeDateEnumLastSenvenDay:
                [paramDict setValue:[dateFormatter stringFromDate:[[NSDate date] dateByAddingDays:-7]] forKey:@"dtB_"];
                break;
            case ChangeDateEnumLastMonth:
                [paramDict setValue:[dateFormatter stringFromDate:[[NSDate date] dateByAddingMonths:-1]] forKey:@"dtB_"];
                break;
            default:
                break;
        }
    }
    
    
    [SVProgressHUD showWithStatus:@"正在加载总账目数据！"];
    NSString *loadUrlStr = self.isTeamZhangMu ? @"account/countTeam" : @"account/count";
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:loadUrlStr] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (!self.loadedData) {
            
            self.loadedData = true;
        }
        self.selectedDateType = date;
        
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            //提现总额
            self.txTotalAcountLabel.text = [NSString stringWithFormat:@"%.2f",[[[responseObject valueForKey:@"result"] valueForKey:@"cashAmount"] floatValue]];
            //总返点
            self.fzTotalAcountLabel.text = [NSString stringWithFormat:@"%.2f",[[[responseObject valueForKey:@"result"] valueForKey:@"fdAmount"] floatValue]];
            //充值金额
            self.czTotalAcountLabel.text = [NSString stringWithFormat:@"%.2f",[[[responseObject valueForKey:@"result"] valueForKey:@"rechargeAmount"] floatValue]];
            //中奖总额
            self.zjTotalAcountLabel.text = [NSString stringWithFormat:@"%.2f",[[[responseObject valueForKey:@"result"] valueForKey:@"jiangAmount"] floatValue]];
            //投资总额
            self.tzTotalAcountLabel.text = [NSString stringWithFormat:@"%.2f",[[[responseObject valueForKey:@"result"] valueForKey:@"orderAmount"] floatValue]];
            //活动总额
            self.hdTotalAcountLabel.text = [NSString stringWithFormat:@"%.2f",[[[responseObject valueForKey:@"result"] valueForKey:@"fuliAmount"] floatValue]];
            //总盈亏 下注（负数）+返点+奖金
            self.zykTotalAcountLabel.text = [NSString stringWithFormat:@"%.2f",[self.tzTotalAcountLabel.text floatValue]+[self.fzTotalAcountLabel.text floatValue] + [self.zjTotalAcountLabel.text floatValue]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载总账目数据失败"];
    }];
}

@end
