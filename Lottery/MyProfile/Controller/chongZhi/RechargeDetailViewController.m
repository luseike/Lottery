//
//  RechargeDetailViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/7/18.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "RechargeDetailViewController.h"
#import "RechargeVo.h"
#import "RechargeViewController.h"
#import "RechargeActionViewController.h"
#import "MJExtension.h"

@interface RechargeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *zhiFuBaoZFView1;
@property (weak, nonatomic) IBOutlet UIView *zhiFuBaoZFView2;
@property (weak, nonatomic) IBOutlet UIView *weiXinZFView;
@property (weak, nonatomic) IBOutlet UIView *yinLianZFView;

@property (weak, nonatomic) IBOutlet UIImageView *zfbSelectedImgView1;
@property (weak, nonatomic) IBOutlet UIImageView *zfbSelectedImgView2;
@property (weak, nonatomic) IBOutlet UIImageView *weiXinSelectedImgView;
@property (weak, nonatomic) IBOutlet UIImageView *yinLianSelectedImgView;
@property (nonatomic,assign) NSInteger zhiFuType;
@end

@implementation RechargeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值详情";
    
    self.amountLabel.text = [NSString stringWithFormat:@"+%.2f元",self.rechargeVo.amount];
    self.dateLabel.text = self.rechargeVo.dtAdd;
    
    self.zhiFuType = 1; //默认使用支付宝支付
    self.zhiFuBaoZFView1.tag = self.zhiFuType;
    self.zhiFuBaoZFView2.tag = 2;
    self.weiXinZFView.tag = 3;
    self.yinLianZFView.tag = 4;
    [self.zhiFuBaoZFView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeZhifuType:)]];
    [self.zhiFuBaoZFView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeZhifuType:)]];
    [self.weiXinZFView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeZhifuType:)]];
    [self.yinLianZFView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeZhifuType:)]];
}

-(void)changeZhifuType:(UITapGestureRecognizer *)tapGesture{
    if (tapGesture.view.tag == 1) {
        //点击的是支付宝
        self.zhiFuType = 1;
        self.zfbSelectedImgView1.image = [UIImage imageNamed:@"selected"];
        self.zfbSelectedImgView2.image = [UIImage imageNamed:@"un_selected"];
        self.weiXinSelectedImgView.image = [UIImage imageNamed:@"un_selected"];
        self.yinLianSelectedImgView.image = [UIImage imageNamed:@"un_selected"];
    }else if(tapGesture.view.tag == 2){
        self.zhiFuType = 2;
        self.zfbSelectedImgView1.image = [UIImage imageNamed:@"un_selected"];
        self.zfbSelectedImgView2.image = [UIImage imageNamed:@"selected"];
        self.weiXinSelectedImgView.image = [UIImage imageNamed:@"un_selected"];
        self.yinLianSelectedImgView.image = [UIImage imageNamed:@"un_selected"];
    }else if(tapGesture.view.tag == 3){
        self.zhiFuType = 3;
        self.zfbSelectedImgView1.image = [UIImage imageNamed:@"un_selected"];
        self.zfbSelectedImgView2.image = [UIImage imageNamed:@"un_selected"];
        self.weiXinSelectedImgView.image = [UIImage imageNamed:@"selected"];
        self.yinLianSelectedImgView.image = [UIImage imageNamed:@"un_selected"];
    }else{
        self.zhiFuType = 4;
        self.zfbSelectedImgView1.image = [UIImage imageNamed:@"un_selected"];
        self.zfbSelectedImgView2.image = [UIImage imageNamed:@"un_selected"];
        self.weiXinSelectedImgView.image = [UIImage imageNamed:@"un_selected"];
        self.yinLianSelectedImgView.image = [UIImage imageNamed:@"selected"];
    }
}

- (IBAction)goOnRecharge:(UIButton *)sender {
    
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setValue:@(self.rechargeVo.amount) forKey:@"amount"];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"recharge/add"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            RechargeVo *recharge = [RechargeVo mj_objectWithKeyValues:[responseObject valueForKey:@"result"]];
            if (recharge) {
                NSString *baseUrl = [KServerUrl substringToIndex:KServerUrl.length - 4];
                NSString *chargeStr = @"";
                BOOL openInSafari = true;
                switch (self.zhiFuType) {
                        
                    case 1:
                        chargeStr = @"alipaywap2";
                        break;
                    case 2:
                        chargeStr = @"alipaywap";
                        break;
                    case 3:
                        chargeStr = @"wxwap";
                        break;
                    default:
                        chargeStr = @"bankwap";
                        openInSafari = false;
                        break;
                }
                NSString *rechargeUrl = [NSString stringWithFormat:@"%@/vip/recharge/%@/%@",baseUrl,chargeStr,recharge.rechargeId];
                NSLog(@"%@",rechargeUrl);
                if (openInSafari) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rechargeUrl]];
                }else{
                    RechargeActionViewController *rechargeActionVc = [[RechargeActionViewController alloc] init];
                    rechargeActionVc.rechargeUrl = rechargeUrl;
                    [self.navigationController pushViewController:rechargeActionVc animated:YES];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {[SVProgressHUD showErrorWithStatus:@"继续充值失败"];
    }];
    
    
//    RechargeActionViewController *rechargeActionVc = [[RechargeActionViewController alloc] init];
//    [self.navigationController pushViewController:rechargeActionVc animated:YES];
}
@end
