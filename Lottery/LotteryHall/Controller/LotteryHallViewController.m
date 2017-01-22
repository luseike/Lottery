//
//  LotteryHallViewController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LotteryHallViewController.h"
#import "LotteryPageView.h"
#import "LotteryTypeView.h"
#import "ShiShiCaiViewController.h"
#import "FuCaiThreeDViewController.h"
#import "ElevenChooseFiveController.h"
#import "FastThreeViewController.h"
#import "BeiJingPK10ViewController.h"
#import "LiuHeCaiViewController.h"
#import "LotteryNavigationController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "LotteryHallRefreshHeader.h"
#import "BettingListViewController.h"
#import "PlayCategory.h"

@interface LotteryHallViewController ()<LotteryPageViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic,strong) UIScrollView *containerScrollerView;
@property (nonatomic,strong) LotteryPageView *pageView;
@property(nonatomic,strong) LotteryTypeView *firstTypeView;
@end

@implementation LotteryHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"威尼斯娱乐";
    
    self.containerScrollerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.containerScrollerView.backgroundColor = UIColorFromRGB(0xfefdf8);
    [self.view addSubview:self.containerScrollerView];
    
    LotteryPageView *pageView = [LotteryPageView pageView];
    pageView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight * 0.22);
    [self.containerScrollerView addSubview:pageView];
    pageView.delagate = self;
    self.pageView = pageView;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    LotteryHallRefreshHeader *header = [LotteryHallRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    // 设置header
    self.containerScrollerView.mj_header = header;
    
}

-(void)loadData{
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"product/list"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.containerScrollerView.mj_header endRefreshing];
        
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
            // 广告图片
            NSArray *imgUrls = [[responseObject valueForKey:@"result"] valueForKey:@"adList"];
            NSMutableArray *adMutableArr = [NSMutableArray arrayWithCapacity:imgUrls.count];
            for (NSDictionary *adDict in imgUrls) {
                [adMutableArr addObject:[adDict valueForKey:@"imageUrl"]];
            }
            self.pageView.imageUrls = adMutableArr;
            [self.pageView setNeedsLayout];
            
            NSArray *dataSource = [[responseObject valueForKey:@"result"] valueForKey:@"productList"];
            NSMutableArray *types = [NSMutableArray arrayWithCapacity:dataSource.count];
            for (NSDictionary *dict in dataSource) {
                LotteryType *type = [[LotteryType alloc] init];
                type.productVo = [ProductVo mj_objectWithKeyValues:[dict valueForKey:@"product"]];
                type.periodVo = [PeriodVo mj_objectWithKeyValues:[dict valueForKey:@"period"]];
                
                [types addObject:type];
            }
            
            CGFloat typeViewH = (75 / KIPhone6Height) * KScreenHeight;//KScreenHeight * 0.11;
            CGFloat typeViewW = KScreenWidth * 0.5;
            CGFloat startY = CGRectGetMaxY(self.pageView.frame);
            NSUInteger maxColumn = 2;
            //containerScrollerView 的可滚动高度
            CGFloat scrollViewContentY = 0;
            
            for (NSInteger i = 0; i < types.count; i++) {
                LotteryTypeView *typeView = [[[NSBundle mainBundle] loadNibNamed:@"LotteryTypeView" owner:nil options:nil] firstObject];
                
                typeView.typeModel = types[i];
                NSUInteger row = i / maxColumn;
                NSUInteger column = i % maxColumn;
                typeView.frame = CGRectMake(typeViewW * column, startY + typeViewH * row, KScreenWidth * 0.5, typeViewH);
                
                if (i % 2 == 1) {
                    typeView.rightLineLabel.hidden = YES;
                }
                if (i == 0) {
                    self.firstTypeView = typeView;
                }
                [typeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeViewClick:)]];
                if (i == types.count-1) {
                    scrollViewContentY = CGRectGetMaxY(typeView.frame);
                }
                [self.containerScrollerView addSubview:typeView];
                
            }
            
            self.containerScrollerView.contentSize = CGSizeMake(0, scrollViewContentY + 64);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.containerScrollerView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载购彩大厅数据失败！"];
    }];
}

-(void)typeViewClick:(UITapGestureRecognizer *)gesture{
    LotteryTypeView *view = (LotteryTypeView *)gesture.view;
    LotteryType *lotteryType = view.typeModel;
    
    LotteryNavigationController *nav = nil;
    
    if ([lotteryType.productVo.name containsString:@"时时彩"] || [lotteryType.productVo.name isEqualToString:@"五分彩"] || [lotteryType.productVo.name isEqualToString:@"分分彩"]) {
        ShiShiCaiViewController *vc = [[ShiShiCaiViewController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = lotteryType;
        NSArray *shishicaiDataSource = [PlayCategory mj_objectArrayWithFilename:[NSString stringWithFormat:@"%@.plist",lotteryType.productVo.name]];
        vc.shishicaiDataSource = shishicaiDataSource;
        [self presentViewController:nav animated:YES completion:nil];
    }else if([lotteryType.productVo.name containsString:@"11选5"]){
        ElevenChooseFiveController *vc = [[ElevenChooseFiveController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = lotteryType;
        [self presentViewController:nav animated:YES completion:nil];
    }else if([lotteryType.productVo.name containsString:@"快3"]){
        FastThreeViewController *vc = [[FastThreeViewController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = lotteryType;
        [self presentViewController:nav animated:YES completion:nil];
    }else if([lotteryType.productVo.name containsString:@"北京pk10"]){
        BeiJingPK10ViewController *vc = [[BeiJingPK10ViewController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = lotteryType;
        [self presentViewController:nav animated:YES completion:nil];
    }else if([lotteryType.productVo.name containsString:@"六合彩"]){
        LiuHeCaiViewController *vc = [[LiuHeCaiViewController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = lotteryType;
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        FuCaiThreeDViewController *vc = [[FuCaiThreeDViewController alloc] init];
        nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
        vc.lotteryType = lotteryType;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)imgDidClick:(UIImage *)imgView imgUrl:(NSString *)url{
    ShiShiCaiViewController *vc = [[ShiShiCaiViewController alloc] init];
    LotteryNavigationController *nav = [[LotteryNavigationController alloc] initWithRootViewController:vc];
    vc.lotteryType = self.firstTypeView.typeModel;
    NSArray *shishicaiDataSource = [PlayCategory mj_objectArrayWithFilename:[NSString stringWithFormat:@"%@.plist",self.firstTypeView.typeModel.productVo.name]];
    vc.shishicaiDataSource = shishicaiDataSource;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)imgViewClick:(UITapGestureRecognizer *)gesture{
    
}


@end
