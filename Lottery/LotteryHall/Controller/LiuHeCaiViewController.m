//
//  LiuHeCaiViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/5/27.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "LiuHeCaiViewController.h"
#import "NavigationTitleView.h"
#import "UIImage+ImageWithColor.h"
#import "NumberPanView.h"
#import "PlayCategoryBtn.h"
#import "MJExtension.h"
#import "PlayCategory.h"
#import "LotteryLHCNumberPanCell.h"
#import "LotteryNumberPanModel.h"
#import "BettingListViewController.h"
#import "BettingListModel.h"
#import "OrderCheckView.h"
#import "FaceViewController.h"
#import "PlayedVo.h"

@interface LiuHeCaiViewController ()<LotteryLHCNumberPanCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) NSArray *lhcDataSource;
@property (nonatomic,strong) NSArray *playedVos;
@property (nonatomic,strong) NSArray *tableViewDataSource;
@property (nonatomic,strong) UIView *chooseView;
@property (nonatomic,strong) UIButton *maskBtnView;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *playDescriptionLabel;
@property (nonatomic,copy) NSMutableString *playDescriptionStr;
@property (weak, nonatomic) IBOutlet UIButton *clearSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *playedVoLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedNumbersLabel;
@property (weak, nonatomic) IBOutlet UITableView *lhcTable;
@property (weak, nonatomic) IBOutlet UITextField *multipleField;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *modelBtn;

@property (nonatomic,strong) UIButton *maskBtn;
/**
 *  当前选中玩法的序号
 */
@property(nonatomic,assign) NSUInteger selectedIndex;
/**
 *  当前选中的注数
 */
@property(nonatomic,assign) NSUInteger bettingCount;
/**
 *  给下注列表显示的数字
 */
@property (nonatomic,copy) NSString *numbersForBettingList;
/**
 *  投注列表要显示的数据集合
 */
@property(nonatomic,strong) NSMutableArray *bettingDataSource;

@end

@implementation LiuHeCaiViewController

-(NSArray *)lhcDataSource{
    if (!_lhcDataSource) {
        _lhcDataSource = [PlayCategory mj_objectArrayWithFilename:[NSString stringWithFormat:@"%@.plist",self.lotteryType.productVo.name]];
    }
    return _lhcDataSource;
}

-(NSArray *)playedVos{
    if (!_playedVos) {
        _playedVos = [NSArray array];
    }
    return _playedVos;
}
-(NSArray *)tableViewDataSource{
    if (!_tableViewDataSource) {
        _tableViewDataSource = [NSArray array];
    }
    return _tableViewDataSource;
}
-(NSMutableArray *)bettingDataSource{
    if (!_bettingDataSource) {
        _bettingDataSource = [NSMutableArray array];
    }
    return _bettingDataSource;
}
-(UIButton *)maskBtn{
    if (!_maskBtn) {
        _maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _maskBtn.frame = [UIScreen mainScreen].bounds;
        _maskBtn.backgroundColor = [UIColor clearColor];//RGBA(0, 0, 0, 0.3);
        [_maskBtn addTarget:self action:@selector(maskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f9f8f0"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCheckDidConform) name:@"KOrderCheckDidConformNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCheckRepeatConform:) name:@"KOrderCheckRepeatConformNotification" object:nil];
    // 初始化一些样式
    [self setupView];
    
    
    [self setupHeaderView];
    // 设置tableView的数据源
    self.tableViewDataSource = [[self.lhcDataSource firstObject] valueForKey:@"numberPanModels"];
    [self.lhcTable reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getRetainSeconds];
}

#pragma mark - 获取倒计时剩余的秒数
-(void)getRetainSeconds{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:self.lotteryType.productVo.productId forKey:@"productId"];
    VipVo *vip = KGetVip;
    if (vip.token.length > 0) {
        [paramDict setValue:vip.token forKey:@"vipToken"];
        [paramDict setValue:vip.vipId forKey:@"vipId"];
    }
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"product/form"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] != 200) {
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }else{
//            ProductVo *product = [ProductVo mj_objectWithKeyValues:[[responseObject valueForKey:@"result"] valueForKey:@"product"]];
            self.playedVos = [PlayedVo mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"result"] valueForKey:@"playeds"]];
            //如果该彩种停止销售，倒计时不开启，显示时间做特殊处理
