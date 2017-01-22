//
//  BettingListViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/5/30.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "BettingListViewController.h"
#import "LotteryNavigationController.h"
#import "MJExtension.h"
#import "ShiShiCaiViewController.h"
#import "FuCaiThreeDViewController.h"
#import "ElevenChooseFiveController.h"
#import "FastThreeViewController.h"
#import "BeiJingPK10ViewController.h"
#import "LiuHeCaiViewController.h"
#import "BettingListCell.h"
#import "BettingListModel.h"

@interface BettingListViewController ()<UITableViewDelegate,UITableViewDataSource,BettingListCellClickDelegate>
@property (weak, nonatomic) IBOutlet UIButton *goOnBettingBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearListBtn;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
/**
 *  下注倍数文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *multipleField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *multipleView;
/**
 *  返点文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *returnPointField;
@property (weak, nonatomic) IBOutlet UITableView *bettingTableView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *bettingInfoLabel;

@property(nonatomic,strong) UIButton *maskBtn;
@end

@implementation BettingListViewController
-(UIButton *)maskBtn{
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskBtn.backgroundColor = RGBA(20, 20, 20, 0.2);
        [_maskBtn addTarget:self action:@selector(maskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.lotteryTypeName;
    
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeData:) name:@"BettingListViewChangeDataSourceNotification" object:nil];
}

-(void)changeData:(NSNotification *)notifi{
    
    NSMutableArray *bettingData = (NSMutableArray *)notifi.object;
    self.bettingData =bettingData;
    [self.bettingTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUInteger bettingTotalCount = 0;
    for (BettingListModel *model in self.bettingData) {
        bettingTotalCount += model.bettingCount;
    }
    
    self.moneyLabel.text = [NSString stringWithFormat:@"共%lud元",bettingTotalCount * 2];
    self.bettingInfoLabel.text = [NSString stringWithFormat:@"%zd注 1期 %ld倍",bettingTotalCount,[self.multipleField.text integerValue]];
}

-(void)setupView{
    self.goOnBettingBtn.layer.borderColor = RGB(220, 220, 220).CGColor;
    self.goOnBettingBtn.layer.cornerRadius = 5.0;
    self.goOnBettingBtn.layer.borderWidth = 1.0;
    self.goOnBettingBtn.layer.masksToBounds = YES;
    self.goOnBettingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    self.clearListBtn.layer.borderColor = RGB(220, 220, 220).CGColor;
    self.clearListBtn.layer.borderWidth = 1.0;
    self.clearListBtn.layer.cornerRadius = 5.0;
    self.clearListBtn.layer.masksToBounds = YES;
    self.clearListBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    self.multipleField.layer.borderColor = RGB(220, 220, 220).CGColor;
    self.multipleField.layer.cornerRadius = 5.0;
    self.multipleField.layer.borderWidth = 1.0;
    self.multipleField.layer.masksToBounds = YES;
    
    self.returnPointField.layer.borderColor = RGB(220, 220, 220).CGColor;
    self.returnPointField.layer.cornerRadius = 5.0;
    self.returnPointField.layer.borderWidth = 1.0;
    self.returnPointField.layer.masksToBounds = YES;
    
    self.paymentBtn.layer.cornerRadius = 5;
    self.paymentBtn.layer.masksToBounds = YES;
    
    self.bottomViewHeightConstraint.constant = KScreenHeight * 0.085;
    self.bettingTableView.delegate = self;
    self.bettingTableView.dataSource = self;
    self.bettingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bettingTableView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

//#pragma mark - 键盘已经弹出时调用
//-(void)keyBoardDidShow:(NSNotification *)notification{
//    NSLog(@"%@",notification.userInfo);
//    
//    NSDictionary *userInfo = notification.userInfo;
//    CGRect rect = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat kbHeight = rect.size.height;
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.view insertSubview:self.maskBtn aboveSubview:self.bettingTableView];
//        self.multipleView.transform = CGAffineTransformMakeTranslation(0, -kbHeight + self.bottomViewHeightConstraint.constant);
//    }];
//}

-(void)maskBtnClick:(UIButton *)maskBtn{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.multipleView.transform = CGAffineTransformIdentity;
        [maskBtn removeFromSuperview];
    } completion:^(BOOL finished) {
        if ([self.multipleField.text isEqualToString:@"0"]) {
            self.multipleField.text = @"1";
            [SVProgressHUD showInfoWithStatus:@"最小输入1"];
        }else{
            NSUInteger bettingTotalCount = 0;
            NSUInteger mutiCount = [self.multipleField.text integerValue];
            for (BettingListModel *model in self.bettingData) {
                bettingTotalCount += model.bettingCount;
            }
            
            self.moneyLabel.text = [NSString stringWithFormat:@"共%zd元",bettingTotalCount * 2 * mutiCount];
            
            self.bettingInfoLabel.text = [NSString stringWithFormat:@"%zd注 1期 %ld倍",bettingTotalCount * mutiCount,mutiCount];
        }
    }];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bettingData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BettingListCell *cell = [BettingListCell cellWithTableView:tableView];
    cell.bettingListCellDelegate = self;
    
    BettingListModel *model = self.bettingData[indexPath.row];
    cell.listModel = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (IBAction)goOnBettingBtnClick:(UIButton *)sender {
    LotteryNavigationController *nav = [[LotteryNavigationController alloc] initWithRootViewController:self.lotteryController];
    [self presentViewController:nav animated:YES completion:^{
//        [self.navigationController popViewControllerAnimated:NO];
    }];
    
}
- (IBAction)clearListBtnClick:(UIButton *)sender {
    self.bettingData = nil;
    [self.bettingTableView reloadData];
}

-(void)BettingListCellDidClick:(BettingListCell *)listCell{
    BettingListModel *model = listCell.listModel;
    [self.bettingData removeObject:model];
    [self.bettingTableView reloadData];
}


@end
