//
//  FuCaiThreeDViewController.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/17.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "FuCaiThreeDViewController.h"
#import "NavigationTitleView.h"
#import "UIImage+ImageWithColor.h"
#import "NumberPanView.h"
#import "PlayCategoryBtn.h"
#import "MJExtension.h"
#import "PlayCategory.h"
#import "LotteryFuCaiNumberCell.h"
#import "LotteryNumberPanModel.h"
#import "BettingListModel.h"
#import "BettingListViewController.h"
#import "OrderCheckView.h"
#import "FaceViewController.h"
#import "PlayedVo.h"

@interface FuCaiThreeDViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryFuCaiNumberPanCellDelegate,UITextFieldDelegate>
/**
 各种玩法的赔率信息
 */
@property (nonatomic,strong) NSArray *playedVos;
@property (nonatomic,strong) NSArray *fuCaicaiDataSource;
@property (nonatomic,strong) NSArray *tableViewDataSource;
@property (nonatomic,strong) UIView *chooseView;
@property (nonatomic,strong) UIButton *maskBtnView;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *playDescriptionLabel;
@property (nonatomic,copy) NSMutableString *playDescriptionStr;

@property(nonatomic,weak) PlayCategoryBtn *selectedPlayCategorybtn;    //记录选中的玩法按钮
@property (weak, nonatomic) IBOutlet UIButton *clearSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *playedVoLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedNumbersLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *fucaiCloseDateLabel;
@property (weak, nonatomic) IBOutlet UITableView *fuCaiNumberPanTable;
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
/**
 *  倒计时剩余秒数
 */
@property(nonatomic,assign) NSInteger fucaiRetainSecond;
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation FuCaiThreeDViewController
-(NSArray *)fuCaicaiDataSource{
    if (!_fuCaicaiDataSource) {
        _fuCaicaiDataSource = [PlayCategory mj_objectArrayWithFilename:[NSString stringWithFormat:@"%@.plist",self.lotteryType.productVo.name]];
    }
    return _fuCaicaiDataSource;
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
    
    //生成彩种选择view
    [self setupChooseView];
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
            ProductVo *product = [ProductVo mj_objectWithKeyValues:[[responseObject valueForKey:@"result"] valueForKey:@"product"]];
            self.playedVos = [PlayedVo mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"result"] valueForKey:@"playeds"]];
            //如果该彩种停止销售，倒计时不开启，显示时间做特殊处理
            if (product.state == 1) {
                NSMutableAttributedString *closeLabelAttributeStr = [[NSMutableAttributedString alloc] initWithString:@"距**期截止:--:--"];
                [closeLabelAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7, 5)];
                self.fucaiCloseDateLabel.attributedText = closeLabelAttributeStr;
            }else{
                NSDate *nowDate = [NSDate getDateFromDateString:[[responseObject valueForKey:@"result"] valueForKey:@"now"]];
                NSDictionary *dict = [responseObject valueForKey:@"result"];
                PeriodVo *period = [PeriodVo mj_objectWithKeyValues:[dict valueForKey:@"period"]];
                self.lotteryType.periodVo = period;
                NSDate *endDate = [NSDate getDateFromDateString:period.timeEnd];
                self.fucaiRetainSecond = [endDate timeIntervalSinceReferenceDate] - [nowDate timeIntervalSinceReferenceDate];
                if (self.timer) {
                    //计时器存在，说明上一期次已结束
                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"期次已切换，当前是%@期",self.lotteryType.periodVo.name]];
                }
                // 开启定时器，开始倒计时
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setCloseDateLabelText:) userInfo:nil repeats:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

-(void)setCloseDateLabelText:(NSTimer *)timer{
    NSInteger currentSecond = --self.fucaiRetainSecond;
    NSInteger mimute = currentSecond / 60;
    NSInteger second = currentSecond % 60;
    NSString *retainTime = [NSString stringWithFormat:@"%02ld:%02ld",(long)mimute,(long)second];
    NSMutableAttributedString *closeLabelAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期截止：%@",[self.lotteryType.periodVo.name substringFromIndex:self.lotteryType.periodVo.name.length - 3],retainTime]];
    [closeLabelAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(closeLabelAttributeStr.length - retainTime.length, retainTime.length)];
    self.fucaiCloseDateLabel.attributedText = closeLabelAttributeStr;
    if (self.fucaiRetainSecond == 0) {
        [timer invalidate];
        timer = nil;
//        [self getRetainSeconds];
    }
}