//            if (product.state == 1) {
//                NSMutableAttributedString *closeLabelAttributeStr = [[NSMutableAttributedString alloc] initWithString:@"距**期截止:--:--"];
//                [closeLabelAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7, 5)];
//                self.closeDateLabel.attributedText = closeLabelAttributeStr;
//            }else{
//                NSDate *nowDate = [NSDate getDateFromDateString:[[responseObject valueForKey:@"result"] valueForKey:@"now"]];
//                NSDictionary *dict = [responseObject valueForKey:@"result"];
//                PeriodVo *period = [PeriodVo mj_objectWithKeyValues:[dict valueForKey:@"period"]];
//                self.lotteryType.periodVo = period;
//                NSDate *endDate = [NSDate getDateFromDateString:period.timeEnd];
//                self.retainSecond = [endDate timeIntervalSinceReferenceDate] - [nowDate timeIntervalSinceReferenceDate];
//                if (self.timer) {
//                    //计时器存在，说明上一期次已结束
//                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"期次已切换，当前是%@期",self.lotteryType.periodVo.name]];
//                }
//                // 开启定时器，开始倒计时
//                
//                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setCloseDateLabelText:) userInfo:nil repeats:YES];
//            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}



#pragma mark - 点击购买确定后
-(void)orderCheckDidConform{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"付款成功" message:@"等待系统为您开奖!" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alertVc) weakAlertVc = alertVc;
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self clearSelectBtnClick];
        [weakAlertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
    
//    [self clearSelectBtnClick];
}
#pragma mark - 已过期的彩种重新投注
-(void)orderCheckRepeatConform:(NSNotification *)notifi{
    NSDictionary *infoDict = notifi.userInfo;
    NSLog(@"%@",infoDict);
    NSDictionary *commitParam = [infoDict valueForKey:@"commitParam"];
    NSString *newPeriod = [infoDict valueForKey:@"newPeriod"];
    NSString *oldPeriod = [commitParam valueForKey:@"period"];
    NSString *msg = [NSString stringWithFormat:@"第%@期已停止，当前是%@期，确定继续投注？",oldPeriod,newPeriod];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"期次改变提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alertVc) weakAlertVc = alertVc;
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self clearSelectBtnClick];
        OrderCheckView *checkView = [[[NSBundle mainBundle] loadNibNamed:@"OrderCheckView" owner:nil options:nil] firstObject];
        
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:commitParam];
        [mutableDict setValue:newPeriod forKey:@"period"];
        [checkView repeatCommitWithParamDict:mutableDict];
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
}



#pragma mark - 初始化一些样式，添加导航按钮
-(void)setupView{
    self.clearSelectBtn.enabled = NO;
    self.clearSelectBtn.layer.cornerRadius = 5;
    self.clearSelectBtn.layer.masksToBounds = YES;
    self.sureBtn.enabled = NO;
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    
    
    UIButton *navigationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navigationBtn setBackgroundImage:[UIImage imageNamed:@"navigation_title_bg"] forState:UIControlStateNormal];
    [navigationBtn setBackgroundImage:[UIImage imageNamed:@"navigation_title_bg"] forState:UIControlStateHighlighted];
    [navigationBtn setTitle:@"特码直选" forState:UIControlStateNormal];
    navigationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    CGSize textSize = [navigationBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:navigationBtn.titleLabel.font}];
    navigationBtn.height = 20;
    navigationBtn.width = textSize.width + 20;
    navigationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.navigationItem.titleView = navigationBtn;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    self.lhcTable.delegate = self;
    self.lhcTable.dataSource = self;
    self.multipleField.delegate = self;
}

