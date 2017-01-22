//
//  LotteryResultDetailViewController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/17.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LotteryResultDetailViewController.h"
#import <MJExtension.h>
#import <MJRefresh.h>
//#import "ResultVo.h"
#import "LotteryType.h"
#import "LotteryResultDetailCell.h"

#import "ShiShiCaiViewController.h"
#import "FuCaiThreeDViewController.h"
#import "ElevenChooseFiveController.h"
#import "FastThreeViewController.h"
#import "BeiJingPK10ViewController.h"
#import "LiuHeCaiViewController.h"
#import "LotteryNavigationController.h"
#import "BettingListViewController.h"
#import "PlayCategory.h"
#import "LotteryHallRefreshHeader.h"

@interface LotteryResultDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *detailResultTableView;
@property (weak, nonatomic) IBOutlet UIButton *bettingBtn;
@property (nonatomic,strong) NSMutableArray *detailResultDataArr;
/**
 *  当前页码
 */
@property(nonatomic,assign) NSUInteger currentPage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@end

@implementation LotteryResultDetailViewController

static NSString * const LotteryResultDetailListCellId = @"resultDetailCell";

-(NSMutableArray *)detailResultDataArr{
    if (!_detailResultDataArr) {
        _detailResultDataArr = [NSMutableArray array];
    }
    return _detailResultDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _detailResultTableView.backgroundColor = UIColorFromRGB(0xfefdf8);
    _detailResultTableView.delegate = self;
    _detailResultTableView.dataSource = self;
    
    self.title = self.result.productVo.name;
    [self.bettingBtn setTitle:[NSString stringWithFormat:@"投注%@",self.title] forState:UIControlStateNormal];
    self.bettingBtn.layer.cornerRadius = 3;
    self.bettingBtn.layer.masksToBounds = YES;
    
    self.detailResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.detailResultTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LotteryResultDetailCell class]) bundle:nil] forCellReuseIdentifier:LotteryResultDetailListCellId];
    
    LotteryHallRefreshHeader *header = [LotteryHallRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDetailResultList)];
    self.detailResultTableView.mj_header = header;
    [self.detailResultTableView.mj_header beginRefreshing];
    
    if (self.hiddenBottomView) {
        NSLog(@"%f",self.tableViewBottomConstraint.constant);
        self.tableViewBottomConstraint.constant = 0;
    }
}




-(void)loadNewDetailResultList{
    self.currentPage = 1;
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"result/list"] parameters:@{@"product.id":self.result.productVo.productId,@"page":@(self.currentPage)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            
            [self.detailResultDataArr removeAllObjects];
            NSArray *itemsArr = [[responseObject valueForKey:@"result"] valueForKey:@"items"];
            NSInteger showItemsCount = self.hiddenBottomView ? 10 : itemsArr.count;
            for (NSInteger i = 0; i < showItemsCount; i++) {
                NSDictionary *itemDict = itemsArr[i];
                LotteryType *result = [[LotteryType alloc] init];
                result.productVo = [ProductVo mj_objectWithKeyValues:[itemDict valueForKey:@"product"]];
                result.periodVo = [PeriodVo mj_objectWithKeyValues:[itemDict valueForKey:@"period"]];
                if (i == 0) {
                    result.isFirstItem = YES;
                }else{
                    result.isFirstItem = NO;
                }
                [self.detailResultDataArr addObject:result];
            }
            [self.detailResultTableView reloadData];
            
            [self.detailResultTableView.mj_header endRefreshing];
            
            
            NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
            if (self.detailResultDataArr.count == totalCount) {
                [self.detailResultTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"开奖记录加载失败"];
        [self.detailResultTableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreDetailResultList{
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"result/list"] parameters:@{@"product.id":self.result.productVo.productId,@"page":@(self.currentPage)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        [self.detailResultTableView.mj_footer endRefreshing];
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            NSArray *itemsArr = [[responseObject valueForKey:@"result"] valueForKey:@"items"];
            for (NSDictionary *dict in itemsArr) {
                LotteryType *result = [[LotteryType alloc] init];
                result.productVo = [ProductVo mj_objectWithKeyValues:[dict valueForKey:@"product"]];
                result.periodVo = [PeriodVo mj_objectWithKeyValues:[dict valueForKey:@"period"]];
                [self.detailResultDataArr addObject:result];
            }
            [self.detailResultTableView reloadData];
            NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
            if (self.detailResultDataArr.count == totalCount) {
                [self.detailResultTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"开奖记录加载失败"];
        [self.detailResultTableView.mj_footer endRefreshing];
    }];
}


#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailResultDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LotteryType *result = self.detailResultDataArr[indexPath.row];
    return result.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LotteryResultDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:LotteryResultDetailListCellId];
    LotteryType *result = self.detailResultDataArr[indexPath.row];
    cell.result = result;
    return cell;
}

/**
 *  投注
 */
- (IBAction)bettingBtnClick:(UIButton *)sender {
    LotteryNavigationController *nav = nil;
    if ([self.title containsString:@"时时彩"] || [self.title isEqualToString:@"五分彩"] || [self.title isEqualToString:@"分分彩"]) {
        ShiShiCaiViewController *vc = [[ShiShiCaiViewController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = self.result;
        vc.shishicaiDataSource = [PlayCategory mj_objectArrayWithFilename:[NSString stringWithFormat:@"%@.plist",self.title]];
        [self presentViewController:nav animated:YES completion:nil];
    }else if([self.title containsString:@"11选5"]){
        ElevenChooseFiveController *vc = [[ElevenChooseFiveController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = self.result;
        [self presentViewController:nav animated:YES completion:nil];
    }else if([self.title containsString:@"快3"]){
        FastThreeViewController *vc = [[FastThreeViewController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = self.result;
        [self presentViewController:nav animated:YES completion:nil];
    }else if([self.title containsString:@"北京pk10"]){
        BeiJingPK10ViewController *vc = [[BeiJingPK10ViewController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = self.result;
        [self presentViewController:nav animated:YES completion:nil];
    }else if([self.title containsString:@"六合彩"]){
        LiuHeCaiViewController *vc = [[LiuHeCaiViewController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = self.result;
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        FuCaiThreeDViewController *vc = [[FuCaiThreeDViewController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = self.result;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