#pragma mark - 初始化一些样式，添加导航按钮
-(void)setupView{
    self.clearSelectBtn.enabled = NO;
    self.clearSelectBtn.layer.cornerRadius = 5;
    self.clearSelectBtn.layer.masksToBounds = YES;
    self.sureBtn.enabled = NO;
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    
    
    NavigationTitleView *titleView = [[NavigationTitleView alloc] init];
    [titleView addTarget:self action:@selector(titleViewClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    self.fuCaiNumberPanTable.delegate = self;
    self.fuCaiNumberPanTable.dataSource = self;
    
    
    
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
        self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%ld注 %@元",self.bettingCount,@(bettingMoney)] : @"";
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"角" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"角" forState:UIControlStateNormal];
        float bettingMoney = self.bettingCount * 2 * mul * 0.1;
        self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%ld注 %@元",self.bettingCount,@(bettingMoney)] : @"";
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"分" forState:UIControlStateNormal];
        float bettingMoney = self.bettingCount * 2 * mul * 0.01;
        self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%ld注 %@元",self.bettingCount,@(bettingMoney)] : @"";
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 获取倒计时剩余的秒数
        [self getRetainSeconds];
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
            self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%ld注 %@元",self.bettingCount,@(bettingMoney)] : @"";
        }
    }];
}