#pragma mark - 显示模式选择view
- (IBAction)showModelView:(UIButton *)sender {
    if (self.maskBtn) {
        [self maskBtnClick:self.maskBtn];
    }
    NSInteger mul = [self.multipleField.text integerValue];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertC addAction:[UIAlertAction actionWithTitle:@"元" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"元" forState:UIControlStateNormal];
        float bettingMoney = self.bettingCount * 2 * mul * 1;
        self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",self.bettingCount,@(bettingMoney)] : @"";
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"角" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"角" forState:UIControlStateNormal];
        float bettingMoney = self.bettingCount * 2 * mul * 0.1;
        self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",self.bettingCount,@(bettingMoney)] : @"";
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"分" forState:UIControlStateNormal];
        float bettingMoney = self.bettingCount * 2 * mul * 0.01;
        self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",self.bettingCount,@(bettingMoney)] : @"";
    }]];
    __weak typeof(alertC)weakAlertC = alertC;
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlertC dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 键盘已经弹出时调用
-(void)keyBoardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect rect = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = rect.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -kbHeight);
        
        
    } completion:^(BOOL finished) {
        [self.view insertSubview:self.maskBtn belowSubview:self.bottomView];
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 0) {
        if ([string isEqualToString:@"0"]) {
            return NO;
        }else{
            return YES;
        }
    }else if (range.location >= 5){
        return NO;
    }else{
        return YES;
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@"0"] || [textField.text isEqualToString:@""]) {
        textField.text = @"1";
    }
    
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = @"";
    return YES;
}

-(void)maskBtnClick:(UIButton *)btn{
    [UIView animateWithDuration:0.2 animations:^{
        [self.view endEditing:YES];
        self.bottomView.transform = CGAffineTransformIdentity;
        [self.maskBtn removeFromSuperview];
        
        if (self.bettingCount > 0) {
            NSInteger mul = [self.multipleField.text integerValue];
            NSString *model = self.modelBtn.currentTitle;
            float bettingMoney = 0;
            if ([model isEqualToString:@"角"]) {
                bettingMoney = self.bettingCount * 2 * mul * 0.1;
            }else if ([model isEqualToString:@"分"]){
                bettingMoney = self.bettingCount * 2 * mul * 0.01;
            }else{
                bettingMoney = self.bettingCount * 2 * mul * 1;
            }
            self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",self.bettingCount,@(bettingMoney)] : @"";
        }
    }];

}


