//
//  ShiShiCaiViewController.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/11.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "ShiShiCaiViewController.h"
#import "NavigationTitleView.h"
#import "UIImage+ImageWithColor.h"
#import "NumberPanView.h"
#import "PlayCategoryBtn.h"
#import "MJExtension.h"
#import "PlayCategory.h"
#import "LotteryNumberPanCell.h"
#import "Lottery27NumberPanCell.h"
#import "Lottery18NumberPanCell.h"
#import "LotteryNumberPanModel.h"
#import "BettingListModel.h"
#import "BettingListViewController.h"
#import "ShiShiCaiTopView.h"
#import "OrderCheckView.h"
#import "FaceViewController.h"
#import "SinglePlayView.h"
#import "PlayedVo.h"
#import "LotteryResultDetailViewController.h"

@interface ShiShiCaiViewController ()<LotteryNumberPanCellDelegate,Lottery18NumberPanCellDelegate,Lottery27NumberPanCellDelegate,ShiShiCaiTopViewDelegate,SinglePlayViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) NSArray *tableViewDataSource;
@property (nonatomic,strong) UIView *shiShiCaiTopView;

/**
 各种玩法的赔率信息
 */
@property (nonatomic,strong) NSArray *playedVos;
@property (nonatomic,strong) UIButton *maskBtnView;

@property (nonatomic,strong) UIView *headerView;
//@property (nonatomic,strong) UILabel *playDescriptionLabel;
@property (nonatomic,copy) NSMutableString *playDescriptionStr;
@property (nonatomic,strong) NSMutableArray *playCategoryBtnsContainer;

@property(nonatomic,assign) NSInteger categoryIndex;
@property(nonatomic,assign) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UIButton *clearSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *playedVoLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedNumbersLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *closeDateLabel;   // 显示截至日期的label
@property (weak, nonatomic) IBOutlet UITableView *numberPanTable;
@property (weak, nonatomic) IBOutlet UITextField *multipleField;
@property (weak, nonatomic) IBOutlet UIButton *modelBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) UIButton *maskBtn;
@property (nonatomic,weak) SinglePlayView *singlePlayView;
/**
 *  单式的选注文案，覆盖在selectedNumbersLabel和selectedInfoLabel之上
 */
@property (weak, nonatomic) IBOutlet UILabel *singleViewSelectedContentLabel;

/**
 *  当前选中的注数
 */
@property(nonatomic,assign) NSUInteger bettingCount;
/**
 *  单式选中的注数
 */
@property(nonatomic,assign) NSUInteger singleViewbettingCount;
/**
 *  单式选中的内容
 */
@property(nonatomic,copy) NSString *singleViewbettingContent;
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
@property(nonatomic,assign) NSInteger retainSecond;
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation ShiShiCaiViewController
-(NSArray *)tableViewDataSource{
    if (!_tableViewDataSource) {
        _tableViewDataSource = [NSArray array];
    }
    return _tableViewDataSource;
}
-(NSArray *)playedVos{
    if (!_playedVos) {
        _playedVos = [NSArray array];
    }
    return _playedVos;
}
-(NSMutableArray *)bettingDataSource{
    if (!_bettingDataSource) {
        _bettingDataSource = [NSMutableArray array];
    }
    return _bettingDataSource;
}
-(NSMutableArray *)playCategoryBtnsContainer{
    if (!_playCategoryBtnsContainer) {
        _playCategoryBtnsContainer = [NSMutableArray array];
    }
    return _playCategoryBtnsContainer;
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

#pragma mark - view系列方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f9f8f0"];
    
    
    
    // 初始化一些样式
    [self setupView];
    
    //生成彩种选择view
    [self setupshiShiCaiTopView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCheckDidConform) name:@"KOrderCheckDidConformNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCheckRepeatConform:) name:@"KOrderCheckRepeatConformNotification" object:nil];
    // 获取倒计时剩余的秒数
    [self getRetainSeconds];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
                self.closeDateLabel.attributedText = closeLabelAttributeStr;
            }else{
                NSDate *nowDate = [NSDate getDateFromDateString:[[responseObject valueForKey:@"result"] valueForKey:@"now"]];
                NSDictionary *dict = [responseObject valueForKey:@"result"];
                PeriodVo *period = [PeriodVo mj_objectWithKeyValues:[dict valueForKey:@"period"]];
                self.lotteryType.periodVo = period;
                NSDate *endDate = [NSDate getDateFromDateString:period.timeEnd];
                self.retainSecond = [endDate timeIntervalSinceReferenceDate] - [nowDate timeIntervalSinceReferenceDate];
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
    
    NSInteger currentSecond = --self.retainSecond;
    NSInteger mimute = currentSecond / 60;
    NSInteger second = currentSecond % 60;
    NSString *retainTime = [NSString stringWithFormat:@"%02ld:%02ld",(long)mimute,(long)second];
    NSMutableAttributedString *closeLabelAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期截止：%@",[self.lotteryType.periodVo.name substringFromIndex:self.lotteryType.periodVo.name.length - 3],retainTime]];
    [closeLabelAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(closeLabelAttributeStr.length - retainTime.length, retainTime.length)];
    self.closeDateLabel.attributedText = closeLabelAttributeStr;
    if (self.retainSecond == 0) {
        [timer invalidate];
        timer = nil;
        [self getRetainSeconds];
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
    
    self.numberPanTable.delegate = self;
    self.numberPanTable.dataSource = self;
    
    self.multipleField.delegate = self;
}


#pragma mark - 万千百十个  按钮被点击的事件
-(void)shishiCaiTopBtnClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.layer.borderColor = [UIColor colorWithHexString:@"E03C1F"].CGColor;
    }else{
        btn.layer.borderColor = [UIColor grayColor].CGColor;
    }
    [self setSelectedBettingText];
}

#pragma mark - 圆角分模式的选择事件
- (IBAction)showModelView:(UIButton *)sender {
    if (self.maskBtn) {
        [self maskBtnClick:self.maskBtn];
    }
    NSInteger mul = [self.multipleField.text integerValue];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertC addAction:[UIAlertAction actionWithTitle:@"元" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"元" forState:UIControlStateNormal];
        
        
        
        if (self.singlePlayView) {
            float bettingMoney = self.singleViewbettingCount * 2 * mul * 1;
            self.singleViewSelectedContentLabel.text = self.singleViewbettingCount > 0 ? [NSString stringWithFormat:@"共%ld注 合计：￥%@元",(long)self.singleViewbettingCount,@(bettingMoney)] : @"";
        }else{
            float bettingMoney = self.bettingCount * 2 * mul * 1;
            self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",self.bettingCount,@(bettingMoney)] : @"";
        }
        
        
        
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"角" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"角" forState:UIControlStateNormal];
        
        if (self.singlePlayView) {
            float bettingMoney = self.singleViewbettingCount * 2 * mul * 0.1;
            self.singleViewSelectedContentLabel.text = self.singleViewbettingCount > 0 ? [NSString stringWithFormat:@"共%ld注 合计：￥%@元",(long)self.singleViewbettingCount,@(bettingMoney)] : @"";
        }else{
            float bettingMoney = self.bettingCount * 2 * mul * 0.1;
            self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",self.bettingCount,@(bettingMoney)] : @"";
        }
        
        
        
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"分" forState:UIControlStateNormal];
        
        if (self.singlePlayView) {
            float bettingMoney = self.singleViewbettingCount * 2 * mul * 0.01;
            self.singleViewSelectedContentLabel.text = self.singleViewbettingCount > 0 ? [NSString stringWithFormat:@"共%ld注 合计：￥%@元",(long)self.singleViewbettingCount,@(bettingMoney)] : @"";
        }else{
            float bettingMoney = self.bettingCount * 2 * mul * 0.01;
            self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",self.bettingCount,@(bettingMoney)] : @"";
        }
        
        
        
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
        
        if (self.singlePlayView == nil) {
            [self.view insertSubview:self.maskBtn belowSubview:self.bottomView];
        }
        
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

