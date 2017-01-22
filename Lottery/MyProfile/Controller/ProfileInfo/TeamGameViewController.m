//
//  TeamGameViewController.m
//  Lottery
//
//  Created by jiangyuanlu on 16/9/8.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "TeamGameViewController.h"

#import "NoDrawView.h"
#import "TeamGameCell.h"
#import "TeamGameVo.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "LotteryHallRefreshHeader.h"

@interface TeamGameViewController ()

@property(nonatomic,strong) NSMutableArray *teamGameDataArr;

/**
 *  当前页码
 */
@property(nonatomic,assign) NSUInteger currentPage;
@property(nonatomic,strong) NoDrawView *noOrderView;
@end

@implementation TeamGameViewController

static NSString * const TeamGameCellId = @"teamGameCellId";

-(NoDrawView *)noOrderView{
    if (!_noOrderView) {
        _noOrderView = [[[NSBundle mainBundle] loadNibNamed:@"NoDrawView" owner:nil options:nil] firstObject];
        _noOrderView.iconName = @"no_teambetting";
        _noOrderView.infoText = @"暂无团队游戏记录";
        _noOrderView.center = self.tableView.center;
        [self.tableView addSubview:_noOrderView];
        self.noOrderView = _noOrderView;
    }
    return _noOrderView;
}

-(NSMutableArray *)teamGameDataArr{
    if (!_teamGameDataArr) {
        _teamGameDataArr = [NSMutableArray array];
    }
    return _teamGameDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"团队游戏记录";
    self.tableView.backgroundColor = UIColorFromRGB(0xfefdf8);
    self.view.backgroundColor = KBGColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeamGameCell class]) bundle:nil] forCellReuseIdentifier:TeamGameCellId];
    self.currentPage = 1;
    
    
    LotteryHallRefreshHeader *header = [LotteryHallRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTeamGameList)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTeamGameList)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
}

-(void)loadNewTeamGameList{
    VipVo *vip = KGetVip;
    self.currentPage = 1;
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setValue:@(self.currentPage) forKey:@"page"];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"teamGame/list"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            [self.teamGameDataArr removeAllObjects];
            
            NSArray *teamGameVos = [TeamGameVo mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"result"] valueForKey:@"items"]];
            if (teamGameVos.count == 0) {
                self.noOrderView.hidden = NO;
            }else{
                self.noOrderView.hidden = YES;
                
                NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
                [self.teamGameDataArr addObjectsFromArray:teamGameVos];
                if (self.teamGameDataArr.count == totalCount) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    self.currentPage++;
                }
            }
            [self.tableView reloadData];
//            [self.tableView.mj_footer setHidden:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"团队游戏记录加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreTeamGameList{
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setValue:@(self.currentPage) forKey:@"page"];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"teamGame/list"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            
            NSArray *teamGameVos = [TeamGameVo mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"result"] valueForKey:@"items"]];
            if (teamGameVos.count == 0) {
                self.noOrderView.hidden = NO;
            }else{
                self.noOrderView.hidden = YES;
                
                NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
                [self.teamGameDataArr addObjectsFromArray:teamGameVos];
                if (self.teamGameDataArr.count == totalCount) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    self.currentPage++;
                }
            }
            [self.tableView reloadData];
            [self.tableView.mj_footer setHidden:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"团队游戏记录加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.teamGameDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamGameCell *cell = [tableView dequeueReusableCellWithIdentifier:TeamGameCellId];
    TeamGameVo *teamGameVo = self.teamGameDataArr[indexPath.row];
    cell.teamGame = teamGameVo;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}
@end
