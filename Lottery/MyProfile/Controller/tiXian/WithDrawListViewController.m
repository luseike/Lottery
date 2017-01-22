//
//  WithDrawListViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/6/12.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "WithDrawListViewController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WithDrawViewController.h"
#import "WithDrawDetailViewController.h"
#import "CashVo.h"
#import "DrawListCell.h"
#import "LotteryHallRefreshHeader.h"
#import "NoDrawView.h"


@interface WithDrawListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *drawListTableView;
@property(nonatomic,strong) NSMutableArray *drawListDataArr;
/**
 *  当前页码
 */
@property(nonatomic,assign) NSUInteger currentPage;
@end

@implementation WithDrawListViewController

static NSString * const DrawListCellId = @"drawListCell";

-(NSMutableArray *)drawListDataArr{
    if (!_drawListDataArr) {
        _drawListDataArr = [NSMutableArray array];
    }
    return _drawListDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现列表";
    
    self.drawListTableView.delegate = self;
    self.drawListTableView.dataSource = self;
    
    self.drawListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.drawListTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DrawListCell class]) bundle:nil] forCellReuseIdentifier:DrawListCellId];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    LotteryHallRefreshHeader *header = [LotteryHallRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDrawList)];
    self.drawListTableView.mj_header = header;
    [header beginRefreshing];
    
    
    self.drawListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDrawList)];
}

/**
 *  跳转到提现界面
 */
- (IBAction)drawBtnClick:(UIButton *)sender {
    WithDrawViewController *drawVc = [[WithDrawViewController alloc] init];
    [self.navigationController pushViewController:drawVc animated:YES];
}

-(void)loadNewDrawList{
    self.currentPage = 1;
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setValue:@(self.currentPage) forKey:@"page"];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"cash/list"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            NSArray *cashVos = [CashVo mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"result"] valueForKey:@"items"]];
            if (cashVos.count == 0) {
                UIView *noDrawView = self.drawListTableView.subviews.lastObject;
                if (![noDrawView isKindOfClass:[NoDrawView class]]) {
                    NoDrawView *noRearchView = [[[NSBundle mainBundle] loadNibNamed:@"NoDrawView" owner:nil options:nil] firstObject];
                    noRearchView.iconName = @"noDraw";
                    noRearchView.infoText = @"暂时没有提现记录";
                    noRearchView.center = self.drawListTableView.center;
                    [self.drawListTableView addSubview:noRearchView];
                }
                
            }else{
                
                [self.drawListDataArr removeAllObjects];
                [self.drawListDataArr addObjectsFromArray:cashVos];
                [self.drawListTableView reloadData];
            }
            
            
            [self.drawListTableView.mj_header endRefreshing];
            
            //
            NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
            if (self.drawListDataArr.count == totalCount) {
                [self.drawListTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
            
            if (self.drawListDataArr.count == 0) {
                self.drawListTableView.mj_footer.hidden = YES;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"提现记录加载失败"];
        [self.drawListTableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreDrawList{
    
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setValue:@(self.currentPage) forKey:@"page"];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"cash/list"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.drawListTableView.mj_footer endRefreshing];
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            NSArray *cashVos = [CashVo mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"result"] valueForKey:@"items"]];
            [self.drawListDataArr addObjectsFromArray:cashVos];
            
            NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
            if (self.drawListDataArr.count == totalCount) {
                [self.drawListTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {[SVProgressHUD showErrorWithStatus:@"提现记录加载失败"];
        [self.drawListTableView.mj_footer endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.drawListDataArr.count;
}

-(UITableViewCell *)
tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DrawListCell *cell = [tableView dequeueReusableCellWithIdentifier:DrawListCellId];
    cell.cash = self.drawListDataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CashVo *cash = self.drawListDataArr[indexPath.row];
    
    if (cash.state == CashVoStateToDo) {
        WithDrawDetailViewController *detail = [[WithDrawDetailViewController alloc] init];
        detail.cash = cash;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
@end
