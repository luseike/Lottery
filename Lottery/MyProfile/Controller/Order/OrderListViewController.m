//
//  OrderListViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/8/31.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "OrderListViewController.h"
#import "NoDrawView.h"
#import "OrderListCell.h"
#import "OrderVo.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "OrderDetailViewController.h"
#import "LotteryHallRefreshHeader.h"

@interface OrderListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UILabel *tabViewBottomLabel;

/**
 全部
 */
@property(nonatomic,strong) NSMutableArray *allOrderArr;

/**
 待开奖
 */
@property(nonatomic,strong) NSMutableArray *daiKaiJArr;

/**
 已派奖
 */
@property(nonatomic,strong) NSMutableArray *yiPaiJArr;

/**
 *  当前页码
 */
@property(nonatomic,assign) NSUInteger allOrderCurrentPage;
@property(nonatomic,assign) NSUInteger daiKaiJCurrentPage;
@property(nonatomic,assign) NSUInteger yiPaiJCurrentPage;

@property(nonatomic,assign) NSInteger orderState;
@property(nonatomic,strong) NoDrawView *noOrderView;
@end

@implementation OrderListViewController


static NSString * const OrderListCellId = @"orderListCell";
-(NoDrawView *)noOrderView{
    if (!_noOrderView) {
        _noOrderView = [[[NSBundle mainBundle] loadNibNamed:@"NoDrawView" owner:nil options:nil] firstObject];
        _noOrderView.iconName = @"no_betting";
        _noOrderView.infoText = @"暂无相关记录";
        _noOrderView.centerX = self.view.centerX;
        _noOrderView.centerY = self.view.centerY - 30;
        [self.tableView addSubview:_noOrderView];
        self.noOrderView = _noOrderView;
    }
    return _noOrderView;
}
-(NSMutableArray *)daiKaiJArr{
    if (!_daiKaiJArr) {
        _daiKaiJArr = [NSMutableArray array];
    }
    return _daiKaiJArr;
}
-(NSMutableArray *)allOrderArr{
    if (!_allOrderArr) {
        _allOrderArr = [NSMutableArray array];
    }
    return _allOrderArr;
}
-(NSMutableArray *)yiPaiJArr{
    if (!_yiPaiJArr) {
        _yiPaiJArr = [NSMutableArray array];
    }
    return _yiPaiJArr;
}
-(UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, KScreenHeight - 44)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = UIColorFromRGB(0xfefdf8);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabViewBottomLabel = [[UILabel alloc] init];
    self.tabViewBottomLabel.height = 1;
    self.tabViewBottomLabel.y = 43;
    self.tabViewBottomLabel.backgroundColor = [UIColor orangeColor];
    
    
    // 代开奖、未中奖、已派奖 的tab标签
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    tabView.backgroundColor = [UIColor whiteColor];
    [tabView addSubview:self.tabViewBottomLabel];
    
    
    NSArray *tabLabelTitleArr = @[@"全部",@"已派奖",@"待开奖"];
    UIFont *tabLabelFont = [UIFont systemFontOfSize:14];
    CGSize titleSize = [@"已派奖" sizeWithAttributes:@{NSFontAttributeName:tabLabelFont}];
    CGFloat leftMargin = 20;
    CGFloat margin = (KScreenWidth - leftMargin * 2 - titleSize.width * tabLabelTitleArr.count) / (tabLabelTitleArr.count - 1);
    
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *tabLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + (i * (titleSize.width + margin)), 0, titleSize.width, tabView.height)];
        tabLabel.text = tabLabelTitleArr[i];
        tabLabel.textColor = [UIColor grayColor];
        tabLabel.font = tabLabelFont;
        tabLabel.textAlignment = NSTextAlignmentCenter;
        tabLabel.userInteractionEnabled = YES;
//        tabLabel.tag = i + 1;
        [tabLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabLabelClick:)]];
        
        if (i == 0) {
            self.tabViewBottomLabel.x = tabLabel.x;
            self.tabViewBottomLabel.width = tabLabel.width;
            
            self.orderState = -1;
        }else if (i == 1){
            tabLabel.tag = 2;
        }else{
            tabLabel.tag = 3;
        }
        [tabView addSubview:tabLabel];
    }
    [self.view addSubview:tabView];
    self.view.backgroundColor = KBGColor;
    self.title = @"投注记录";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderListCell class]) bundle:nil] forCellReuseIdentifier:OrderListCellId];
    OrderListCell *listCell = [[[NSBundle mainBundle] loadNibNamed:@"OrderListCell" owner:nil options:nil] firstObject];
    self.tableView.rowHeight = listCell.height;
    
    
    LotteryHallRefreshHeader *header = [LotteryHallRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewOrderList)];
    self.tableView.mj_header = header;
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrderList)];
}


- (void)tabLabelClick:(UITapGestureRecognizer *)gesture {
    UILabel *label = (UILabel *)gesture.view;
    if ([label.text isEqualToString:@"全部"]) {
        self.orderState = -1;
    }else if ([label.text isEqualToString:@"已派奖"]){
        self.orderState = 3;
    }else{
        self.orderState = 0;
    }
//    self.orderState = label.tag;
    [UIView animateWithDuration:0.25 animations:^{
        self.tabViewBottomLabel.x = label.x;
        self.tabViewBottomLabel.width = label.width;
    } completion:^(BOOL finished) {
        // 加载对应的类型的数据
        [self.tableView.mj_header beginRefreshing];
    }];
}

