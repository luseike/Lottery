//
//  AccountTotalViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/7/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  个人报表

#import "AccountListViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "LotteryHallRefreshHeader.h"
#import "AccountTotalVo.h"
#import "AccountVo.h"
#import "AccountListCell.h"
#import "AccountTotalViewController.h"
#import "NoDrawView.h"

@interface AccountListViewController ()
@property(nonatomic,strong) NSMutableArray *accountDataSource;
/**
 *  当前页码
 */
@property(nonatomic,assign) NSUInteger currentPage;
@property(nonatomic,strong) NoDrawView *noOrderView;
@end

@implementation AccountListViewController

-(NoDrawView *)noOrderView{
    if (!_noOrderView) {
        _noOrderView = [[[NSBundle mainBundle] loadNibNamed:@"NoDrawView" owner:nil options:nil] firstObject];
        _noOrderView.iconName = @"no_details";
        _noOrderView.infoText = @"暂无明细记录";
        _noOrderView.center = self.view.center;
        [self.tableView addSubview:_noOrderView];
        self.noOrderView = _noOrderView;
    }
    return _noOrderView;
}

-(NSMutableArray *)accountDataSource{
    if (!_accountDataSource) {
        _accountDataSource = [NSMutableArray array];
    }
    return _accountDataSource;
}

static NSString * const AccountCellId = @"accountCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帐变明细";
    self.view.backgroundColor = KBGColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AccountListCell class]) bundle:nil] forCellReuseIdentifier:AccountCellId];
    
    LotteryHallRefreshHeader *header = [LotteryHallRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [header beginRefreshing];
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAccountTotal)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
}

-(void)loadData{
    VipVo *vip = KGetVip;
    self.currentPage = 1;
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"account/list"] parameters:@{@"vipId":vip.vipId,@"vipToken":vip.token,@"page":@(self.currentPage)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            
            NSArray *dataSource = [[responseObject valueForKey:@"result"] valueForKey:@"items"];
            [self.accountDataSource removeAllObjects];
            
            if (dataSource.count == 0) {
                self.noOrderView.hidden = NO;
            }else{
                self.noOrderView.hidden = YES;
                self.accountDataSource = [AccountVo mj_objectArrayWithKeyValuesArray:dataSource];
                [self.tableView reloadData];
            }
            
            
            NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
            if (self.accountDataSource.count == totalCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载帐变明细数据失败"];
    }];
}

-(void)loadMoreAccountTotal{
    VipVo *vip = KGetVip;
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"account/list"] parameters:@{@"vipId":vip.vipId,@"vipToken":vip.token,@"page":@(self.currentPage)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_footer endRefreshing];
        
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            
            NSArray *dataSource = [[responseObject valueForKey:@"result"] valueForKey:@"items"];
            [self.accountDataSource addObjectsFromArray:[AccountVo mj_objectArrayWithKeyValuesArray:dataSource]];
            [self.tableView reloadData];
            NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
            if (self.accountDataSource.count == totalCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载帐变明细数据失败"];
    }];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.accountDataSource.count > 0 ? 2 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return self.accountDataSource.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"总帐目";
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.text = @"我的统计";
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.frame = CGRectMake(KScreenWidth - 60 - 30, 0, 60, cell.height + 15);
        [cell.contentView addSubview:detailLabel];
        [cell setNeedsLayout];
        return cell;
    }else{
        AccountListCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountCellId];
        cell.account = self.accountDataSource[indexPath.row];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 100;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        AccountTotalViewController *accountTotal = [[AccountTotalViewController alloc] init];
        accountTotal.isTeamZhangMu = NO;
        [self.navigationController pushViewController:accountTotal animated:YES];
    }
}

@end