-(void)setupHeaderView{
    
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor clearColor];
    header.width = KScreenWidth;
    
    UILabel *playDescLabel = [[UILabel alloc] init];
    playDescLabel.text = @"玩法说明：";
    playDescLabel.font = [UIFont systemFontOfSize:14];
    playDescLabel.textColor = [UIColor orangeColor];
    playDescLabel.x = 15;
    playDescLabel.y = 5;
    playDescLabel.width = 100;
    [playDescLabel sizeToFit];
    [header addSubview:playDescLabel];
    
    UILabel *playDescriptionLabel = [[UILabel alloc] init];
    playDescriptionLabel.numberOfLines = 0;
    playDescriptionLabel.font = [UIFont systemFontOfSize:12];
    playDescriptionLabel.textColor = [UIColor grayColor];
    playDescriptionLabel.x = playDescLabel.x;
    playDescriptionLabel.y = CGRectGetMaxY(playDescLabel.frame) + 8;
    playDescriptionLabel.width = KScreenWidth - 2 * playDescLabel.x;
    playDescriptionLabel.text = @"当期开奖的最后一个号码叫“特码”，若投注的号码与开奖特码相同，即中奖";
    [playDescriptionLabel sizeToFit];
    self.playDescriptionLabel = playDescriptionLabel;
    [header addSubview:playDescriptionLabel];
    header.x = 0;
    header.y = 0;
    header.width = KScreenWidth;
    header.height = CGRectGetMaxY(playDescriptionLabel.frame);
    
    self.headerView = header;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identification = @"numberPanCell";
    LotteryLHCNumberPanCell *cell = [tableView dequeueReusableCellWithIdentifier:identification];
    if (cell == nil) {
        cell = [[LotteryLHCNumberPanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identification];
        
    }
    
    
    cell.lhcDelegate = self;
    cell.isShowSeperateBtns = YES;
    cell.numberPanModel = self.tableViewDataSource[indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.headerView.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 650 * KScreenHeight / 667;
}

-(void)LHCNumberPanCell:(LotteryLHCNumberPanCell *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn{
    NSInteger clickedRow = [self.lhcTable indexPathForCell:numberPanView].row;
    LotteryNumberPanModel *panM = self.tableViewDataSource[clickedRow];
    if (numberBtn.selected) {
        numberBtn.selected = NO;
        panM.selectStrings = [NSString deleteObjStr:numberBtn.currentTitle fromSelectedStr:panM.selectStrings];
    }else{
        
        panM.selectStrings = [NSString appendObjStr:numberBtn.currentTitle toSelectedStr:panM.selectStrings];
    }
    
    
    NSIndexPath *path = [self.lhcTable indexPathForCell:numberPanView];
    [self.lhcTable reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    
    // 遍历数据模型，显示已经选择的数字和注数
    [self setSelectedBettingText];
    
}

-(void)LHCNumberPanCell:(LotteryLHCNumberPanCell *)numberPanView didSelectedSeperateBtn:(UIButton *)seperateBtn{
    NSInteger clickedRow = [self.lhcTable indexPathForCell:numberPanView].row;
    LotteryNumberPanModel *panM = self.tableViewDataSource[clickedRow];
    
    if ([seperateBtn.currentTitle isEqualToString:@"大"]) {
        panM.selectStrings = @"26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49";
    }else if([seperateBtn.currentTitle isEqualToString:@"小"]) {
        panM.selectStrings = @"01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25";
    }else if([seperateBtn.currentTitle isEqualToString:@"双"]) {
        panM.selectStrings = @"02 04 06 08 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48";
    }else if([seperateBtn.currentTitle isEqualToString:@"单"]) {
        panM.selectStrings = @"01 03 05 07 09 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49";
    }else if([seperateBtn.currentTitle isEqualToString:@"清"]) {
        panM.selectStrings = @"";
    }else if([seperateBtn.currentTitle isEqualToString:@"全"]) {
        panM.selectStrings = @"01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49";
    }
    
    NSIndexPath *path = [self.lhcTable indexPathForCell:numberPanView];
    [self.lhcTable reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    
    // 遍历数据模型，显示已经选择的数字和注数
    [self setSelectedBettingText];
}

#pragma mark - 设置底部selectedNumbersLabel和selectedInfoLabel的文案
-(void)setSelectedBettingText{
    
    LotteryNumberPanModel *numberM = [self.tableViewDataSource firstObject];
    
    NSInteger chooseCount = 0;
    
    NSString *showSelectedNumbers = @"";
    if (numberM.selectStrings.length > 0) {
        
        NSArray *selectedArr = [numberM.selectStrings componentsSeparatedByString:@" "];
        chooseCount = selectedArr.count;
        
        showSelectedNumbers = numberM.selectStrings;
    }
    
//    self.selectedInfoLabel.text = chooseCount == 0 ? @"" : [NSString stringWithFormat:@"共%ld注 %ld元",chooseCount,chooseCount * 2];
    NSInteger mul = [self.multipleField.text integerValue];
    NSString *model = self.modelBtn.currentTitle;
    float bettingMoney = 1;
    if ([model isEqualToString:@"角"]) {
        bettingMoney = chooseCount * 2 * mul * 0.1;
    }else if ([model isEqualToString:@"分"]){
        bettingMoney = chooseCount * 2 * mul * 0.01;
    }else{
        bettingMoney = chooseCount * 2 * mul;
    }
    self.selectedInfoLabel.text = chooseCount > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",chooseCount,@(bettingMoney)] : @"";
    
    
    PlayCategory *playCategory = self.lhcDataSource[self.selectedIndex];
    
    if (self.playedVos.count != 0) {
        for (PlayedVo *playedVo in self.playedVos) {
            if ([playedVo.playedId isEqualToString:playCategory.playedId]) {
                VipVo *vip = KGetVip;
                self.playedVoLabel.text = [NSString stringWithFormat:@"%.2f-%.2f%%",playedVo.jiang,vip.fdPst];
            }
        }
    }
    
    self.selectedNumbersLabel.text = showSelectedNumbers;
    self.clearSelectBtn.enabled = chooseCount == 0 ? NO : YES;
    self.sureBtn.enabled = chooseCount == 0 ? NO : YES;
    self.bettingCount = chooseCount;
    self.numbersForBettingList = showSelectedNumbers;
}


#pragma mark - 选择不同的玩法，触发的事件
-(void)chooseBtnClick:(PlayCategoryBtn *)btn{
    [UIView animateWithDuration:0.25 animations:^{
        // 选择完不同的玩法，改变navigationTitle的文字
        NavigationTitleView *titleBtn = (NavigationTitleView *)self.navigationItem.titleView;
        [titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
        self.chooseView.y = -self.chooseView.height;
        [titleBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        
        [self.lhcTable reloadData];
    } completion:^(BOOL finished) {
        [self.maskBtnView removeFromSuperview];
    }];
}


-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 清空按钮点击
- (IBAction)clearSelectBtnClick {
    for (LotteryNumberPanModel *model in self.tableViewDataSource) {
        model.selectStrings = @"";
    }
    [self.lhcTable reloadData];
    self.clearSelectBtn.enabled = NO;
    self.sureBtn.enabled = NO;
    self.selectedInfoLabel.text = @"";
    self.selectedNumbersLabel.text = @"";
}

#pragma mark - 点击确定按钮，跳转到投注列表页面
- (IBAction)sureBtnClick {
    VipVo *vip = KGetVip;
    if (vip) {
        if (self.lotteryType.periodVo.name == nil) {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"抱歉，该彩种暂停销售" preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(alertVc) weakAlertVc = alertVc;
            [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakAlertVc dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertVc animated:YES completion:nil];
        }else{
            if (self.lotteryType.periodVo.name == nil) {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"抱歉，该彩种暂停销售" preferredStyle:UIAlertControllerStyleAlert];
                __weak typeof(alertVc) weakAlertVc = alertVc;
                [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakAlertVc dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alertVc animated:YES completion:nil];
            }else{
                //模式
                NSString *model = self.modelBtn.currentTitle;
                NSInteger mul = [self.multipleField.text integerValue];
                CGFloat modelF = 1;
                if ([model isEqualToString:@"角"]) {
                    modelF = 0.1;
                }else if ([model isEqualToString:@"分"]){
                    modelF = 0.01;
                }
                //投注金额
                NSString *amount = [NSString stringWithFormat:@"%@",@(self.bettingCount * 2 * mul * modelF)];
                
                NSString *selectedContent = [NSString stringFromArray:self.tableViewDataSource useSeperator:@"|" subSeperator:@","];
                
                OrderCheckView *checkView = [[[NSBundle mainBundle] loadNibNamed:@"OrderCheckView" owner:nil options:nil] firstObject];//[[OrderCheckView alloc] init];
                checkView.frame = [UIScreen mainScreen].bounds;
                checkView.orderCheckDict = @{
                                             
                                             @"playedId":@"lhc_tm",
                                             @"playedName":@"特码",
                                             @"productName":self.lotteryType.productVo.name,
                                             @"productId":self.lotteryType.productVo.productId,
                                             @"periodName":self.lotteryType.periodVo.name,//@"第一期"
                                             @"bettingContent":selectedContent,
                                             @"bettingCount":[NSString stringWithFormat:@"%zd",self.bettingCount],
                                             @"bettingMoney":amount,
                                             @"multiple":self.multipleField.text,
                                             @"model":model
                                             
                                             
                                             };
                [[UIApplication sharedApplication].keyWindow addSubview:checkView];
            }
        }
    }else{
        //引导登录
        [UIView animateWithDuration:0.2 animations:^{
            [self.view endEditing:YES];
            [self.maskBtn removeFromSuperview];
            self.bottomView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            FaceViewController *faceVC = [[FaceViewController alloc]init];
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:faceVC] animated:YES completion:nil];
        }];
    }
}

@end
