//
//  LotteryResultViewController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LotteryResultViewController.h"
#import "LotteryResultCell.h"
#import "LotteryResultDetailViewController.h"
//#import "ResultVo.h"
#import "LotteryType.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "LotteryHallRefreshHeader.h"

@interface LotteryResultViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (nonatomic,strong) NSMutableArray *resultDataArr;

@end

@implementation LotteryResultViewController

static NSString * const LotteryResultListCellId = @"resultCell";

-(NSMutableArray *)resultDataArr{
    if (!_resultDataArr) {
        _resultDataArr = [NSMutableArray array];
    }
    return _resultDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开奖";
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.resultTableView.backgroundColor = UIColorFromRGB(0xfefdf8);

    
    [self.resultTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LotteryResultCell class]) bundle:nil] forCellReuseIdentifier:LotteryResultListCellId];
    
    
    LotteryHallRefreshHeader *header = [LotteryHallRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewResultList)];
    self.resultTableView.mj_header = header;
    [header beginRefreshing];
}



-(void)loadNewResultList{
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"result/list_product"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            
            [self.resultDataArr removeAllObjects];
            NSArray *itemsArr = [[responseObject valueForKey:@"result"] valueForKey:@"items"];
            for (NSDictionary *dict in itemsArr) {
                LotteryType *result = [[LotteryType alloc] init];
                result.productVo = [ProductVo mj_objectWithKeyValues:[dict valueForKey:@"product"]];
                result.periodVo = [PeriodVo mj_objectWithKeyValues:[dict valueForKey:@"period"]];
                [self.resultDataArr addObject:result];
            }
            [self.resultTableView reloadData];
            
            [self.resultTableView.mj_header endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"开奖记录加载失败"];
        [self.resultTableView.mj_header endRefreshing];
    }];
}



#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LotteryType *result = self.resultDataArr[indexPath.row];
    return result.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LotteryResultCell *cell = [tableView dequeueReusableCellWithIdentifier:LotteryResultListCellId];
    LotteryType *result = self.resultDataArr[indexPath.row];
    cell.result = result;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LotteryType *result = self.resultDataArr[indexPath.row];
    LotteryResultDetailViewController *resultDetail = [[LotteryResultDetailViewController alloc] init];
    resultDetail.result = result;
    [self.navigationController pushViewController:resultDetail animated:YES];
}



@end