#pragma mark - 初始化数字选择面板
-(void)setupshiShiCaiTopView{
    ShiShiCaiTopView *shiShiCaiTopView = [[ShiShiCaiTopView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0)];
    shiShiCaiTopView.delegate = self;
    shiShiCaiTopView.backgroundColor = [UIColor whiteColor];
    shiShiCaiTopView.y = -shiShiCaiTopView.height;
    
    [self.view addSubview:shiShiCaiTopView];
    [self shiShiCaiTopViewDidClick:shiShiCaiTopView atCategoryIndex:0 atClickedIndex:0];
    self.shiShiCaiTopView = shiShiCaiTopView;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (((self.categoryIndex == 3 || self.categoryIndex == 4 || self.categoryIndex == 5) && (self.selectedIndex == 3)) || (self.categoryIndex == 9 && self.selectedIndex == 2)){
        Lottery27NumberPanCell *cell = [[Lottery27NumberPanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.number27PanCellDelegate = self;
        cell.isShowSeperateBtns = YES;
        
        cell.numberPanModel = self.tableViewDataSource[indexPath.row];
        return cell;
    }else if ((self.categoryIndex == 1 || self.categoryIndex == 2 || self.categoryIndex == 8) && (self.selectedIndex == 2 || self.selectedIndex == 5)){
        Lottery18NumberPanCell *cell = [[Lottery18NumberPanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.number18PanCellDelegate = self;
        cell.isShowSeperateBtns = YES;
        cell.numberPanModel = self.tableViewDataSource[indexPath.row];
        if (self.selectedIndex == 5) {
            cell.isFromOne = YES;
        }else{
            cell.isFromOne = NO;
        }
        return cell;
    }else{
        static NSString *identification = @"numberPanCell";
        LotteryNumberPanCell *cell = [tableView dequeueReusableCellWithIdentifier:identification];
        if (cell == nil) {
            cell = [[LotteryNumberPanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identification];
            
        }
        
        if (((self.categoryIndex == 3 || self.categoryIndex == 4 || self.categoryIndex == 5) && self.selectedIndex == 9) || ((self.categoryIndex == 1 || self.categoryIndex == 2) && self.selectedIndex == 6)) {
            cell.isShowSeperateBtns = NO;
        }else{
            cell.isShowSeperateBtns = YES;
        }
        cell.customDelegate = self;
        cell.numberPanModel = self.tableViewDataSource[indexPath.row];
        return cell;
    }
    
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
    if (((self.categoryIndex == 3 || self.categoryIndex == 4 || self.categoryIndex == 5) && (self.selectedIndex == 3)) || (self.categoryIndex == 9 && self.selectedIndex == 2)) {
        return (350 / KIPhone6Height) * KScreenHeight;    //Lottery27NumberPanCell的高度
    }else if ((self.categoryIndex == 1 || self.categoryIndex == 2|| self.categoryIndex == 8) && (self.selectedIndex == 2 || self.selectedIndex == 5)){
        return (250 / KIPhone6Height) * KScreenHeight;    //Lottery18NumberPanCell的高度
    }else{
        if (((self.categoryIndex == 3 || self.categoryIndex == 4 || self.categoryIndex == 5) && self.selectedIndex == 9) || ((self.categoryIndex == 1 || self.categoryIndex == 2) && self.selectedIndex == 6)) {
            return (105 / KIPhone6Height) * KScreenHeight;
        }else{
            return (150 / KIPhone6Height) * KScreenHeight;
        }
    }
}

-(void)NumberPanCell:(LotteryNumberPanCell *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn{
    NSInteger clickedRow = [self.numberPanTable indexPathForCell:numberPanView].row;
    LotteryNumberPanModel *panM = self.tableViewDataSource[clickedRow];
    if (numberBtn.selected) {
        numberBtn.selected = NO;
        panM.selectStrings = [NSString deleteObjStr:numberBtn.currentTitle fromSelectedStr:panM.selectStrings];
    }else{
        // 前三、中三、后三、前二、后二组选包胆   只能选择一个数字按钮
        if (((self.categoryIndex == 3 || self.categoryIndex == 4 || self.categoryIndex == 5) && self.selectedIndex == 9) || ((self.categoryIndex == 1 || self.categoryIndex == 2) && self.selectedIndex == 6)) {
            panM.selectStrings = numberBtn.currentTitle;
        }else{
            panM.selectStrings = [NSString appendObjStr:numberBtn.currentTitle toSelectedStr:panM.selectStrings];
        }
    }
    
    
    NSIndexPath *path = [self.numberPanTable indexPathForCell:numberPanView];
    [self.numberPanTable reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    
    // 遍历数据模型，显示已经选择的数字和注数
    [self setSelectedBettingText];
    
}

-(void)NumberPanCell:(LotteryNumberPanCell *)numberPanView didSelectedSeperateBtn:(UIButton *)seperateBtn{
    NSInteger clickedRow = [self.numberPanTable indexPathForCell:numberPanView].row;
    LotteryNumberPanModel *panM = self.tableViewDataSource[clickedRow];
    
    if ([numberPanView isKindOfClass:[Lottery27NumberPanCell class]]) {
        if ([seperateBtn.currentTitle isEqualToString:@"大"]) {
            panM.selectStrings = @"15 16 17 18 19 20 21 22 23 24 25 26 27";
        }else if([seperateBtn.currentTitle isEqualToString:@"小"]) {
            panM.selectStrings = @"0 1 2 3 4 5 6 7 8 9 10 11 12 13 14";
        }else if([seperateBtn.currentTitle isEqualToString:@"双"]) {
            panM.selectStrings = @"0 2 4 6 8 10 12 14 16 18 20 22 24 26";
        }else if([seperateBtn.currentTitle isEqualToString:@"单"]) {
            panM.selectStrings = @"1 3 5 7 9 11 13 15 17 19 21 23 25 27";
        }else if([seperateBtn.currentTitle isEqualToString:@"清"]) {
            panM.selectStrings = @"";
        }else if([seperateBtn.currentTitle isEqualToString:@"全"]) {
            panM.selectStrings = @"0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27";
        }
    } else if ([numberPanView isKindOfClass:[Lottery18NumberPanCell class]]) {
        if ([seperateBtn.currentTitle isEqualToString:@"大"]) {
            
            if (self.selectedIndex == 2) {
                panM.selectStrings = @"10 11 12 13 14 15 16 17 18";
            }else{
                panM.selectStrings = @"9 10 11 12 13 14 15 16 17";
            }
        }else if([seperateBtn.currentTitle isEqualToString:@"小"]) {
            if (self.selectedIndex == 2) {
                panM.selectStrings = @"0 1 2 3 4 5 6 7 8 9";
            }else{
                panM.selectStrings = @"1 2 3 4 5 6 7 8";
            }
        }else if([seperateBtn.currentTitle isEqualToString:@"双"]) {
            
            if (self.selectedIndex == 2) {
                panM.selectStrings = @"0 2 4 6 8 10 12 14 16 18";
            }else{
                panM.selectStrings = @"2 4 6 8 10 12 14 16";
            }
        }else if([seperateBtn.currentTitle isEqualToString:@"单"]) {
            panM.selectStrings = @"1 3 5 7 9 11 13 15 17";
        }else if([seperateBtn.currentTitle isEqualToString:@"清"]) {
            panM.selectStrings = @"";
        }else if([seperateBtn.currentTitle isEqualToString:@"全"]) {
            if (self.selectedIndex == 2) {
                panM.selectStrings = @"0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18";
            }else{
                panM.selectStrings = @"1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17";
            }
        }
    }else{
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
    }
    NSIndexPath *path = [self.numberPanTable indexPathForCell:numberPanView];
    [self.numberPanTable reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    
    // 遍历数据模型，显示已经选择的数字和注数
    [self setSelectedBettingText];
}

#pragma mark - 单式玩法 点击键盘的完成按钮
-(void)singlePlayViewClickDown:(NSInteger)bettingCount bettingContent:(NSString *)bettingContent{
    [self maskBtnClick:self.maskBtn];
    self.singleViewbettingCount = bettingCount;
    self.singleViewbettingContent = bettingContent;
    if (self.singleViewbettingCount > 0) {
        self.clearSelectBtn.enabled = YES;
        self.sureBtn.enabled = YES;
        self.selectedNumbersLabel.text = @"";
        self.selectedInfoLabel.text = @"";
    }else{
        self.clearSelectBtn.enabled = NO;
        self.sureBtn.enabled = NO;
    }
    NSInteger mul = [self.multipleField.text integerValue];
    NSString *model = self.modelBtn.currentTitle;
    float bettingMoney = 1;
    if ([model isEqualToString:@"角"]) {
        bettingMoney = bettingCount * 2 * mul * 0.1;
    }else if ([model isEqualToString:@"分"]){
        bettingMoney = bettingCount * 2 * mul * 0.01;
    }else{
        bettingMoney = bettingCount * 2 * mul;
    }
    self.singleViewSelectedContentLabel.text = bettingCount > 0 ? [NSString stringWithFormat:@"共%ld注 合计：￥%@元",(long)bettingCount,@(bettingMoney)] : @"";
}

#pragma mark - 设置底部selectedNumbersLabel和selectedInfoLabel的文案
-(void)setSelectedBettingText{
    NSString *selectedAllNumbers = [NSString string];
    NSInteger panCount = self.tableViewDataSource.count;
    // 如果只有一个数字面板，显示的选号用空格分隔，直接取panModel里的selectStrings即可
    if (panCount == 1) {
        LotteryNumberPanModel *numberPanModel = [self.tableViewDataSource firstObject];
        selectedAllNumbers = numberPanModel.selectStrings;
    }else{
        for (NSInteger i = 0; i < panCount; i++) {
            LotteryNumberPanModel *numberPanModel = self.tableViewDataSource[i];
            //有选中的数字
            if (numberPanModel.selectStrings.length != 0) {
                NSString *currentPanSelectedStr = [numberPanModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""];
                selectedAllNumbers = [NSString appendObjStr:currentPanSelectedStr toSelectedStr:selectedAllNumbers];
            }
        }
    }
    self.selectedNumbersLabel.text = selectedAllNumbers;
    // 非任二、任三、任四的玩法
    NSInteger chooseCount = 0;
    if (self.categoryIndex < 8) {
        chooseCount = [self getBettingCountFromPlayCategory];
    }else{
        chooseCount = [self getBettingCountWhereCategoryGrateSenven];
    }
    
    
    
    
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
    self.selectedInfoLabel.text = selectedAllNumbers.length > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",chooseCount,@(bettingMoney)] : @"";
    
    PlayCategory *playCategory = self.shishicaiDataSource[self.categoryIndex][self.selectedIndex];
    
    if (self.playedVos.count != 0) {
        for (PlayedVo *playedVo in self.playedVos) {
            if ([playedVo.playedId isEqualToString:playCategory.playedId]) {
                VipVo *vip = KGetVip;
                self.playedVoLabel.text = [NSString stringWithFormat:@"%.2f-%.2f%%",playedVo.jiang,vip.fdPst];
            }
        }
    }
    
    self.clearSelectBtn.enabled = selectedAllNumbers.length == 0 ? NO : YES;
    self.sureBtn.enabled = chooseCount == 0 ? NO : YES;
    self.bettingCount = chooseCount;
    self.numbersForBettingList = selectedAllNumbers;
}

#pragma mark - 各个彩种的玩法选择 categoryIndex：彩种，clickedIndex：彩种里的玩法
-(void)shiShiCaiTopViewDidClick:(ShiShiCaiTopView *)topView atCategoryIndex:(NSInteger)categoryIndex atClickedIndex:(NSInteger)clickedIndex{
    
    [UIView animateWithDuration:0.25 animations:^{
        NavigationTitleView *titleBtn = (NavigationTitleView *)self.navigationItem.titleView;
        PlayCategory *category = self.shishicaiDataSource[categoryIndex][clickedIndex];
        self.categoryIndex = categoryIndex;
        self.selectedIndex = clickedIndex;
        self.shiShiCaiTopView.y = -KScreenHeight;
        
        [titleBtn setTitle:category.playCategoryName forState:UIControlStateNormal];
        [titleBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        // 如果是单式玩法，就初始化单式的view覆盖掉tableview
        if (
            ((categoryIndex == 1 || categoryIndex == 2) && (clickedIndex == 1 || clickedIndex == 5)) ||
            ((categoryIndex == 3 || categoryIndex == 4 || categoryIndex == 5) && (clickedIndex == 1 || clickedIndex == 6 || clickedIndex == 8)) ||
            ((categoryIndex == 6 || categoryIndex == 7 || categoryIndex == 10) && (clickedIndex == 1)) ||
            (categoryIndex == 8 && (clickedIndex == 1 || clickedIndex == 4)) ||
            (categoryIndex == 9 && (clickedIndex == 1 || clickedIndex == 4 || clickedIndex == 6))) {
            if (!self.singlePlayView) {
                SinglePlayView *singView = [[[NSBundle mainBundle] loadNibNamed:@"SinglePlayView" owner:self options:nil] firstObject];
                singView.category = category;
                singView.delegate = self;
                singView.frame = self.numberPanTable.frame;
                [self.view insertSubview:singView aboveSubview:self.numberPanTable];
                self.singlePlayView = singView;
                self.singleViewSelectedContentLabel.hidden = NO;
            }else{
                self.singlePlayView.category = category;
                [self.singlePlayView clearBettingContent];
            }
            
            if (categoryIndex == 1 || categoryIndex == 2) {
                self.singlePlayView.singlePlayViewType = 2;
            }else if (categoryIndex == 3 || categoryIndex == 4 || categoryIndex == 5){
                if (clickedIndex == 1) {
                    //单式
                    self.singlePlayView.singlePlayViewType = 3;
                }else if (clickedIndex == 6){
                    // 组三单式
                    self.singlePlayView.singlePlayViewType = 4;
                }else if (clickedIndex == 8){
                    // 组六单式
                    self.singlePlayView.singlePlayViewType = 5;
                }
                
            }else if(categoryIndex == 6){
                self.singlePlayView.singlePlayViewType = 6;
            }else if(categoryIndex == 7){
                self.singlePlayView.singlePlayViewType = 7;
            }else if(categoryIndex == 8){
                if (clickedIndex == 1) {
                    self.singlePlayView.singlePlayViewType = 8;
                }else{
                    self.singlePlayView.singlePlayViewType = 9;
                }
            }else if(categoryIndex == 9){
                if (clickedIndex == 1) {
                    self.singlePlayView.singlePlayViewType = 10;
                }else if (clickedIndex == 4){
                    self.singlePlayView.singlePlayViewType = 11;
                }else{
                    self.singlePlayView.singlePlayViewType = 12;
                }
                
            }else{
                self.singlePlayView.singlePlayViewType = 13;
            }
            
            
            self.selectedInfoLabel.text = @"";
            self.selectedNumbersLabel.text = @"";
            self.singleViewSelectedContentLabel.text = @"";
            self.clearSelectBtn.enabled = NO;
            self.sureBtn.enabled = NO;
        }else{
            if (self.singlePlayView) {
                [self.singlePlayView removeFromSuperview];
                self.singlePlayView = nil;
                self.singleViewSelectedContentLabel.hidden = YES;
            }
            [self playDescAttributeString:category.playDesc];
            self.tableViewDataSource = category.numberPanModels;
            [self.numberPanTable reloadData];
            
            [self setSelectedBettingText];
        }
        
    } completion:^(BOOL finished) {
        [self.maskBtnView removeFromSuperview];
    }];
}

#pragma mark - 根据玩法文案，生成headerView
-(void)playDescAttributeString:(NSString *)playDesc{
    
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
    playDescriptionLabel.text =playDesc;
    [playDescriptionLabel sizeToFit];
    [header addSubview:playDescriptionLabel];
    
    if (self.categoryIndex > 7 && self.selectedIndex != 0) {
        // 绘制任二、任三、任四的五个按钮
        NSArray *btnTitleArr = @[@"万位",@"千位",@"百位",@"十位",@"个位"];
        NSInteger btnsCount = btnTitleArr.count;
        //    CGFloat margin = 8;
        CGFloat btnW = (playDescriptionLabel.width - playDescLabel.x * (btnsCount - 1)) / btnsCount;
        for (NSInteger i = 0; i < btnTitleArr.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake((btnW + playDescLabel.x) * i + playDescLabel.x, CGRectGetMaxY(playDescriptionLabel.frame) + playDescLabel.x, btnW, 30);
            [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"E03C1F"]] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(shishiCaiTopBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            btn.layer.borderWidth = 1;
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            switch (self.categoryIndex) {
                case 8:{
                    if (i > 2) {
                        btn.selected = YES;
                        btn.layer.borderColor = [UIColor colorWithHexString:@"E03C1F"].CGColor;
                        
                    }else{
                        btn.layer.borderColor = [UIColor grayColor].CGColor;
                    }
                }
                    break;
                case 9:{
                    if (i > 1) {
                        btn.selected = YES;
                        btn.layer.borderColor = [UIColor colorWithHexString:@"E03C1F"].CGColor;
                    }else{
                        btn.layer.borderColor = [UIColor grayColor].CGColor;
                    }
                }
                    break;
                    
                default:
                    if (i > 0) {
                        btn.selected = YES;
                        btn.layer.borderColor = [UIColor colorWithHexString:@"E03C1F"].CGColor;
                    }else{
                        btn.layer.borderColor = [UIColor grayColor].CGColor;
                    }
                    break;
            }
            [header addSubview:btn];
            
            if (i == btnTitleArr.count - 1) {
                header.height = CGRectGetMaxY(btn.frame) + playDescLabel.x;
            }
        }
        
        
    }else{
        header.height = CGRectGetMaxY(playDescriptionLabel.frame);
    }
    
    
    header.x = 0;
    header.y = 0;
    header.width = KScreenWidth;
    
    
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
        if (self.shiShiCaiTopView.y == 0) {
            [self.maskBtnView removeFromSuperview];
            self.shiShiCaiTopView.y = -self.shiShiCaiTopView.height;
            [titleView setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        }else{
            UIButton *maskBtnView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
            maskBtnView.backgroundColor = RGBA(0, 0, 0, 0.1);
            [self.view insertSubview:maskBtnView belowSubview:self.shiShiCaiTopView];
            [maskBtnView addTarget:self action:@selector(maskBtnViewClick:) forControlEvents:UIControlEventTouchUpInside];
            self.maskBtnView = maskBtnView;
            
            self.shiShiCaiTopView.y = 0;
            [titleView setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
        }
    }];
}

-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)maskBtnViewClick:(UIButton *)maskView{
    [UIView animateWithDuration:0.5 animations:^{
        self.shiShiCaiTopView.y = -self.shiShiCaiTopView.height;
        
        NavigationTitleView *titleView = (NavigationTitleView *)self.navigationItem.titleView;
        [titleView setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
    }];

}

#pragma mark - 根据选中的玩法，返回选中的注数（不同玩法，生成注数算法不同）
-(NSInteger)getBettingCountFromPlayCategory{
    NSInteger other = 0;
    for (NSInteger i = 0; i < self.tableViewDataSource.count; i++) {
        LotteryNumberPanModel *panModel = self.tableViewDataSource[i];
        NSString *currentSelectedStr = [panModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSInteger currentSelectedLength = currentSelectedStr.length;
        switch (self.categoryIndex) {
            case 0:     //定位
                other += currentSelectedLength;
                break;
            case 7:{    //五星玩法
                switch (self.selectedIndex) {
                    case 0:{    //五星直选
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            if (i == 0) {
                                other = currentSelectedLength;
                            }else{
                                other *= currentSelectedLength;
                            }
                        }
                    }
                        break;
                    case 2:{    //五星组合
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            if (i == 0) {
                                other = currentSelectedLength;
                            }else if(i == self.tableViewDataSource.count - 1){
                                other *= 5;
                            }else{
                                other *= currentSelectedLength;
                            }
                        }
                    }
                        break;
                    case 3:{    //组选120
                        if (currentSelectedLength < 5) {
                            other = 0;
                        }else{
                            //n*(n-1)*(n-2)*(n-3)*(n-4)/5!
                            other = currentSelectedLength*(currentSelectedLength-1)*(currentSelectedLength-2)*(currentSelectedLength-3)*(currentSelectedLength-4)/[self factorialFun:5];
                        }
                    }
                        break;
                    case 4:{    //组选60
                        other = [self getZuXuan];
                    }
                        break;
                    case 5:{    //组选30
                        other = [self getZuXuan30];
                    }
                        break;
                    case 6:{    //组选20
                        other = [self getZuXuan20];
                    }
                        break;
                    case 7:{    //组选10
                        if (i == 0) {
                            other = currentSelectedLength == 0 ? 0 : currentSelectedLength;
                        }else{
                            other = [self getZuXuan10];
                        }
                        break;
                        
                    }
                        break;
                    case 8:{    //组选5
                        other = [self getZuXuan10];
                        
                    }
                        break;
                    case 9: case 10: case 11: case 12:{    //一帆风顺
                        other = currentSelectedLength;
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 6:{    //四星玩法
                switch (self.selectedIndex) {
                    case 0:{    // 四星直选
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            if (i == 0) {
                                other = currentSelectedLength;
                            }else{
                                other *= currentSelectedLength;
                            }
                        }
                    }
                        break;
                    case 2:{    //四星组合
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            if (i == 0) {
                                other = currentSelectedLength;
                            }else if(i == self.tableViewDataSource.count - 1){
                                other *= currentSelectedLength;
                                other *= 4;
                            }else{
                                other *= currentSelectedLength;
                            }
                        }
                    }
                        break;
                    case 3:{    //组选24
                        
                        if (currentSelectedLength < 4) {
                            return 0;
                        }else{
                            other = currentSelectedLength*(currentSelectedLength - 1)*(currentSelectedLength - 2)*(currentSelectedLength - 3)/[self factorialFun:4];
                            
                        }
                    }
                        break;
                    case 4:{    //组选12
                        other = [self getZuXuan20];
                    }
                        break;
                    case 5:{    //组选6
                        if (currentSelectedLength >= 2) {
                            other = currentSelectedLength * (currentSelectedLength - 1) * 0.5;
                        }else{
                            other = 0;
                        }
                    }
                        break;
                    case 6:{    //组选4
                        other = [self getZuXuan10];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 3: case 4: case 5:{    //前三、中三、后三玩法
                switch (self.selectedIndex) {
                    case 0:{    //前三直选
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            if (i == 0) {
                                other = currentSelectedLength;
                            }else{
                                other *= currentSelectedLength;
                            }
                        }
                    }
                        break;
                    case 2:{    //前三组合
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            if (i == 0) {
                                other = currentSelectedLength;
                            }else if(i == self.tableViewDataSource.count - 1){
                                other *= currentSelectedLength;
                                other *= 3;
                            }else{
                                other *= currentSelectedLength;
                            }
                        }
                    }
                        break;
                    case 3:{    //直选和值
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            NSArray *selectedArr = [panModel.selectStrings  componentsSeparatedByString:@" "];
                            
                            for (NSString *selectedEleStr in selectedArr) {
                                switch ([selectedEleStr integerValue]) {
                                    case 0:
                                        other += 1;
                                        break;
                                    case 1:
                                        other += 3;
                                        break;
                                    case 2:
                                        other += 6;
                                        break;
                                    case 3:
                                        other += 10;
                                        break;
                                    case 4:
                                        other += 15;
                                        break;
                                    case 5:
                                        other += 21;
                                        break;
                                    case 6:
                                        other += 28;
                                        break;
                                    case 7:
                                        other += 36;
                                        break;
                                    case 8:
                                        other += 45;
                                        break;
                                    case 9:
                                        other += 55;
                                        break;
                                    case 10:
                                        other += 63;
                                        break;
                                    case 11:
                                        other += 69;
                                        break;
                                    case 12:
                                        other += 73;
                                        break;
                                    case 13:
                                        other += 75;
                                        break;
                                    case 14:
                                        other += 75;
                                        break;
                                    case 15:
                                        other += 73;
                                        break;
                                    case 16:
                                        other += 69;
                                        break;
                                    case 17:
                                        other += 63;
                                        break;
                                    case 18:
                                        other += 55;
                                        break;
                                    case 19:
                                        other += 45;
                                        break;
                                    case 20:
                                        other += 36;
                                        break;
                                    case 21:
                                        other += 28;
                                        break;
                                    case 22:
                                        other += 21;
                                        break;
                                    case 23:
                                        other += 15;
                                        break;
                                    case 24:
                                        other += 10;
                                        break;
                                    case 25:
                                        other += 6;
                                        break;
                                    case 26:
                                        other += 3;
                                        break;
                                    case 27:
                                        other += 1;
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }
                    }
                        break;
                    case 4:{    //直选跨度
                        //(n+1)*(n+2)/2
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            NSArray *selectedArr = [panModel.selectStrings  componentsSeparatedByString:@" "];
                            
                            for (NSString *selectedEleStr in selectedArr) {
                                switch ([selectedEleStr integerValue]) {
                                    case 0:
                                        other += 10;
                                        break;
                                    case 1:
                                        other += 54;
                                        break;
                                    case 2:
                                        other += 96;
                                        break;
                                    case 3:
                                        other += 126;
                                        break;
                                    case 4:
                                        other += 144;
                                        break;
                                    case 5:
                                        other += 150;
                                        break;
                                    case 6:
                                        other += 144;
                                        break;
                                    case 7:
                                        other += 126;
                                        break;
                                    case 8:
                                        other += 96;
                                        break;
                                    case 9:
                                        other += 54;
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }
                    }
                        break;
                    case 5:{    //组三
                        //（n>=2），n*(n-1)
                        if (currentSelectedLength < 2) {
                            return 0;
                        }else{
                            other = currentSelectedLength*(currentSelectedLength-1);
                        }
                    }
                        break;
                    case 7:{    //组六
                        //（n>=2），n*(n-1)*(n-2)/3!
                        if (currentSelectedLength < 3) {
                            return 0;
                        }else{
                            other = currentSelectedLength*(currentSelectedLength-1)*(currentSelectedLength-2)/[self factorialFun:3];
                        }
                    }
                        break;
                    case 6:{    //组选和值
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            NSArray *selectedArr = [panModel.selectStrings  componentsSeparatedByString:@" "];
                            
                            for (NSString *selectedEleStr in selectedArr) {
                                switch ([selectedEleStr integerValue]) {
                                    case 1:
                                        other += 1;
                                        break;
                                    case 2:
                                        other += 2;
                                        break;
                                    case 3:
                                        other += 2;
                                        break;
                                    case 4:
                                        other += 4;
                                        break;
                                    case 5:
                                        other += 5;
                                        break;
                                    case 6:
                                        other += 6;
                                        break;
                                    case 7:
                                        other += 8;
                                        break;
                                    case 8:
                                        other += 10;
                                        break;
                                    case 9:
                                        other += 11;
                                        break;
                                    case 10:
                                        other += 13;
                                        break;
                                    case 11:
                                        other += 14;
                                        break;
                                    case 12:
                                        other += 14;
                                        break;
                                    case 13:
                                        other += 15;
                                        break;
                                    case 14:
                                        other += 15;
                                        break;
                                    case 15:
                                        other += 14;
                                        break;
                                    case 16:
                                        other += 14;
                                        break;
                                    case 17:
                                        other += 13;
                                        break;
                                    case 18:
                                        other += 11;
                                        break;
                                    case 19:
                                        other += 10;
                                        break;
                                    case 20:
                                        other += 8;
                                        break;
                                    case 21:
                                        other += 6;
                                        break;
                                    case 22:
                                        other += 5;
                                        break;
                                    case 23:
                                        other += 4;
                                        break;
                                    case 24:
                                        other += 2;
                                        break;
                                    case 25:
                                        other += 2;
                                        break;
                                    case 26:
                                        other += 1;
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }
                    }
                        break;
                    case 9:{    // 组选包胆
                        other = currentSelectedLength == 0 ? 0 : 54;
                    }
                        break;
                    case 10:{    // 和值尾数
                        other = currentSelectedLength;
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 1: case 2:{    //前二、后二玩法
                switch (self.selectedIndex) {
                    case 0:{    //直选
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            if (i == 0) {
                                other = currentSelectedLength;
                            }else{
                                other *= currentSelectedLength;
                            }
                        }
                    }
                        break;
                    case 2:{    //直选和值
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            NSArray *selectedArr = [panModel.selectStrings  componentsSeparatedByString:@" "];
                            
                            for (NSString *selectedEleStr in selectedArr) {
                                NSInteger selectNumber = [selectedEleStr integerValue];
                                if (selectNumber < 10) {
                                    other += (selectNumber + 1);
                                }else{
                                    other += (19 - selectNumber);
                                }
                            }
                        }
                    }
                        break;
                    case 3:{    //直选跨度
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            NSArray *selectedArr = [panModel.selectStrings  componentsSeparatedByString:@" "];
                            
                            for (NSString *selectedEleStr in selectedArr) {
                                NSInteger selectNumber = [selectedEleStr integerValue];
                                if (selectNumber == 0) {
                                    other += 10;
                                }else{
                                    other += ((10 - selectNumber)*2);
                                }
                            }
                        }
                    }
                        break;
                    case 4:{    //组选
                        //n*(n-1)/2!
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            if (currentSelectedLength < 2) {
                                return 0;
                            }else{
                                other = currentSelectedLength*(currentSelectedLength-1)/2;
                            }
                        }
                    }
                        break;
                    case 6:{    //组选包胆
                        if (currentSelectedLength == 0) {
                            return 0;
                        }else{
                            other = 9;
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
        
    }
    return other;
}

#pragma mark - 获得任二、任三、任四的注数
-(NSInteger)getBettingCountWhereCategoryGrateSenven{
    NSInteger other = 0;
    
    switch (self.categoryIndex) {
        case 8:{
            switch (self.selectedIndex) {
                case 0:{
                    NSInteger zeroCount = 0;
                    NSMutableArray *selectCountArr = [NSMutableArray arrayWithCapacity:self.tableViewDataSource.count];
                    for (NSInteger i = 0; i < self.tableViewDataSource.count; i++) {
                        LotteryNumberPanModel *panModel = self.tableViewDataSource[i];
                        NSString *currentSelectedStr = [panModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSInteger currentSelectedLength = currentSelectedStr.length;
                        
                        if (currentSelectedLength == 0) {
                            zeroCount += 1;
                        }
                        [selectCountArr addObject:@(currentSelectedLength)];
                    }
                    if (zeroCount <= 3) {
                        NSInteger wanC = [selectCountArr[0] integerValue];
                        NSInteger qianC = [selectCountArr[1] integerValue];
                        NSInteger baiC = [selectCountArr[2] integerValue];
                        NSInteger shiC = [selectCountArr[3] integerValue];
                        NSInteger geC = [selectCountArr[4] integerValue];
                        other = wanC * qianC + wanC * baiC + wanC * shiC + wanC * geC + qianC *baiC + qianC * shiC + qianC * geC + baiC * shiC + baiC * geC + shiC * geC;
                    }
                }
                    break;
                case 2:{
                    NSInteger selectedBtnCount = 0;
                    NSMutableString *selectBtnStr = [NSMutableString string];
                    for (UIButton *btn in self.headerView.subviews) {
                        if ([btn isKindOfClass:[UIButton class]]) {
                            if (btn.selected) {
                                selectedBtnCount += 1;
                                [selectBtnStr appendString:[btn.currentTitle substringToIndex:1]];
                            }
                        }
                    }
                    if (selectedBtnCount >= 2) {
                        LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
                        NSString *currentSelectedStr = panModel.selectStrings;
                        NSArray *selectNumbersArr = [currentSelectedStr componentsSeparatedByString:@" "];
                        NSInteger resultCount = 0;
                        for (NSInteger i = 0; i < selectNumbersArr.count; i++) {
                            NSInteger numInt = [selectNumbersArr[i] integerValue];
                            if (numInt < 10) {
                                resultCount += selectedBtnCount*(selectedBtnCount-1)*(numInt+1)/2;
                            }else{
                                // m*(m-1)*(19-n)/2
                                resultCount += selectedBtnCount*(selectedBtnCount-1)*(19-numInt)/2;
                            }
                        }
                        self.selectedNumbersLabel.text = [NSString stringWithFormat:@"%@ %@",selectBtnStr,[currentSelectedStr stringByReplacingOccurrencesOfString:@" " withString:@","]];
                        other = resultCount;
                    }else{
                        self.selectedNumbersLabel.text = @"";
                        return other;
                    }
                    
                    
                    
                }
                    break;
                case 3:{
                    //选了n个号码（n>=2），一共选了m个位置（m>=2且m<=5），则一共会形成m*n*(m-1)*(n-1)/2!*2!
                    NSInteger selectedBtnCount = 0;
                    NSMutableString *selectBtnStr = [NSMutableString string];
                    for (UIButton *btn in self.headerView.subviews) {
                        if ([btn isKindOfClass:[UIButton class]]) {
                            if (btn.selected) {
                                selectedBtnCount += 1;
                                [selectBtnStr appendString:[btn.currentTitle substringToIndex:1]];
                            }
                        }
                    }
                    if (selectedBtnCount >= 2) {
                        LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
                        NSString *currentSelectedStr = panModel.selectStrings;
                        NSInteger selectNumberCount = [[currentSelectedStr componentsSeparatedByString:@" "] count];
                        if (selectNumberCount >= 2) {
                            other = (selectedBtnCount *selectNumberCount *(selectedBtnCount - 1) * (selectNumberCount - 1)) / (2 * 2);
                            if (other > 0) {
                                self.selectedNumbersLabel.text = [NSString stringWithFormat:@"%@ %@",selectBtnStr,[currentSelectedStr stringByReplacingOccurrencesOfString:@" " withString:@""]];
                            }else{
                                self.selectedNumbersLabel.text = @"";
                            }
                            
                        }
                        
                    }else{
                        self.selectedNumbersLabel.text = @"";
                        return other;
                    }
                }
                    break;
                case 5:{
                    NSInteger selectedBtnCount = 0;
                    NSMutableString *selectBtnStr = [NSMutableString string];
                    for (UIButton *btn in self.headerView.subviews) {
                        if ([btn isKindOfClass:[UIButton class]]) {
                            if (btn.selected) {
                                selectedBtnCount += 1;
                                [selectBtnStr appendString:[btn.currentTitle substringToIndex:1]];
                            }
                        }
                    }
                    if (selectedBtnCount >= 2) {
                        LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
                        NSString *currentSelectedStr = panModel.selectStrings;
                        NSArray *selectNumbersArr = [currentSelectedStr componentsSeparatedByString:@" "];
                        NSInteger resultCount = 0;
                        for (NSInteger i = 0; i < selectNumbersArr.count; i++) {
                            NSInteger numInt = [selectNumbersArr[i] integerValue];
                            if (numInt < 10) {
                                resultCount += ceil(numInt / 2.0) * selectedBtnCount * (selectedBtnCount - 1) / 2;
                            }else{
                                resultCount += ceil(((18-numInt) / 2.0)) * selectedBtnCount * (selectedBtnCount - 1) / 2;
                            }
                        }
                        
                        other = resultCount;
                        if (other > 0) {
                            self.selectedNumbersLabel.text = [NSString stringWithFormat:@"%@ %@",selectBtnStr,[currentSelectedStr stringByReplacingOccurrencesOfString:@" " withString:@","]];
                        }else{
                            self.selectedNumbersLabel.text = @"";
                        }
                    }else{
                        self.selectedNumbersLabel.text = @"";
                        return other;
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 9:{
            switch (self.selectedIndex) {
                case 0:{
                    NSInteger zeroCount = 0;
                    NSMutableArray *selectCountArr = [NSMutableArray arrayWithCapacity:self.tableViewDataSource.count];
                    for (NSInteger i = 0; i < self.tableViewDataSource.count; i++) {
                        LotteryNumberPanModel *panModel = self.tableViewDataSource[i];
                        NSString *currentSelectedStr = [panModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSInteger currentSelectedLength = currentSelectedStr.length;
                        
                        if (currentSelectedLength == 0) {
                            zeroCount += 1;
                        }
                        [selectCountArr addObject:@(currentSelectedLength)];
                    }
                    if (zeroCount <= 2) {
                        NSInteger wanC = [selectCountArr[0] integerValue];
                        NSInteger qianC = [selectCountArr[1] integerValue];
                        NSInteger baiC = [selectCountArr[2] integerValue];
                        NSInteger shiC = [selectCountArr[3] integerValue];
                        NSInteger geC = [selectCountArr[4] integerValue];
                        other = wanC*qianC*baiC + wanC*qianC*shiC + wanC*qianC*geC + wanC*baiC*shiC + wanC*baiC*geC + wanC*shiC*geC + qianC*baiC*shiC + qianC*baiC*geC + qianC*shiC*geC + baiC*shiC*geC;
                    }
                }
                    
                    break;
                case 2:{    // 直选和值
                    NSInteger selectedBtnCount = 0;
                    NSMutableString *selectBtnStr = [NSMutableString string];
                    for (UIButton *btn in self.headerView.subviews) {
                        if ([btn isKindOfClass:[UIButton class]]) {
                            if (btn.selected) {
                                selectedBtnCount += 1;
                                [selectBtnStr appendString:[btn.currentTitle substringToIndex:1]];
                            }
                        }
                    }
                    if (selectedBtnCount >= 3) {
                        LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
                        NSString *currentSelectedStr = panModel.selectStrings;
                        NSArray *selectNumbersArr = [currentSelectedStr componentsSeparatedByString:@" "];
                        NSInteger resultCount = 0;
                        for (NSInteger i = 0; i < selectNumbersArr.count; i++) {
                            NSInteger numInt = [selectNumbersArr[i] integerValue];
                            if (numInt < 10) {
                                resultCount += selectedBtnCount*(selectedBtnCount-1)*(selectedBtnCount-2)*(numInt+1)*(numInt+2)/(6*2);
                            }else if(numInt < 18){
                                NSInteger factor = selectedBtnCount*(selectedBtnCount-1)*(selectedBtnCount-2)/6;
                                switch (numInt) {
                                    case 10:
                                        resultCount += 63 * factor;
                                        break;
                                    case 11:
                                        resultCount += 69 * factor;
                                        break;
                                    case 12:
                                        resultCount += 73 * factor;
                                        break;
                                    case 13:
                                        resultCount += 75 * factor;
                                        break;
                                    case 14:
                                        resultCount += 75 * factor;
                                        break;
                                    case 15:
                                        resultCount += 73 * factor;
                                        break;
                                    case 16:
                                        resultCount += 69 * factor;
                                        break;
                                    case 17:
                                        resultCount += 63 * factor;
                                        break;
                                }
                            }else{
                                resultCount += selectedBtnCount*(selectedBtnCount-1)*(selectedBtnCount-2)*(28-numInt)*(29-numInt)/(6*2);
                            }
                        }
                        if (resultCount > 0) {
                            self.selectedNumbersLabel.text = [NSString stringWithFormat:@"%@ %@",selectBtnStr,[currentSelectedStr stringByReplacingOccurrencesOfString:@" " withString:@","]];
                        }else{
                            self.selectedNumbersLabel.text = @"";
                        }
                        
                        other = resultCount;
                    }else{
                        self.selectedNumbersLabel.text = @"";
                        return other;
                    }

                }
                    break;
                case 3:{
                    //选了n个号码（n>=2），一共选了m个位置（m>=3且m<=5），则一共会形成m*(m-1)*(m-2)*n*(n-1)/3!注
                    NSInteger selectedBtnCount = 0;
                    NSMutableString *selectBtnStr = [NSMutableString string];
                    for (UIButton *btn in self.headerView.subviews) {
                        if ([btn isKindOfClass:[UIButton class]]) {
                            if (btn.selected) {
                                selectedBtnCount += 1;
                                [selectBtnStr appendString:[btn.currentTitle substringToIndex:1]];
                            }
                        }
                    }
                    if (selectedBtnCount >= 3) {
                        LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
                        NSString *currentSelectedStr = panModel.selectStrings;
                        NSInteger selectNumberCount = [[currentSelectedStr componentsSeparatedByString:@" "] count];
                        if (selectNumberCount >= 2) {
                            other = selectedBtnCount*(selectedBtnCount-1)*(selectedBtnCount-2)*selectNumberCount*(selectNumberCount-1)/(3*2);
                            if (other > 0) {
                                self.selectedNumbersLabel.text = [NSString stringWithFormat:@"%@ %@",selectBtnStr,[currentSelectedStr stringByReplacingOccurrencesOfString:@" " withString:@""]];
                            }else{
                                self.selectedNumbersLabel.text = @"";
                            }
                            
                        }
                        
                    }else{
                        self.selectedNumbersLabel.text = @"";
                        return other;
                    }
                }
                    break;
                case 5:{
                    //选了n个号码（n>=2），一共选了m个位置（m>=3且m<=5），则一共会形成m*(m-1)*(m-2)*n*(n-1)/3!注
                    NSInteger selectedBtnCount = 0;
                    NSMutableString *selectBtnStr = [NSMutableString string];
                    for (UIButton *btn in self.headerView.subviews) {
                        if ([btn isKindOfClass:[UIButton class]]) {
                            if (btn.selected) {
                                selectedBtnCount += 1;
                                [selectBtnStr appendString:[btn.currentTitle substringToIndex:1]];
                            }
                        }
                    }
                    if (selectedBtnCount >= 3) {
                        LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
                        NSString *currentSelectedStr = panModel.selectStrings;
                        NSInteger selectNumberCount = [[currentSelectedStr componentsSeparatedByString:@" "] count];
                        if (selectNumberCount >= 3) {
                            other = selectedBtnCount*(selectedBtnCount-1)*(selectedBtnCount-2)*selectNumberCount*(selectNumberCount-1)*(selectNumberCount-2)/(3*2*3*2);
                            if (other > 0) {
                                self.selectedNumbersLabel.text = [NSString stringWithFormat:@"%@ %@",selectBtnStr,[currentSelectedStr stringByReplacingOccurrencesOfString:@" " withString:@""]];
                            }else{
                                self.selectedNumbersLabel.text = @"";
                            }
                            
                        }
                        
                    }else{
                        self.selectedNumbersLabel.text = @"";
                        return other;
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 10:{
            switch (self.selectedIndex) {
                case 0:{
                    NSInteger zeroCount = 0;
                    NSMutableArray *selectCountArr = [NSMutableArray arrayWithCapacity:self.tableViewDataSource.count];
                    for (NSInteger i = 0; i < self.tableViewDataSource.count; i++) {
                        LotteryNumberPanModel *panModel = self.tableViewDataSource[i];
                        NSString *currentSelectedStr = [panModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSInteger currentSelectedLength = currentSelectedStr.length;
                        
                        if (currentSelectedLength == 0) {
                            zeroCount += 1;
                        }
                        [selectCountArr addObject:@(currentSelectedLength)];
                    }
                    if (zeroCount <= 1) {
                        NSInteger wanC = [selectCountArr[0] integerValue];
                        NSInteger qianC = [selectCountArr[1] integerValue];
                        NSInteger baiC = [selectCountArr[2] integerValue];
                        NSInteger shiC = [selectCountArr[3] integerValue];
                        NSInteger geC = [selectCountArr[4] integerValue];
                        other = wanC*qianC*baiC*shiC + wanC*qianC*baiC*geC + wanC*qianC*shiC*geC + wanC*baiC*shiC*geC + qianC*baiC*shiC*geC;
                    }
                }
                    break;
                case 2:{
                    //选了n个号码（n>=2），一共选了m个位置（m>=3且m<=5），则一共会形成m*(m-1)*(m-2)*n*(n-1)/3!注
                    NSInteger selectedBtnCount = 0;
                    NSMutableString *selectBtnStr = [NSMutableString string];
                    for (UIButton *btn in self.headerView.subviews) {
                        if ([btn isKindOfClass:[UIButton class]]) {
                            if (btn.selected) {
                                selectedBtnCount += 1;
                                [selectBtnStr appendString:[btn.currentTitle substringToIndex:1]];
                            }
                        }
                    }
                    if (selectedBtnCount >= 4) {
                        LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
                        NSString *currentSelectedStr = panModel.selectStrings;
                        NSInteger selectNumberCount = [[currentSelectedStr componentsSeparatedByString:@" "] count];
                        if (selectNumberCount >= 4) {
                            other = selectNumberCount*(selectNumberCount-1)*(selectNumberCount-2)*(selectNumberCount-3)*selectedBtnCount*(selectedBtnCount-1)*(selectedBtnCount-2)*(selectedBtnCount-3)/(4*3*2*4*3*2);
                            if (other > 0) {
                                self.selectedNumbersLabel.text = [NSString stringWithFormat:@"%@ %@",selectBtnStr,[currentSelectedStr stringByReplacingOccurrencesOfString:@" " withString:@""]];
                            }else{
                                self.selectedNumbersLabel.text = @"";
                            }
                            
                        }
                        
                    }else{
                        self.selectedNumbersLabel.text = @"";
                        return other;
                    }
                }
                    break;
                case 3:{
                    //选了n个号码（n>=2），一共选了m个位置（m>=3且m<=5），则一共会形成m*(m-1)*(m-2)*n*(n-1)/3!注
                    NSInteger selectedBtnCount = 0;
                    NSMutableString *selectBtnStr = [NSMutableString string];
                    for (UIButton *btn in self.headerView.subviews) {
                        if ([btn isKindOfClass:[UIButton class]]) {
                            if (btn.selected) {
                                selectedBtnCount += 1;
                                [selectBtnStr appendString:[btn.currentTitle substringToIndex:1]];
                            }
                        }
                    }
                    if (selectedBtnCount >= 4) {
                        LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
                        NSArray *erChongHaoArr = [panModel.selectStrings componentsSeparatedByString:@" "];
                        NSInteger erChongHaoCount = erChongHaoArr.count;
                        LotteryNumberPanModel *panDanModel = [self.tableViewDataSource lastObject];
                        NSArray *danHaoArr = [panDanModel.selectStrings componentsSeparatedByString:@" "];
                        NSInteger danHaoCount = danHaoArr.count;
                        if (erChongHaoCount >= 1 && danHaoCount >= 2) {
                            //n1个二重号（n1>=1），n2个单号（n2>=2），一共选了m个位置（m>=4且m<=5），则一共会形成m*(m-1)*(m-2)*(m-3)*n1*n2*(n2-1)/2!*4!
                            NSInteger repeatCount = 0;
                            for (NSInteger i1 = erChongHaoCount - 1; i1 >= 0; i1--) {
                                for (NSInteger i2 = danHaoCount - 1; i2 >= 0; i2--) {
                                    if ([erChongHaoArr[i1] isEqualToString:danHaoArr[i2]]) {
                                        repeatCount += (danHaoArr.count - 1);
                                    }
                                }
                            }
                            other = erChongHaoCount *danHaoCount *(danHaoCount - 1)/ 2 - repeatCount;
                            other = other * selectedBtnCount*(selectedBtnCount-1)*(selectedBtnCount-2)*(selectedBtnCount-3) / (4 * 3 * 2);
                        }
                        if (other > 0) {
                            self.selectedNumbersLabel.text = [NSString stringWithFormat:@"%@ %@,%@",selectBtnStr,[panModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""],[panDanModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""]];
                        }else{
                            self.selectedNumbersLabel.text = @"";
                        }
                    }else{
                        self.selectedNumbersLabel.text = @"";
                        return other;
                    }
                }
                    break;
                case 4:{
                    
               
                    NSInteger selectedBtnCount = 0;
                    NSMutableString *selectBtnStr = [NSMutableString string];
                    for (UIButton *btn in self.headerView.subviews) {
                        if ([btn isKindOfClass:[UIButton class]]) {
                            if (btn.selected) {
                                selectedBtnCount += 1;
                                [selectBtnStr appendString:[btn.currentTitle substringToIndex:1]];
                            }
                        }
                    }
                    if (selectedBtnCount >= 4) {
                        LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
                        NSArray *erChongHaoArr = [panModel.selectStrings componentsSeparatedByString:@" "];
                        if (erChongHaoArr.count >= 2) {
                            // 一共选了n个二重号（n>=2），一共选了m个位置（m>=4且m<=5），则一共会形成m*(m-1)*(m-2)*(m-3)*n*(n-1)/4!*2!
                            
                            other = selectedBtnCount*(selectedBtnCount-1)*(selectedBtnCount-2)*(selectedBtnCount-3)*erChongHaoArr.count*(erChongHaoArr.count-1)/(2*4*3*2);
                            
                            if (other > 0) {
                                self.selectedNumbersLabel.text = [NSString stringWithFormat:@"%@ %@",selectBtnStr,[panModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""]];
                            }else{
                                self.selectedNumbersLabel.text = @"";
                            }
                        }
                    }else{
                        self.selectedNumbersLabel.text = @"";
                        return other;
                    }
                }
                    break;
                default:{   // 最后一个组选4
                    //选了n个号码（n>=2），一共选了m个位置（m>=3且m<=5），则一共会形成m*(m-1)*(m-2)*n*(n-1)/3!注
                    NSInteger selectedBtnCount = 0;
                    NSMutableString *selectBtnStr = [NSMutableString string];
                    for (UIButton *btn in self.headerView.subviews) {
                        if ([btn isKindOfClass:[UIButton class]]) {
                            if (btn.selected) {
                                selectedBtnCount += 1;
                                [selectBtnStr appendString:[btn.currentTitle substringToIndex:1]];
                            }
                        }
                    }
                    LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
                    LotteryNumberPanModel *panDanModel = [self.tableViewDataSource lastObject];
                    if (selectedBtnCount >= 4) {
                        
                        if (panDanModel.selectStrings.length > 0 && panDanModel.selectStrings.length > 0) {
                            self.selectedNumbersLabel.text = [NSString stringWithFormat:@"%@ %@,%@",selectBtnStr,[panModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""],[panDanModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""]];
                            NSArray *sa1 = [panModel.selectStrings componentsSeparatedByString:@" "];
                            NSInteger sanChongHaoCount = sa1.count;
                            NSArray *sa2 = [panDanModel.selectStrings componentsSeparatedByString:@" "];
                            NSInteger danHaoCount = sa2.count;
                            if (sanChongHaoCount >= 1 && danHaoCount >= 1) {
                                //n1个三重号（n1>=1），n2个单号（n2>=1）个单号，m个位置（m>=4且m<=5），则一共会形成（m*(m-1)*(m-2)*(m-3)*n1*n2/4!
                                NSInteger repeatCount = 0, i1, i2, n1, n2;
                                if ((n1 = sa1.count) >= 1 && (n2 = sa2.count) >= 1) {
                                    for (i1 = sa1.count - 1; i1 >= 0; i1--) {
                                        for (i2 = sa2.count - 1; i2 >= 0; i2--) {
                                            if ([sa1[i1] isEqualToString:sa2[i2]]) {
                                                repeatCount++;
                                            }
                                        }
                                    }
                                    other = n1 * n2 - repeatCount;
                                    other = other * selectedBtnCount * (selectedBtnCount - 1) * (selectedBtnCount - 2) * (selectedBtnCount - 3) / (4*3*2);
                                }
                                
                            }
                        }else{
                            self.selectedNumbersLabel.text = @"";
                        }
                        
                    }
                    
                    return other;
                    
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return other;
}



-(NSInteger)getZuXuan{
    NSString *erChongHaoSelectedStr = [[self.tableViewDataSource firstObject] selectStrings];
    NSArray *erChongHaoSelectedArr = [erChongHaoSelectedStr componentsSeparatedByString:@" "];
    NSString *danHaoSelectedStr = [[self.tableViewDataSource lastObject] selectStrings];
    NSArray *danHaoSelectedArr = [danHaoSelectedStr componentsSeparatedByString:@" "];
    if ((erChongHaoSelectedArr.count >= 1 && erChongHaoSelectedStr.length > 0) && (danHaoSelectedArr.count >= 3 && danHaoSelectedStr.length > 0)) {
        // 二重号*单号*(单号-1)*(单号-2)/3!
        //判断所选单号是否在二重号里面
        NSInteger repeatCount = 0;
        for (NSString *danStr in danHaoSelectedArr) {
            for (NSString *erChongStr in erChongHaoSelectedArr) {
                if ([danStr isEqualToString:erChongStr]) {
                    repeatCount += ((danHaoSelectedArr.count - 1)*(danHaoSelectedArr.count - 2)*0.5);
                }
            }
        }
        return erChongHaoSelectedArr.count * danHaoSelectedArr.count * (danHaoSelectedArr.count - 1) * (danHaoSelectedArr.count - 2) / 6 - repeatCount;
    }else{
        return 0;
    }
}

-(NSInteger)getZuXuan30{
    NSString *erChongHaoSelectedStr = [[self.tableViewDataSource firstObject] selectStrings];
    NSArray *erChongHaoSelectedArr = [erChongHaoSelectedStr componentsSeparatedByString:@" "];
    NSString *danHaoSelectedStr = [[self.tableViewDataSource lastObject] selectStrings];
    NSArray *danHaoSelectedArr = [danHaoSelectedStr componentsSeparatedByString:@" "];
    if ((erChongHaoSelectedArr.count >= 2 && erChongHaoSelectedStr.length > 0) && (danHaoSelectedArr.count >= 1 && danHaoSelectedStr.length > 0)) {
        //单号*二重号*(二重号-1)/2!
        //判断所选单号是否在二重号里面
        NSInteger repeatCount = 0;
        for (NSString *danStr in danHaoSelectedArr) {
            for (NSString *erChongStr in erChongHaoSelectedArr) {
                if ([danStr isEqualToString:erChongStr]) {
                    repeatCount += (erChongHaoSelectedArr.count - 1);
                }
            }
        }
        
        return danHaoSelectedArr.count * erChongHaoSelectedArr.count * (erChongHaoSelectedArr.count - 1) * 0.5 - repeatCount;
    }else{
        return 0;
    }
}

-(NSInteger)getZuXuan20{
    NSString *sanChongHaoSelectedStr = [[self.tableViewDataSource firstObject] selectStrings];
    NSArray *sanChongHaoSelectedArr = [sanChongHaoSelectedStr componentsSeparatedByString:@" "];
    NSString *danHaoSelectedStr = [[self.tableViewDataSource lastObject] selectStrings];
    NSArray *danHaoSelectedArr = [danHaoSelectedStr componentsSeparatedByString:@" "];
    if ((sanChongHaoSelectedArr.count >= 1 && sanChongHaoSelectedStr.length > 0) && (danHaoSelectedArr.count >= 2 && danHaoSelectedStr.length > 0)) {
        //三重号*单号*(单号-1)/2!
        //判断所选单号是否在二重号里面
        NSInteger repeatCount = 0;
        for (NSString *danStr in danHaoSelectedArr) {
            for (NSString *sanChongStr in sanChongHaoSelectedArr) {
                if ([danStr isEqualToString:sanChongStr]) {
                    repeatCount += (danHaoSelectedArr.count - 1);
                }
            }
        }
        return sanChongHaoSelectedArr.count * danHaoSelectedArr.count * (danHaoSelectedArr.count - 1) / 2 - repeatCount;
    }else{
        return 0;
    }
}

-(NSInteger)getZuXuan10{
    NSString *sanChongHaoSelectedStr = [[self.tableViewDataSource firstObject] selectStrings];
    NSArray *sanChongHaoSelectedArr = [sanChongHaoSelectedStr componentsSeparatedByString:@" "];
    NSString *erChongHaoSelectedStr = [[self.tableViewDataSource lastObject] selectStrings];
    NSArray *erChongSelectedArr = [erChongHaoSelectedStr componentsSeparatedByString:@" "];
    if ((sanChongHaoSelectedArr.count >= 1 && sanChongHaoSelectedStr.length > 0) && (erChongSelectedArr.count >= 1 && erChongHaoSelectedStr.length > 0)) {
        //    n1*n2 - 重复的
        NSInteger repeatCount = 0;
        for (NSString *danStr in sanChongHaoSelectedArr) {
            for (NSString *sanChongStr in erChongSelectedArr) {
                if ([danStr isEqualToString:sanChongStr]) {
                    repeatCount += 1;
                }
            }
        }
        return sanChongHaoSelectedArr.count * erChongSelectedArr.count -  repeatCount;
    }else{
        return 0;
    }
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
    if (self.singlePlayView) {
        [self.singlePlayView clearBettingContent];
        self.singleViewSelectedContentLabel.text = @"";
        self.sureBtn.enabled = NO;
        self.clearSelectBtn.enabled = NO;
    }else{
        for (LotteryNumberPanModel *model in self.tableViewDataSource) {
            model.selectStrings = @"";
        }
        [self.numberPanTable reloadData];
        self.clearSelectBtn.enabled = NO;
        self.sureBtn.enabled = NO;
        self.selectedInfoLabel.text = @"";
        self.selectedNumbersLabel.text = @"";
    }
    
}

#pragma mark - 点击付款按钮，跳转到投注列表页面
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
            float bettingMoney = 1;
            if ([model isEqualToString:@"角"]) {
                if (self.singlePlayView) {
                    bettingMoney = self.singleViewbettingCount * 2 * mul * 0.1;
                }else{
                    bettingMoney = self.bettingCount * 2 * mul * 0.1;
                }
            }else if ([model isEqualToString:@"分"]){
                if (self.singlePlayView) {
                    bettingMoney = self.singleViewbettingCount * 2 * mul * 0.01;
                }else{
                    bettingMoney = self.bettingCount * 2 * mul * 0.01;
                }
            }else{
                if (self.singlePlayView) {
                    bettingMoney = self.singleViewbettingCount * 2 * mul * 1;
                }else{
                    bettingMoney = self.bettingCount * 2 * mul * 1;
                }
            }
            //投注金额
            NSString *amount = [NSString stringWithFormat:@"%@",@(bettingMoney)];
            
            NSMutableString *bettingContent = [[NSMutableString alloc] init];
            // 五星定位胆        self.categoryIndex == 0 && self.selectedIndex == 0
            // 前二直选        self.categoryIndex == 1 && self.selectedIndex == 0
            // 后二_直选        self.categoryIndex == 2 && self.selectedIndex == 0
            
            // 前三_直选        self.categoryIndex == 3 && self.selectedIndex == 0
            // 中三_直选        self.categoryIndex == 4 && self.selectedIndex == 0
            // 后三_直选        self.categoryIndex == 5 && self.selectedIndex == 0
            // 四星_直选        self.categoryIndex == 6 && self.selectedIndex == 0
            
            // 前三_组合        self.categoryIndex == 3 && self.selectedIndex == 1
            // 中三_组合        self.categoryIndex == 4 && self.selectedIndex == 1
            // 后三_组合        self.categoryIndex == 5 && self.selectedIndex == 1
            // 四星_组合        self.categoryIndex == 6 && self.selectedIndex == 1
            if (self.singlePlayView) {
                bettingContent.string = self.singleViewbettingContent;
            }else{
                if (self.selectedIndex == 0 && (self.categoryIndex == 0 || self.categoryIndex == 8 || self.categoryIndex == 9 || self.categoryIndex == 10)) {
                    for (NSInteger i = 0; i < self.tableViewDataSource.count; i++) {
                        LotteryNumberPanModel *pamModel = self.tableViewDataSource[i];
                        if (pamModel.selectStrings.length > 0) {
                            NSString *selectedStr = [pamModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""];
                            if (i == 0) {
                                [bettingContent appendString:selectedStr];
                            }else{
                                [bettingContent appendString:[NSString stringWithFormat:@" %@",selectedStr]];
                            }
                        }else{
                            if (i == 0) {
                                [bettingContent appendString:@"_"];
                            }else{
                                [bettingContent appendString:@" _"];
                            }
                        }
                    }
                }else if (self.categoryIndex == 1 || self.categoryIndex == 2){
                    if (self.selectedIndex == 0) {
                        // (直选复式)前二直选 (123 9 _ _ _)、后二直选 (_ _ _ 123 9)
                        if (self.categoryIndex == 1) {
                            bettingContent.string = [NSString stringWithFormat:@"%@ _ _ _",self.selectedNumbersLabel.text];
                        }else{
                            bettingContent.string = [NSString stringWithFormat:@"_ _ _ %@",self.selectedNumbersLabel.text];
                        }
                        
                    }else if (self.selectedIndex == 2 || self.selectedIndex == 3){
                        // 前二_直选和值、直选跨度(1,4,18)
                        bettingContent.string = [self.selectedNumbersLabel.text stringByReplacingOccurrencesOfString:@" " withString:@","];
                    }else{
                        // 前二_直选组选、组选包胆 1234
                        bettingContent.string = [self.selectedNumbersLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    }
                    
                }else if (self.categoryIndex == 3){
                    if (self.selectedIndex == 0 || self.selectedIndex == 2) {
                        // 前三直选、前三组合(3 04 13 _ _)
                        bettingContent.string = [NSString stringWithFormat:@"%@ _ _",self.selectedNumbersLabel.text];
                    }else if (self.selectedIndex == 3 || self.selectedIndex == 4){
                        // 前三 直选和值、直选跨度、组选和值 （3,6,25）
                        bettingContent.string = [self.selectedNumbersLabel.text stringByReplacingOccurrencesOfString:@" " withString:@","];
                    }else if (self.selectedIndex == 5 || self.selectedIndex == 7 || self.selectedIndex == 9 || self.selectedIndex == 10){
                        // 前三 组三、组六、组选包胆、和值尾数（123）
                        bettingContent.string = [self.selectedNumbersLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    }
                }else if (self.categoryIndex == 4){
                    if (self.selectedIndex == 0 || self.selectedIndex == 2) {
                        // 中三直选、中三组合(_ 3 04 13 _)
                        bettingContent.string = [NSString stringWithFormat:@"_ %@ _",self.selectedNumbersLabel.text];
                    }else if (self.selectedIndex == 3 || self.selectedIndex == 4){
                        // 前三 直选和值、直选跨度、组选和值 （3,6,25）
                        bettingContent.string = [self.selectedNumbersLabel.text stringByReplacingOccurrencesOfString:@" " withString:@","];
                    }else if (self.selectedIndex == 5 || self.selectedIndex == 7 || self.selectedIndex == 9 || self.selectedIndex == 10){
                        // 前三 组三、组六、组选包胆、和值尾数（123）
                        bettingContent.string = [self.selectedNumbersLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    }
                }else if (self.categoryIndex == 5){
                    if (self.selectedIndex == 0 || self.selectedIndex == 2) {
                        // 中三直选、中三组合(_ _ 3 04 13)
                        bettingContent.string = [NSString stringWithFormat:@"_ _ %@",self.selectedNumbersLabel.text];
                    }else if (self.selectedIndex == 3 || self.selectedIndex == 4){
                        // 前三 直选和值、直选跨度、组选和值 （3,6,25）
                        bettingContent.string = [self.selectedNumbersLabel.text stringByReplacingOccurrencesOfString:@" " withString:@","];
                    }else if (self.selectedIndex == 5 || self.selectedIndex == 7 || self.selectedIndex == 9 || self.selectedIndex == 10){
                        // 前三 组三、组六、组选包胆、和值尾数（123）
                        bettingContent.string = [self.selectedNumbersLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    }
                }else if (self.categoryIndex == 6){
                    if (self.selectedIndex == 0 || self.selectedIndex == 2) {
                        // 四星直选、四星组合(_ 12 3 4 5)
                        bettingContent.string = [NSString stringWithFormat:@"_ %@",self.selectedNumbersLabel.text];
                    }else{
                        // 组选
                        for (NSInteger i = 0; i < self.tableViewDataSource.count; i++) {
                            LotteryNumberPanModel *pamModel = self.tableViewDataSource[i];
                            NSString *selectedStr = [pamModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""];
                            if (i == 0) {
                                [bettingContent appendString:selectedStr];
                            }else{
                                [bettingContent appendString:[NSString stringWithFormat:@",%@",selectedStr]];
                            }
                        }
                    }
                }else if (self.categoryIndex == 7){
                    if (self.selectedIndex == 0 || self.selectedIndex == 2) {
                        bettingContent.string = self.selectedNumbersLabel.text;
                    }else{
                        for (NSInteger i = 0; i < self.tableViewDataSource.count; i++) {
                            LotteryNumberPanModel *pamModel = self.tableViewDataSource[i];
                            NSString *selectedStr = [pamModel.selectStrings stringByReplacingOccurrencesOfString:@" " withString:@""];
                            if (i == 0) {
                                [bettingContent appendString:selectedStr];
                            }else{
                                [bettingContent appendString:[NSString stringWithFormat:@",%@",selectedStr]];
                            }
                        }
                    }
                }else if (self.categoryIndex == 8){
                    bettingContent.string = self.selectedNumbersLabel.text;
                }else if (self.categoryIndex == 9){
                    bettingContent.string = self.selectedNumbersLabel.text;
                }else{
                    bettingContent.string = self.selectedNumbersLabel.text;
                }
            }
            
            OrderCheckView *checkView = [[[NSBundle mainBundle] loadNibNamed:@"OrderCheckView" owner:nil options:nil] firstObject];
            checkView.frame = [UIScreen mainScreen].bounds;
            PlayCategory *category = self.shishicaiDataSource[self.categoryIndex][self.selectedIndex];
            checkView.orderCheckDict = @{
                                         @"playedId":category.playedId,
                                         @"playedName":category.playedName,
                                         @"productName":self.lotteryType.productVo.name,
                                         @"productId":self.lotteryType.productVo.productId,
                                         @"periodName":self.lotteryType.periodVo.name,
                                         @"bettingContent":bettingContent,
                                         @"bettingCount":[NSString stringWithFormat:@"%zd",self.singlePlayView ? self.singleViewbettingCount : self.bettingCount],
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

- (IBAction)showHistoryInfo:(id)sender {
    LotteryResultDetailViewController *resultDetail = [[LotteryResultDetailViewController alloc] init];
    resultDetail.result = self.lotteryType;
    resultDetail.hiddenBottomView = YES;
    [self.navigationController pushViewController:resultDetail animated:YES];
}


@end
