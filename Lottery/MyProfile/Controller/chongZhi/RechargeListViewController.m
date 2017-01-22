//
//  RechargeListViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/7/18.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "RechargeListViewController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "RechargeViewController.h"
#import "RechargeDetailViewController.h"
#import "RechargeVo.h"
#import "rechargeListCell.h"
#import "LotteryHallRefreshHeader.h"
#import "NoDrawView.h"

@interface RechargeListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *rechargeListTableView;
@property(nonatomic,strong) NSMutableArray *rechargeListDataArr;
/**
 *  当前页码
 */
@property(nonatomic,assign) NSUInteger currentPage;

@end

@implementation RechargeListViewController
static NSString * const rechargeListCellId = @"rechargeListCell";

-(NSMutableArray *)rechargeListDataArr{
    if (!_rechargeListDataArr) {
        _rechargeListDataArr = [NSMutableArray array];
    }
    return _rechargeListDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值列表";
    
    self.rechargeListTableView.delegate = self;
    self.rechargeListTableView.dataSource = self;
    
    self.rechargeListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rechargeListTableView registerNib:[UINib nibWithNibName:NSStringFromClass([rechargeListCell class]) bundle:nil] forCellReuseIdentifier:rechargeListCellId];
    
    
    LotteryHallRefreshHeader *header = [LotteryHallRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewRechargeList)];
    self.rechargeListTableView.mj_header = header;
    [header beginRefreshing];
    
    
    self.rechargeListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRechargeList)];
}


-(void)loadNewRechargeList{
    self.currentPage = 1;
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setValue:@(self.currentPage) forKey:@"page"];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"recharge/list"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            NSArray *cashVos = [RechargeVo mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"result"] valueForKey:@"items"]];
            
            if (cashVos.count == 0) {
                UIView *noDrawView = self.rechargeListTableView.subviews.lastObject;
                if (![noDrawView isKindOfClass:[NoDrawView class]]) {
                    
                    NoDrawView *noRearchView = [[[NSBundle mainBundle] loadNibNamed:@"NoDrawView" owner:nil options:nil] firstObject];
                    noRearchView.iconName = @"noRecharge";
                    noRearchView.infoText = @"暂时没有充值记录";
                    noRearchView.center = self.view.center;
                    [self.rechargeListTableView addSubview:noRearchView];
                    //                self.rechargeListTableView.hidden = YES;
                }
            }else{
                
                [self.rechargeListDataArr removeAllObjects];
                [self.rechargeListDataArr addObjectsFromArray:cashVos];
                [self.rechargeListTableView reloadData];
            }
            
            
            [self.rechargeListTableView.mj_header endRefreshing];
            
            //
            NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
            if (self.rechargeListDataArr.count == totalCount) {
                [self.rechargeListTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"充值记录加载失败"];
        [self.rechargeListTableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreRechargeList{
    
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setValue:@(self.currentPage) forKey:@"page"];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"recharge/list"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.rechargeListTableView.mj_footer endRefreshing];
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            NSArray *cashVos = [RechargeVo mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"result"] valueForKey:@"items"]];
            [self.rechargeListDataArr addObjectsFromArray:cashVos];
            
            NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
            if (self.rechargeListDataArr.count == totalCount) {
                [self.rechargeListTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {[SVProgressHUD showErrorWithStatus:@"充值记录加载失败"];
        [self.rechargeListTableView.mj_footer endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rechargeListDataArr.count;
}

-(UITableViewCell *)
tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    rechargeListCell *cell = [tableView dequeueReusableCellWithIdentifier:rechargeListCellId];
    cell.rechargeVo = self.rechargeListDataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RechargeVo *recharge = self.rechargeListDataArr[indexPath.row];
    if (recharge.type == 0) {
        RechargeDetailViewController *detail = [[RechargeDetailViewController alloc] init];
        detail.rechargeVo = recharge;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}
/**
 *  跳转到充值界面
 */
- (IBAction)goToRecharge:(UIButton *)sender {
    RechargeViewController *rechargeVc = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:rechargeVc animated:YES];
}
@end