#pragma mark - 初始化数字选择面板
-(void)setupChooseView{
    UIView *chooseView = [[UIView alloc] init];
    chooseView.backgroundColor = [UIColor whiteColor];
    CGFloat shopViewH = 33;
    NSUInteger maxColumn = 3;
    NSUInteger columnMargin = 10;
    CGFloat shopViewW = (KScreenWidth - ((maxColumn + 1) * columnMargin)) / maxColumn;
    
    for (NSInteger i = 0; i < self.fuCaicaiDataSource.count; i++) {
        PlayCategoryBtn *playCategorybtn = [PlayCategoryBtn buttonWithType:UIButtonTypeCustom];
        PlayCategory *playC = self.fuCaicaiDataSource[i];
        playCategorybtn.playCategory = playC;
        playCategorybtn.titleLabel.font = [UIFont systemFontOfSize:12];
        playCategorybtn.layer.borderColor = RGB(234, 234, 234).CGColor;
        playCategorybtn.layer.borderWidth = 1.0;
        [playCategorybtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [playCategorybtn setBackgroundImage:[UIImage imageWithColor:RGB(247, 180, 91)] forState:UIControlStateSelected];
        [playCategorybtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        [playCategorybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [playCategorybtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        playCategorybtn.frame = CGRectMake((shopViewW + columnMargin) * column + columnMargin, columnMargin + (shopViewH + columnMargin) * row,shopViewW, shopViewH);
        
        [chooseView addSubview:playCategorybtn];
        if (i == 0) {
            [self chooseBtnClick:playCategorybtn];
        }
        if (i == self.fuCaicaiDataSource.count - 1) {
            chooseView.height = CGRectGetMaxY(playCategorybtn.frame) + columnMargin;
        }
    }
    chooseView.width = KScreenWidth;
    chooseView.x = 0;
    chooseView.y = -chooseView.height;
    
    [self.view addSubview:chooseView];
    self.chooseView = chooseView;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identification = @"fucaiNumberPanCell";
    LotteryFuCaiNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identification];
    if (cell == nil) {
        cell = [[LotteryFuCaiNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identification];
        
    }

    cell.customDelegate = self;
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
    return (150 / KIPhone6Height) * KScreenHeight;
}

-(void)FuCaiNumberPanCell:(LotteryFuCaiNumberCell *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn{
    NSInteger clickedRow = [self.fuCaiNumberPanTable indexPathForCell:numberPanView].row;
    LotteryNumberPanModel *panM = self.tableViewDataSource[clickedRow];//numberPanView.numberPanModel;
    if (numberBtn.selected) {
        numberBtn.selected = NO;
        NSString *currentSelectedString = panM.selectStrings;
        panM.selectStrings = [currentSelectedString stringByReplacingOccurrencesOfString:numberBtn.currentTitle withString:@""];
    }else{
        
        NSString *tempStr = [[NSString alloc] init];
        tempStr = [NSString stringWithFormat:@"%@%@",panM.selectStrings,numberBtn.currentTitle];
        panM.selectStrings = tempStr;
        
        NavigationTitleView *titleBtn = (NavigationTitleView *)self.navigationItem.titleView;
        
        if ([titleBtn.currentTitle isEqualToString:@"福彩3D组三单式"]) {
            panM.selectStrings = numberBtn.currentTitle;
            
            if (clickedRow == 0) {
                // 点击在重号numberPan，取出单号模型
                LotteryNumberPanModel *danPanM = self.tableViewDataSource[1];
                if ([danPanM.selectStrings containsString:numberBtn.currentTitle]) {
                    danPanM.selectStrings = @"";
                }
            }else{
                // 点击在单号numberPan，取出重号模型
                LotteryNumberPanModel *chongPanM = self.tableViewDataSource[0];
                if ([chongPanM.selectStrings containsString:numberBtn.currentTitle]) {
                    chongPanM.selectStrings = @"";
                }
            }
        }
    }
    
    NSIndexPath *path = [self.fuCaiNumberPanTable indexPathForCell:numberPanView];
    [self.fuCaiNumberPanTable reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    // 遍历数据模型，显示已经选择的数字和注数
    [self setSelectedBettingText];
}

- (void)FuCaiNumberPanCell:(LotteryFuCaiNumberCell *)numberPanView didSelectedSeperateBtn:(UIButton *)seperateBtn{
    NSInteger clickedRow = [self.fuCaiNumberPanTable indexPathForCell:numberPanView].row;
    LotteryNumberPanModel *panM = self.tableViewDataSource[clickedRow];
    
    
    if ([seperateBtn.currentTitle isEqualToString:@"大"]) {
        panM.selectStrings = @"5 6 7 8 9";
    }else if([seperateBtn.currentTitle isEqualToString:@"小"]) {
        panM.selectStrings = @"0 1 2 3 4";
    }else if([seperateBtn.currentTitle isEqualToString:@"双"]) {
        panM.selectStrings = @"0 2 4 6 8";
    }else if([seperateBtn.currentTitle isEqualToString:@"单"]) {
        panM.selectStrings = @"1 3 5 7 9";
    }else if([seperateBtn.currentTitle isEqualToString:@"清"]) {
        panM.selectStrings = @"";
    }else if([seperateBtn.currentTitle isEqualToString:@"全"]) {
        panM.selectStrings = @"0 1 2 3 4 5 6 7 8 9";
    }
    
    NSIndexPath *path = [self.fuCaiNumberPanTable indexPathForCell:numberPanView];
    [self.fuCaiNumberPanTable reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    
    // 遍历数据模型，显示已经选择的数字和注数
    [self setSelectedBettingText];
}

#pragma mark - 设置底部selectedNumbersLabel和selectedInfoLabel的文案
-(void)setSelectedBettingText{
    NSInteger chooseCount = [self getBettingCountFromPlayCategory];
    
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
    self.selectedInfoLabel.text = [NSString stringWithFormat:@"共%ld注 %@元",chooseCount,@(bettingMoney)];
    
    PlayCategory *playCategory = self.fuCaicaiDataSource[self.selectedIndex];
    
    if (self.playedVos.count != 0) {
        for (PlayedVo *playedVo in self.playedVos) {
            if ([playedVo.playedId isEqualToString:playCategory.playedId]) {
                VipVo *vip = KGetVip;
                self.playedVoLabel.text = [NSString stringWithFormat:@"%.2f-%.2f%%",playedVo.jiang,vip.fdPst];
            }
        }
    }
    
    for (LotteryNumberPanModel *numberPanModel in self.tableViewDataSource) {
        if (numberPanModel.selectStrings.length > 0) {
            self.clearSelectBtn.enabled = YES;
            break;
        }else{
            self.clearSelectBtn.enabled = NO;
        }
    }
    self.sureBtn.enabled = chooseCount == 0 ? NO : YES;
    self.bettingCount = chooseCount;
}


#pragma mark - 选择不同的玩法，触发的事件
-(void)chooseBtnClick:(PlayCategoryBtn *)btn{
    if (self.selectedPlayCategorybtn == btn) {
        return;
    }
    self.selectedPlayCategorybtn.selected = NO;
    self.selectedPlayCategorybtn = btn;
    btn.selected = YES;
    [UIView animateWithDuration:0.25 animations:^{
        // 选择完不同的玩法，改变navigationTitle的文字
        NavigationTitleView *titleBtn = (NavigationTitleView *)self.navigationItem.titleView;
        [titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
        self.chooseView.y = -self.chooseView.height;
        [titleBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        
        // 修改玩法说明文案
        [self playDescAttributeString:btn];
        // 根据选择的玩法，确定tableView的数据源
        NSInteger index = [self.chooseView.subviews indexOfObject:btn];
        self.selectedIndex = index;
        self.tableViewDataSource = [self.fuCaicaiDataSource[index] valueForKey:@"numberPanModels"];
        [self.fuCaiNumberPanTable reloadData];
        
        // 遍历数据模型，显示已经选择的数字和注数
        [self setSelectedBettingText];
    } completion:^(BOOL finished) {
        [self.maskBtnView removeFromSuperview];
    }];
}

#pragma mark - 根据玩法文案，生成headerView，并设置带颜色的富文本
-(void)playDescAttributeString:(PlayCategoryBtn *)playBtn{
    
    
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
    playDescriptionLabel.text = playBtn.playCategory.playDesc;
    [playDescriptionLabel sizeToFit];
    self.playDescriptionLabel = playDescriptionLabel;
    [header addSubview:playDescriptionLabel];
    header.x = 0;
    header.y = 0;
    header.width = KScreenWidth;
    header.height = CGRectGetMaxY(playDescriptionLabel.frame);
    
    self.headerView = header;
    
    
    
}

/**
 *  navigationTitle被点击的时候触发，弹出玩法选择的view
 */
-(void)titleViewClick:(NavigationTitleView *)titleView{
    if (self.maskBtn) {
        [self maskBtnClick:self.maskBtn];
    }
    [UIView animateWithDuration:0.2 animations:^{
        if (self.chooseView.y == 0) {
            [self.maskBtnView removeFromSuperview];
            self.chooseView.y = -self.chooseView.height;
            [titleView setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        }else{
            UIButton *maskBtnView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
            maskBtnView.backgroundColor = RGBA(0, 0, 0, 0.1);
            [self.view insertSubview:maskBtnView belowSubview:self.chooseView];
            [maskBtnView addTarget:self action:@selector(maskBtnViewClick:) forControlEvents:UIControlEventTouchUpInside];
            self.maskBtnView = maskBtnView;
            
            self.chooseView.y = 0;
            [titleView setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
        }
    }];
}

-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)maskBtnViewClick:(UIButton *)maskView{
    [UIView animateWithDuration:0.5 animations:^{
        self.chooseView.y = -self.chooseView.height;
        
        NavigationTitleView *titleView = (NavigationTitleView *)self.navigationItem.titleView;
        [titleView setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
    }];
    
}

#pragma mark - 根据选中的玩法，返回选中的注数（不同玩法，生成注数算法不同）
-(NSInteger)getBettingCountFromPlayCategory{
    NSUInteger other = 0;
    
    if (self.tableViewDataSource.count == 1) {
        NSString *selectPlayName = self.selectedPlayCategorybtn.playCategory.playCategoryName;
        LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
        NSInteger selectCount = panModel.selectStrings.length;
        if([selectPlayName containsString:@"3D组三复式"]){
            other = selectCount*(selectCount - 1);
        }else if([selectPlayName containsString:@"3D组六"]){
            other =  selectCount == 3 ? 1 : [self getSXZLBettingCount:selectCount];
        }
    }else{
        
        for (NSInteger i = 0; i < self.tableViewDataSource.count; i++) {
            LotteryNumberPanModel *panModel = self.tableViewDataSource[i];
            if (i == 0) {
                if (panModel.selectStrings.length != 0) {
                    other = panModel.selectStrings.length;
                }
            }else{
                if (other > 0) {
                    other = other * panModel.selectStrings.length;
                }
            }
        }
    }
    return other;
}

#pragma mark - 获得三星组六的投注数
-(NSInteger)getSXZLBettingCount:(NSInteger)n{
    return [self factorialFun:n] / ([self factorialFun:3] * [self factorialFun:(n-3)]);
}

#pragma mark - 阶乘算法
-(NSInteger)factorialFun:(NSInteger)n{
    NSInteger result = n;
    for (NSInteger i = n-1; i > 0; i--) {
        result = result * i;
    }
    return result;
}

#pragma mark - 清空按钮点击
- (IBAction)clearSelectBtnClick {
    for (LotteryNumberPanModel *model in self.tableViewDataSource) {
        model.selectStrings = @"";
    }
    [self.fuCaiNumberPanTable reloadData];
    self.clearSelectBtn.enabled = NO;
    self.sureBtn.enabled = NO;
    self.selectedInfoLabel.text = @"";
    self.selectedNumbersLabel.text = @"";
}

#pragma mark - 点击确定按钮，跳转到投注列表页面
- (IBAction)sureBtnClick {
    VipVo *vip = KGetVip;
    NSLog(@"%f",vip.fdPst);
    if (vip) {
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
            
            NSString *selectedContent = [NSString stringFromArray:self.tableViewDataSource useSeperator:@"|"];
            
            
            OrderCheckView *checkView = [[[NSBundle mainBundle] loadNibNamed:@"OrderCheckView" owner:nil options:nil] firstObject];//[[OrderCheckView alloc] init];
            checkView.frame = [UIScreen mainScreen].bounds;
            PlayCategory *category = self.fuCaicaiDataSource[self.selectedIndex];
            checkView.orderCheckDict = @{
                                         @"playedId":category.playedId,
                                         @"playedName":category.playedName,
                                         @"productId":self.lotteryType.productVo.productId,
                                         @"productName":self.lotteryType.productVo.name,
                                         @"periodName":self.lotteryType.periodVo.name,
                                         @"bettingContent":selectedContent,//self.selectedNumbersLabel.text,
                                         @"bettingCount":[NSString stringWithFormat:@"%zd",self.bettingCount],
                                         @"bettingMoney":amount,
                                         @"multiple":self.multipleField.text,
                                         @"model":model
                                         };
            [[UIApplication sharedApplication].keyWindow addSubview:checkView];
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
