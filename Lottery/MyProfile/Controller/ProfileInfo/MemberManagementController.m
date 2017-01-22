//
//  MemberManagementController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/22.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "MemberManagementController.h"
#import "MemberManagementCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "LotteryHallRefreshHeader.h"
#import "AddMemberViewController.h"
#import "NoDrawView.h"

@interface MemberManagementController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *memberDataArr;
/**
 *  当前页码
 */
@property(nonatomic,assign) NSUInteger currentPage;
@property(nonatomic,strong) NoDrawView *noOrderView;
@property(nonatomic, strong) UILabel *headerView;
@property(nonatomic, assign) NSInteger totalCount;
@end

@implementation MemberManagementController
static NSString * const MemberManageCellId = @"memberManageCell";
-(NoDrawView *)noOrderView{
    if (!_noOrderView) {
        _noOrderView = [[[NSBundle mainBundle] loadNibNamed:@"NoDrawView" owner:nil options:nil] firstObject];
        _noOrderView.iconName = @"no_memberadd";
        _noOrderView.infoText = @"暂时没有记录";
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

-(UILabel *)headerView{
    if (!_headerView) {
        _headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _headerView.textColor = [UIColor colorWithHexString:@"969696"];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        NSString *totalStr = [NSString stringWithFormat:@"%zd",self.totalCount];
        NSString *baseStr = [NSString stringWithFormat:@"    当前团队总人数：%@人",totalStr];
        _headerView.font = [UIFont systemFontOfSize:14];
        NSRange range = [baseStr rangeOfString:totalStr];
        NSMutableAttributedString *muBaseStr = [[NSMutableAttributedString alloc] initWithString:baseStr];
        [muBaseStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _headerView.attributedText = muBaseStr;
        
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团队管理";
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"add_member"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(goToAddMemberController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.tableView.separatorStyle = NO;[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MemberManagementCell class]) bundle:nil] forCellReuseIdentifier:MemberManageCellId];
    
    
    LotteryHallRefreshHeader *header = [LotteryHallRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewMemberList)];
    self.tableView.mj_header = header;
    [header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMemberList)];
    [self.tableView.mj_footer setAutomaticallyHidden:YES];
}



-(void)loadNewMemberList{
    self.currentPage = 1;
    VipVo *vip = KGetVip;
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/list"] parameters:@{@"vipId":vip.vipId,@"vipToken":vip.token,@"page":@(self.currentPage)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
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
                // 如果有数据，并且view的subviews的最后一个view是NoDrawView，就remove掉
                if ([self.view.subviews.lastObject isKindOfClass:[NoDrawView class]]) {
                    [self.view.subviews.lastObject removeFromSuperview];
                }
                
                for (NSDictionary *dict in itemsArr) {
                    NSDictionary *vipDict = [dict valueForKey:@"vip"];
                    VipVo *vip = [VipVo mj_objectWithKeyValues:vipDict];
                    [self.memberDataArr addObject:vip];
                }
                
                [self.tableView reloadData];
                
                
                NSInteger totalCount = [[[responseObject valueForKey:@"result"] valueForKey:@"rowCount"] integerValue];
                self.totalCount = totalCount;
                if (self.memberDataArr.count == totalCount) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    self.currentPage++;
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"会员信息加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreMemberList{
    VipVo *vip = KGetVip;
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"vip/list"] parameters:@{@"vipId":vip.vipId,@"vipToken":vip.token,@"page":@(self.currentPage)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        [self.tableView.mj_footer endRefreshing];
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            NSArray *itemsArr = [[responseObject valueForKey:@"result"] valueForKey:@"items"];
            for (NSDictionary *dict in itemsArr) {
                NSDictionary *vipDict = [dict valueForKey:@"vip"];
                VipVo *vip = [VipVo mj_objectWithKeyValues:vipDict];
                [self.memberDataArr addObject:vip];
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
        [SVProgressHUD showErrorWithStatus:@"会员信息加载失败"];
        [self.tableView.mj_footer endRefreshing];
    }];
}



#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.memberDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 171;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MemberManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberManageCellId];
    VipVo *vip = self.memberDataArr[indexPath.row];
    cell.vip = vip;
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    NSString *totalStr = [NSString stringWithFormat:@"%zd",self.totalCount];
//    NSString *baseStr = [NSString stringWithFormat:@"    当前团队总人数：%@人",totalStr];
//    NSRange range = [baseStr rangeOfString:totalStr];
//    NSMutableAttributedString *muBaseStr = [[NSMutableAttributedString alloc] initWithString:baseStr];
//    [muBaseStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
//    self.headerView.attributedText = muBaseStr;
//    
//    return self.headerView;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.memberDataArr.count > 0) {
        return self.headerView;
    }else{
        return nil;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(void)goToAddMemberController{
    AddMemberViewController *addMemberVc = [[AddMemberViewController alloc] init];
    [self.navigationController pushViewController:addMemberVc animated:YES];
}



@end