-(void)loadNewOrderList{
    
    if (self.orderState == -1) {
        self.allOrderCurrentPage = 1;
    }else if (self.orderState == 0){
        self.daiKaiJCurrentPage = 1;
    }else{
        self.yiPaiJCurrentPage = 1;
    }
    
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setValue:@(1) forKey:@"page"];
    if (self.orderState != -1) {
        [paramDict setValue:@(self.orderState) forKey:@"state"];
    }
    
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"order/list"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            if (self.orderState == -1) {
                [self.allOrderArr removeAllObjects];
            }else if (self.orderState == 0){
                [self.daiKaiJArr removeAllObjects];
            }else{
                [self.yiPaiJArr removeAllObjects];
            }
//            [self.orderListDataArr removeAllObjects];
            NSArray *orderVos = [OrderVo mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"result"] valueForKey:@"items"]];
            if (orderVos.count == 0) {
                self.noOrderView.hidden = NO;
            }else{
                self.noOrderView.hidden = YES;
                
                NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
                if (self.orderState == 0) {
                    [self.daiKaiJArr addObjectsFromArray:orderVos];
                    if (self.daiKaiJArr.count == totalCount) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        self.daiKaiJCurrentPage++;
                    }
                }else if (self.orderState == -1){
                    [self.allOrderArr addObjectsFromArray:orderVos];
                    if (self.allOrderArr.count == totalCount) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        self.allOrderCurrentPage++;
                    }
                }else{
                    [self.yiPaiJArr addObjectsFromArray:orderVos];
                    if (self.yiPaiJArr.count == totalCount) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        self.yiPaiJCurrentPage++;
                    }
                }
            }
            [self.tableView reloadData];
            
            if (self.orderState == 0) {
                if (self.daiKaiJArr.count == 0) {
                    [self.tableView.mj_footer setHidden:YES];
                }
            }else if (self.orderState == -1){
                if (self.allOrderArr.count == 0) {
                    [self.tableView.mj_footer setHidden:YES];
                }
            }else{
                if (self.yiPaiJArr.count == 0) {
                    [self.tableView.mj_footer setHidden:YES];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"订单记录加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreOrderList{
    
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    if (self.orderState == 0) {
        [paramDict setValue:@(self.daiKaiJCurrentPage) forKey:@"page"];
         [paramDict setValue:@(self.orderState) forKey:@"state"];
    }else if (self.orderState == -1){
        [paramDict setValue:@(self.allOrderCurrentPage) forKey:@"page"];
    }else{
        [paramDict setValue:@(self.yiPaiJCurrentPage) forKey:@"page"];
         [paramDict setValue:@(self.orderState) forKey:@"state"];
    }
    
   
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"order/list"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.tableView.mj_footer endRefreshing];
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            NSArray *orderVos = [OrderVo mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"result"] valueForKey:@"items"]];
//            [self.orderListDataArr addObjectsFromArray:orderVos];
            
            
            if (self.orderState == 0) {
                [self.daiKaiJArr addObjectsFromArray:orderVos];
            }else if (self.orderState == -1){
                [self.allOrderArr addObjectsFromArray:orderVos];
            }else{
                [self.yiPaiJArr addObjectsFromArray:orderVos];
            }
            
            
            [self.tableView reloadData];
            NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
            
            if (self.orderState == 0) {
                if (self.daiKaiJArr.count == totalCount) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    if (totalCount == 0) {
                        [self.tableView.mj_footer setHidden:YES];
                    }
                }else{
                    self.daiKaiJCurrentPage++;
                }
            }else if (self.orderState == -1){
                if (self.allOrderArr.count == totalCount) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    if (totalCount == 0) {
                        [self.tableView.mj_footer setHidden:YES];
                    }
                }else{
                    self.allOrderCurrentPage++;
                }
            }else{
                if (self.yiPaiJArr.count == totalCount) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    if (totalCount == 0) {
                        [self.tableView.mj_footer setHidden:YES];
                    }
                }else{
                    self.yiPaiJCurrentPage++;
                }
            }
            
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"订单记录加载失败"];
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderState == 0) {
        return self.daiKaiJArr.count;
    }else if (self.orderState == -1){
        return self.allOrderArr.count;
    }else{
        return self.yiPaiJArr.count;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 163;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderListCellId];
//    cell.order = self.orderListDataArr[indexPath.row];
    OrderVo *orderV = nil;
    if (self.orderState == 0) {
        orderV = self.daiKaiJArr[indexPath.row];
    }else if (self.orderState == -1){
        orderV = self.allOrderArr[indexPath.row];
    }else{
        orderV = self.yiPaiJArr[indexPath.row];
    }
    cell.order = orderV;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    OrderVo *order = self.orderListDataArr[indexPath.row];
    OrderVo *orderV = nil;
    if (self.orderState == 0) {
        orderV = self.daiKaiJArr[indexPath.row];
    }else if (self.orderState == -1){
        orderV = self.allOrderArr[indexPath.row];
    }else{
        orderV = self.yiPaiJArr[indexPath.row];
    }
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    orderDetail.orderVo = orderV;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

@end
