//
//  MemberTotalViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/7/19.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "MemberTotalViewController.h"
#import "MemberTotalCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "LotteryHallRefreshHeader.h"
#import "AccountTotalVo.h"
#import "NoDrawView.h"
#import "NSDate+YYAdd.h"
#import "AccountTotalViewController.h"

typedef enum : NSUInteger {
    ChangeDateEnumToday,
    ChangeDateEnumLastThreeDay,
    ChangeDateEnumLastSenvenDay,
    ChangeDateEnumLastMonth
} ChangeDateEnum;

@interface MemberTotalViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *memberDataArr;
/**
 *  当前页码
 */
@property(nonatomic,assign) NSUInteger currentPage;

@property(nonatomic,strong) NoDrawView *noOrderView;

@property(nonatomic, assign) ChangeDateEnum currentDateType;

@end

@implementation MemberTotalViewController

static NSString * const MemberTotalCellId = @"memberTotalCell";
-(NoDrawView *)noOrderView{
    if (!_noOrderView) {
        _noOrderView = [[[NSBundle mainBundle] loadNibNamed:@"NoDrawView" owner:nil options:nil] firstObject];
        _noOrderView.iconName = @"no_teamreport";
        _noOrderView.infoText = @"暂无报表记录";
        _noOrderView.center = self.view.center;
        [self.tableView addSubview:_noOrderView];
        self.noOrderView = _noOrderView;
    }
    return _noOrderView;
}
-(NSMutableArray *)memberDataArr{
    if (!_memberDataArr) {
        _memberDataArr = [NSMutableArray array];
    }
    return _memberDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团队报表";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.tableView.separatorStyle = NO;[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MemberTotalCell class]) bundle:nil] forCellReuseIdentifier:MemberTotalCellId];
    
    UIButton *rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBarBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBarBtn setTitle:@"今天" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    [rightBarBtn addTarget:self action:@selector(changeDateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    LotteryHallRefreshHeader *header = [LotteryHallRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewMemberList)];
    self.tableView.mj_header = header;
    [header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMemberList)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
}



-(void)loadNewMemberList{
    self.currentPage = 1;
    
    NSMutableDictionary *paramD = [self getRequestParamDict];
    
    
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/list"] parameters:paramD progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            
            [self.memberDataArr removeAllObjects];
            NSArray *itemsArr = [[responseObject valueForKey:@"result"] valueForKey:@"items"];
            
            if (itemsArr.count == 0) {
                self.noOrderView.hidden = NO;
            }else{
                self.noOrderView.hidden = YES;
                
                for (NSDictionary *dict in itemsArr) {
                    NSDictionary *accountDict = [dict valueForKey:@"amount"];
                    AccountTotalVo *account = [AccountTotalVo mj_objectWithKeyValues:accountDict];
                    account.nickName = [[dict valueForKey:@"vip"] valueForKey:@"uid"];
                    [self.memberDataArr addObject:account];
                }
                
                
                [self.tableView reloadData];
            }
            
            
            NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
            if (self.memberDataArr.count == totalCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"团队报表信息加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreMemberList{
    NSMutableDictionary *paramD = [self getRequestParamDict];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/list"] parameters:paramD progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        [self.tableView.mj_footer endRefreshing];
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            NSArray *itemsArr = [[responseObject valueForKey:@"result"] valueForKey:@"items"];
            for (NSDictionary *dict in itemsArr) {
                NSDictionary *accountDict = [dict valueForKey:@"amount"];
                AccountTotalVo *account = [AccountTotalVo mj_objectWithKeyValues:accountDict];
                account.nickName = [[dict valueForKey:@"vip"] valueForKey:@"uid"];
                [self.memberDataArr addObject:account];
            }
            [self.tableView reloadData];
            NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
            if (self.memberDataArr.count == totalCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.currentPage++;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"团队报表信息加载失败"];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(NSMutableDictionary *)getRequestParamDict{
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    
    if (self.currentDateType != ChangeDateEnumToday) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *today = [dateFormatter stringFromDate:[NSDate date]];
        
        
        [paramDict setValue:today forKey:@"dtE_"];
        switch (self.currentDateType) {
            case ChangeDateEnumLastThreeDay:
                
                [paramDict setValue:[dateFormatter stringFromDate:[[NSDate date] dateByAddingDays:-3]] forKey:@"dtB_"];
                break;
            case ChangeDateEnumLastSenvenDay:
                [paramDict setValue:[dateFormatter stringFromDate:[[NSDate date] dateByAddingDays:-7]] forKey:@"dtB_"];
                break;
            case ChangeDateEnumLastMonth:
                [paramDict setValue:[dateFormatter stringFromDate:[[NSDate date] dateByAddingMonths:-1]] forKey:@"dtB_"];
                break;
            default:
                break;
        }
    }
    [paramDict setValue:@(self.currentPage) forKey:@"page"];
    return paramDict;
}



#pragma mark - UITableView Delegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.memberDataArr.count > 0 ? 2 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return self.memberDataArr.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"总帐目";
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.text = @"团队统计";
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.frame = CGRectMake(KScreenWidth - 60 - 30, 3, 60, cell.height + 15);
        [cell.contentView addSubview:detailLabel];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, KScreenWidth, 6)];
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"F1F3E8"];
        [cell.contentView addSubview:lineLabel];
        
        [cell setNeedsLayout];
        return cell;
    }else{
        MemberTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberTotalCellId];
        AccountTotalVo *account = self.memberDataArr[indexPath.row];
        cell.account = account;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 66;
    }else{
        return 150;
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        AccountTotalViewController *accountTotal = [[AccountTotalViewController alloc] init];
        accountTotal.isTeamZhangMu = YES;
        [self.navigationController pushViewController:accountTotal animated:YES];
    }
}

-(void)changeDateClick:(UIButton *)btn{
    UIAlertController *changeDateAlert = [UIAlertController alertControllerWithTitle:@"请选择查询时间段" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(changeDateAlert) weakAlert = changeDateAlert;
    [changeDateAlert addAction:[UIAlertAction actionWithTitle:@"今天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [btn setTitle:@"今天" forState:UIControlStateNormal];
        [self getMemberListWithDate:ChangeDateEnumToday];
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [changeDateAlert addAction:[UIAlertAction actionWithTitle:@"最近3天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [btn setTitle:@"最近3天" forState:UIControlStateNormal];
        [self getMemberListWithDate:ChangeDateEnumLastThreeDay];
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [changeDateAlert addAction:[UIAlertAction actionWithTitle:@"最近7天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [btn setTitle:@"最近7天" forState:UIControlStateNormal];
        [self getMemberListWithDate:ChangeDateEnumLastSenvenDay];
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [changeDateAlert addAction:[UIAlertAction actionWithTitle:@"最近1个月" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [btn setTitle:@"最近1个月" forState:UIControlStateNormal];
        [self getMemberListWithDate:ChangeDateEnumLastMonth];
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }]];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [changeDateAlert addAction:cancleAction];
    changeDateAlert.view.tintColor = [UIColor colorWithHexString:@"4E5151"];
    [self presentViewController:changeDateAlert animated:YES completion:nil];
}

-(void)getMemberListWithDate:(ChangeDateEnum)date{
    if (date != self.currentDateType) {
        self.currentDateType = date;
        [self.tableView.mj_header beginRefreshing];
    }
}

@end
