//
//  PersonalViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/9/1.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "PersonalViewController.h"
#import "UIBarButtonItem+extension.h"
#import "MySettingViewController.h"
#import "FaceViewController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "LotteryHallRefreshHeader.h"

#pragma mark - 要跳转的控制器
#import "OrderListViewController.h"
#import "MemberManagementController.h"
#import "MemberTotalViewController.h"
#import "UpdateLoginPWDViewController.h"
#import "UpdateFundPWDViewController.h"
#import "BankInfoViewController.h"
#import "WithDrawListViewController.h"
#import "RechargeListViewController.h"
#import "RechargeActionViewController.h"

@interface PersonalViewController ()
/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *default_avatar;
/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  用户金额
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
/**
 *  在viewWillAppear中判断用户是否登录，没有登录显示loginTipView，引导登录
 */
@property(nonatomic,strong) UIView *loginTipView;
/**
 *  登录按钮
 */
@property(nonatomic,strong) UIButton *loginBtn;
@end

@implementation PersonalViewController

-(UIView *)loginTipView{
    if (!_loginTipView) {
        _loginTipView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _loginTipView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unlogin"]];
        imgView.y = 50;
        
        imgView.width = 310;
        imgView.height = 121;
        imgView.x = (_loginTipView.width - 310) * 0.5;
        [_loginTipView addSubview:imgView];
        
        UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgView.x, CGRectGetMaxY(imgView.frame) + 58, KScreenWidth - 2 * imgView.x, 42)];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        loginBtn.backgroundColor = [UIColor colorWithHexString:@"F84652"];
        [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.loginBtn = loginBtn;
        [_loginTipView addSubview:loginBtn];
        
        UILabel *loginTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.x, CGRectGetMaxY(loginBtn.frame) + 24, loginBtn.width, 30)];
        loginTipLabel.text = @"登录以后才可下注，查看订单、派奖等信息";
        loginTipLabel.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        loginTipLabel.font = [UIFont systemFontOfSize:14];
        loginTipLabel.textAlignment = NSTextAlignmentCenter;
        [_loginTipView addSubview:loginTipLabel];
    }
    return _loginTipView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    // 登录成功后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfileInfo) name:@"KLoginSuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:@"KLoginOutSuccessNotification" object:nil];
    
    [self setup];
}

-(void)loginOut{
    [self.view addSubview:self.loginTipView];
    self.tableView.scrollEnabled = NO;
}

-(void)refreshProfileInfo{
    
    self.tableView.scrollEnabled = YES;
    [self.loginTipView removeFromSuperview];
    [self updateUserInfo];
}

#pragma mark - view和tableview的初始化
-(void)setup{
    //设置rightNavigationItem
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"setting" highImageName:@"setting" target:self action:@selector(setBtnClicked:)];
    //设置leftNavigationItem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"客服" style:UIBarButtonItemStylePlain target:self action:@selector(customServiceCliekd:)];
    
    self.loginBtn.layer.cornerRadius = 3.0;
    self.default_avatar.layer.cornerRadius = 3.0;
    self.default_avatar.layer.masksToBounds = YES;
    
    VipVo *vip = KGetVip;
    LotteryHallRefreshHeader *header = [LotteryHallRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateUserInfo)];
    self.tableView.mj_header = header;
    
    
    if (vip) {
        [self.loginTipView removeFromSuperview];
        self.tableView.scrollEnabled = YES;
        [self.tableView.mj_header beginRefreshing];
    }else{
        self.tableView.scrollEnabled = NO;
        [self.view addSubview:self.loginTipView];
    }
}

-(void)updateUserInfo{
    // 重新拉取服务端getInfo，更新VipVo对象
    VipVo *vip = KGetVip;
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/getInfo"] parameters:@{@"vipId":vip.vipId,@"vipToken":vip.token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
            self.tableView.scrollEnabled = NO;
            [self.view addSubview:self.loginTipView];
        }else{
            VipVo *vip = [VipVo mj_objectWithKeyValues:[responseObject valueForKey:@"result"]];
            KSavePath(vip);
            // 得到最新的用户信息，更新UI的数据显示
            self.nameLabel.text = vip.uid;
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",vip.balance];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"用户信息获取失败"];
    }];
}

#pragma mark - 提现
- (IBAction)tixianClick:(id)sender {
    WithDrawListViewController *withDrawVC = [[WithDrawListViewController alloc]init];
    [self.navigationController pushViewController:withDrawVC animated:YES];

}
#pragma mark - 充值
- (IBAction)chongzhiClick:(id)sender {
    RechargeListViewController *rechargeListVC = [[RechargeListViewController alloc]init];
    [self.navigationController pushViewController:rechargeListVC animated:YES];
}

/**
 *  登陆
 */
- (void)loginBtnClicked {
    FaceViewController *faceVC = [[FaceViewController alloc]init];
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:faceVC] animated:YES completion:nil];
}

//设置
- (void)setBtnClicked:(UIButton *)sender{
    MySettingViewController *mySettingVC = [[MySettingViewController alloc]init];
    mySettingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mySettingVC animated:YES];
}
/**
 *  客服
 */
-(void)customServiceCliekd:(UIButton *)sender{
    
    NSString *baseUrl = @"http://kefu.qycn.com/vclient/chat/?m=m&websiteid=121720";
    RechargeActionViewController *rechargeVc = [[RechargeActionViewController alloc] init];
    rechargeVc.rechargeUrl = baseUrl;
    [self.navigationController pushViewController:rechargeVc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIViewController *destVc = nil;
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                    destVc = [[OrderListViewController alloc] init];
                    break;
                    
                default:
                    break;
            }
            break;
        case 3:{
            switch (indexPath.row) {
                case 0:{
                    // 银行账户
                    BankInfoViewController *bankInfo = [[BankInfoViewController alloc]init];
                    [self.navigationController pushViewController:bankInfo animated:YES];
                }
                    break;
                case 1:{
                    // 登录密码
                    UpdateLoginPWDViewController *updateLoginPWDVC = [[UpdateLoginPWDViewController alloc]init];
                    [self.navigationController pushViewController:updateLoginPWDVC animated:YES];
                }
                    break;
                case 2:{
                    // 资金密码
                    UpdateFundPWDViewController *updateFundPWDVC = [[UpdateFundPWDViewController alloc]init];
                    [self.navigationController pushViewController:updateFundPWDVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:destVc animated:YES];
}



@end
