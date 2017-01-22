//
//  RechargeViewController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/20.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeVo.h"
#import "RechargeActionViewController.h"
#import "MJExtension.h"

@interface RechargeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *rechargeTextFeild;
@property (weak, nonatomic) IBOutlet UIButton *commitRechargeBtn;
@property (weak, nonatomic) IBOutlet UIView *zfbView1;
@property (weak, nonatomic) IBOutlet UIView *zfbView2;
@property (weak, nonatomic) IBOutlet UIView *yinLianView;
@property (weak, nonatomic) IBOutlet UIView *weiXinView;

@property (weak, nonatomic) IBOutlet UIImageView *zfbSelectedImgView1;
@property (weak, nonatomic) IBOutlet UIImageView *zfbSelectedImgView2;
@property (weak, nonatomic) IBOutlet UIImageView *weiXinSelectedImgView;
@property (weak, nonatomic) IBOutlet UIImageView *yinLianSelectedImgView;
@property (nonatomic,assign) NSInteger zhiFuType;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    
    
    self.commitRechargeBtn.layer.cornerRadius = 3;
    self.commitRechargeBtn.layer.masksToBounds = YES;
    [self.rechargeTextFeild becomeFirstResponder];
    
    self.zhiFuType = 1; //默认使用支付宝1支付
    self.zfbView1.tag = self.zhiFuType;
    self.zfbView2.tag = 2;
    self.weiXinView.tag = 3;
    self.yinLianView.tag = 4;
    [self.zfbView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeZhifuType:)]];
    [self.zfbView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeZhifuType:)]];
    [self.weiXinView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeZhifuType:)]];
    [self.yinLianView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeZhifuType:)]];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)commitRecharge:(id)sender {
    if (self.rechargeTextFeild.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先输入充值金额"];
        return;
    }
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setValue:self.rechargeTextFeild.text forKey:@"amount"];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"recharge/add"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            RechargeVo *recharge = [RechargeVo mj_objectWithKeyValues:[responseObject valueForKey:@"result"]];
            if (recharge) {
                NSString *baseUrl = [KServerUrl substringToIndex:KServerUrl.length - 4];
                // {baseUrl}/vip/recharge/{provider}/{ordId}
                // 微信 wxwap  银联 bankwap
                
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {[SVProgressHUD showErrorWithStatus:@"充值失败"];
    }];
}

@end
