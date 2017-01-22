//
//  LotteryElevenChooseFiveController.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/17.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "ElevenChooseFiveController.h"
#import "NavigationTitleView.h"
#import "UIImage+ImageWithColor.h"
#import "NumberPanView.h"
#import "PlayCategoryBtn.h"
#import "MJExtension.h"
#import "PlayCategory.h"
#import "LotteryElevenChooseFiveNumberPanCell.h"
#import "LotteryNumberPanModel.h"
#import "BettingListModel.h"
#import "BettingListViewController.h"
#import "OrderCheckView.h"
#import "FaceViewController.h"
#import "PlayedVo.h"
#import "LotteryResultDetailViewController.h"


@interface ElevenChooseFiveController ()<UITableViewDelegate,UITableViewDataSource,LotteryElevenChooseFiveNumberPanCellDelegate,UITextFieldDelegate>
@property (nonatomic,strong) NSArray *elevenChooseFiveDataSource;
@property (nonatomic,strong) NSArray *playedVos;
@property (nonatomic,strong) NSArray *tableViewDataSource;
@property (nonatomic,strong) UIView *chooseView;
@property (nonatomic,strong) UIButton *maskBtnView;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *playDescriptionLabel;
@property (nonatomic,copy) NSMutableString *playDescriptionStr;
@property (nonatomic,strong) NSMutableArray *playCategoryBtnsContainer;

@property(nonatomic,weak) PlayCategoryBtn *selectedPlayCategorybtn;    //记录选中的玩法按钮
@property (weak, nonatomic) IBOutlet UIButton *clearSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *PlayedVoLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedNumbersLabel;
@property (weak, nonatomic) IBOutlet UILabel *elevenChoosefiveCloseDateLael;
@property (weak, nonatomic) IBOutlet UITableView *elevenChooseFiveTableView;
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
@property(nonatomic,assign) NSInteger elevenChooseFiveRetainSecond;
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation ElevenChooseFiveController
-(NSArray *)elevenChooseFiveDataSource{
    if (!_elevenChooseFiveDataSource) {
        _elevenChooseFiveDataSource = [PlayCategory mj_objectArrayWithFilename:[NSString stringWithFormat:@"%@.plist",self.lotteryType.productVo.name]];
    }
    return _elevenChooseFiveDataSource;
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
-(NSMutableArray *)playCategoryBtnsContainer{
    if (!_playCategoryBtnsContainer) {
        _playCategoryBtnsContainer = [NSMutableArray array];
    }
    return _playCategoryBtnsContainer;
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
                self.elevenChoosefiveCloseDateLael.attributedText = closeLabelAttributeStr;
            }else{
                NSDate *nowDate = [NSDate getDateFromDateString:[[responseObject valueForKey:@"result"] valueForKey:@"now"]];
                NSDictionary *dict = [responseObject valueForKey:@"result"];
                PeriodVo *period = [PeriodVo mj_objectWithKeyValues:[dict valueForKey:@"period"]];
                self.lotteryType.periodVo = period;
                NSDate *endDate = [NSDate getDateFromDateString:period.timeEnd];
                self.elevenChooseFiveRetainSecond = [endDate timeIntervalSinceReferenceDate] - [nowDate timeIntervalSinceReferenceDate];
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
    NSInteger currentSecond = --self.elevenChooseFiveRetainSecond;
    NSInteger mimute = currentSecond / 60;
    NSInteger second = currentSecond % 60;
    NSString *retainTime = [NSString stringWithFormat:@"%02ld:%02ld",(long)mimute,(long)second];
    NSMutableAttributedString *closeLabelAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期截止：%@",[self.lotteryType.periodVo.name substringFromIndex:self.lotteryType.periodVo.name.length - 3],retainTime]];
    [closeLabelAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(closeLabelAttributeStr.length - retainTime.length, retainTime.length)];
    self.elevenChoosefiveCloseDateLael.attributedText = closeLabelAttributeStr;
    if (self.elevenChooseFiveRetainSecond == 0) {
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
    
    self.elevenChooseFiveTableView.delegate = self;
    self.elevenChooseFiveTableView.dataSource = self;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCheckDidConform) name:@"KOrderCheckDidConformNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCheckRepeatConform:) name:@"KOrderCheckRepeatConformNotification" object:nil];
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
            self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",self.bettingCount,@(bettingMoney)] : @"";
        }
    }];

}


#pragma mark - 初始化数字选择面板
-(void)setupChooseView{
    UIView *chooseView = [[UIView alloc] init];
    chooseView.backgroundColor = [UIColor whiteColor];
    
    CGFloat normalBtnsMaxY = 0;
    
    UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
    bgLabel.backgroundColor = RGB(230, 230, 224);;
    [chooseView addSubview:bgLabel];
    UILabel *normalLabel = [[UILabel alloc] init];
    normalLabel.text = @" 普通 ";
    normalLabel.font = [UIFont systemFontOfSize:12];
    normalLabel.backgroundColor = [UIColor whiteColor];
    normalLabel.textColor = [UIColor grayColor];
    [chooseView addSubview:normalLabel];
    normalLabel.y = 10;
    normalLabel.width = 50;
    normalLabel.centerX = KScreenWidth * 0.5;
    [normalLabel sizeToFit];
    bgLabel.centerY = normalLabel.centerY;
    
    
    CGFloat shopViewH = 33;
    NSUInteger maxColumn = 3;
    NSUInteger columnMargin = 10;
    CGFloat shopViewW = (KScreenWidth - ((maxColumn + 1) * columnMargin)) / maxColumn;
    
    //self.elevenChooseFiveDataSource.count
    for (NSInteger i = 0; i < 12; i++) {
        PlayCategoryBtn *playCategorybtn = [PlayCategoryBtn buttonWithType:UIButtonTypeCustom];
        PlayCategory *playC = self.elevenChooseFiveDataSource[i];
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
        playCategorybtn.frame = CGRectMake((shopViewW + columnMargin) * column + columnMargin, columnMargin + (shopViewH + columnMargin) * row + CGRectGetMaxY(normalLabel.frame),shopViewW, shopViewH);
        [self.playCategoryBtnsContainer addObject:playCategorybtn];
        [chooseView addSubview:playCategorybtn];
        if (i == 0) {
            [self chooseBtnClick:playCategorybtn];
        }
        if (i == 11) {
            normalBtnsMaxY = CGRectGetMaxY(playCategorybtn.frame) + columnMargin;
        }
    }
    
    
    
    //胆拖标识线
    UILabel *bgLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
    bgLabel2.backgroundColor = RGB(230, 230, 224);;
    [chooseView addSubview:bgLabel2];
    UILabel *dantuoLabel = [[UILabel alloc] init];
    dantuoLabel.text = @" 胆拖 ";
    dantuoLabel.font = [UIFont systemFontOfSize:12];
    dantuoLabel.backgroundColor = [UIColor whiteColor];
    dantuoLabel.textColor = [UIColor grayColor];
    
    [chooseView addSubview:dantuoLabel];
    dantuoLabel.y = normalBtnsMaxY;
    dantuoLabel.width = 50;
    dantuoLabel.centerX = KScreenWidth * 0.5;
    [dantuoLabel sizeToFit];
    
    bgLabel2.centerY = dantuoLabel.centerY;

    
    for (NSInteger i = 12; i < self.elevenChooseFiveDataSource.count; i++) {
        PlayCategoryBtn *playCategorybtn = [PlayCategoryBtn buttonWithType:UIButtonTypeCustom];
        PlayCategory *playC = self.elevenChooseFiveDataSource[i];
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
        playCategorybtn.frame = CGRectMake((shopViewW + columnMargin) * column + columnMargin, columnMargin + (shopViewH + columnMargin) * row + dantuoLabel.height * 3 + columnMargin,shopViewW, shopViewH);
        [self.playCategoryBtnsContainer addObject:playCategorybtn];
        [chooseView addSubview:playCategorybtn];
        if (i == self.elevenChooseFiveDataSource.count - 1) {
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
    static NSString *identification = @"elevenChooseFiveCell";
    LotteryElevenChooseFiveNumberPanCell *cell = [tableView dequeueReusableCellWithIdentifier:identification];
    if (cell == nil) {
        cell = [[LotteryElevenChooseFiveNumberPanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identification];
        
    }
    
    cell.customDelegate = self;
    
    NavigationTitleView *titleBtn = (NavigationTitleView *)self.navigationItem.titleView;
    NSString *titleStr = titleBtn.currentTitle;
    if ([titleStr containsString:@"胆拖"]) {
        cell.isShowSeperateBtns = NO;
    }else{
        cell.isShowSeperateBtns = YES;
    }
    
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
    NavigationTitleView *titleBtn = (NavigationTitleView *)self.navigationItem.titleView;
    NSString *titleStr = titleBtn.currentTitle;
    if ([titleStr containsString:@"胆拖"]) {
        return (155 / KIPhone6Height) * KScreenHeight;
    }else{
        return (200 / KIPhone6Height) * KScreenHeight;
    }
}

-(void)ElevenChooseFiveNumberPanCell:(LotteryElevenChooseFiveNumberPanCell *)numberPanView didSelectedNumberBtn:(UIButton *)numberBtn{
    // 点击的数字按钮在tableview的第 clickedRow 行
    NSInteger clickedRow = [self.elevenChooseFiveTableView indexPathForCell:numberPanView].row;
    // 取得该行的数据模型
    LotteryNumberPanModel *panM = self.tableViewDataSource[clickedRow];
    // 获得该数字面板已经选择的数字
    NSString *currentSelectedString = panM.selectStrings;
    NSArray *selectedNumbers = [panM.selectStrings componentsSeparatedByString:@" "];
    // 根据选择的玩法，确定tableView的数据源
    self.selectedIndex = [self.playCategoryBtnsContainer indexOfObject:self.selectedPlayCategorybtn];
    if (numberBtn.selected) {
        numberBtn.selected = NO;
        
        panM.selectStrings = [NSString deleteObjStr:numberBtn.currentTitle fromSelectedStr:currentSelectedString];
    }else{
        // 选择完不同的玩法，改变navigationTitle的文字
        NavigationTitleView *titleBtn = (NavigationTitleView *)self.navigationItem.titleView;
        
        
        if (self.selectedIndex < 12) {
            // 普通玩法的数字选择
            panM.selectStrings = [NSString appendObjStr:numberBtn.currentTitle toSelectedStr:panM.selectStrings];
        }else{
            // 选择的是胆码
            if (clickedRow == 0) {
                // 拿出拖码的模型
                LotteryNumberPanModel *panM2 = self.tableViewDataSource[1];
                
                
                LotteryNumberPanModel *danM = self.tableViewDataSource[0];
                if ([danM.selectStrings containsString: numberBtn.currentTitle]) {
                    danM.selectStrings = [NSString deleteObjStr:numberBtn.currentTitle fromSelectedStr:danM.selectStrings];
                }
                
                
                NSArray *tuoMaSelectedArr = [panM2.selectStrings componentsSeparatedByString:@" "];
                NSString *titleStr = [titleBtn.currentTitle stringByReplacingOccurrencesOfString:@"胆拖" withString:@""];
                if (self.selectedIndex > 11 && self.selectedIndex < 19) {
                    if (currentSelectedString.length > 0 && selectedNumbers.count >= (self.selectedIndex - 11)) {
                        NSString *infoStr = [NSString stringWithFormat:@"%@最多只能选%zd个胆码",titleStr,self.selectedIndex - 11];
                        [SVProgressHUD showInfoWithStatus:infoStr];
                        return;
                    }
                }
                // 前二组选
                else if (self.selectedIndex == 19) {
                    if (currentSelectedString.length > 0 && selectedNumbers.count >= (self.selectedIndex - 18)) {
                        NSString *infoStr = [NSString stringWithFormat:@"%@最多只能选%zd个胆码",titleStr,self.selectedIndex - 18];
                        [SVProgressHUD showInfoWithStatus:infoStr];
                        return;
                    }
                }
                // 前三组选
                else if (self.selectedIndex == 20) {
                    if (currentSelectedString.length > 0 && selectedNumbers.count >= (self.selectedIndex - 18)) {
                        NSString *infoStr = [NSString stringWithFormat:@"%@最多只能选%zd个胆码",titleStr,self.selectedIndex - 18];
                        [SVProgressHUD showInfoWithStatus:infoStr];
                        return;
                    }
                }
                
                // 添加选择的胆码数字
                panM.selectStrings = [NSString appendObjStr:numberBtn.currentTitle toSelectedStr:panM.selectStrings];
                
                
                // 如果选中的数字在拖码中也存在，拖码就要取消这个数字的选中
                if ([tuoMaSelectedArr containsObject:numberBtn.currentTitle]) {
                    panM2.selectStrings = [NSString deleteObjStr:numberBtn.currentTitle fromSelectedStr:panM2.selectStrings];
                }
                
            }else{  //选择的是拖码
                // 拿出胆码的模型
                LotteryNumberPanModel *panM2 = self.tableViewDataSource[0];
                NSArray *danMaSelectedArr = [panM2.selectStrings componentsSeparatedByString:@" "];
                if (currentSelectedString.length > 0 && selectedNumbers.count >= 10) {
                    [SVProgressHUD showInfoWithStatus:@"任选二最多只能选十个拖码"];
                    return;
                }
                panM.selectStrings = [NSString appendObjStr:numberBtn.currentTitle toSelectedStr:panM.selectStrings];
                
                // 如果选中的数字在胆码中也存在，拖码就要取消这个数字的选中
                if ([danMaSelectedArr containsObject:numberBtn.currentTitle]) {
                    panM2.selectStrings = [NSString deleteObjStr:numberBtn.currentTitle fromSelectedStr:panM2.selectStrings];
                }
            }
        }
    }
    
//    NSIndexPath *path = [self.elevenChooseFiveTableView indexPathForCell:numberPanView];
//    [self.elevenChooseFiveTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    [self.elevenChooseFiveTableView reloadData];
    // 遍历数据模型，显示已经选择的数字和注数
    [self setSelectedBettingText];
}

-(void)ElevenChooseFiveNumberPanCell:(LotteryElevenChooseFiveNumberPanCell *)numberPanView didSelectedSeperateBtn:(UIButton *)seperateBtn{
    NSInteger clickedRow = [self.elevenChooseFiveTableView indexPathForCell:numberPanView].row;
    LotteryNumberPanModel *panM = self.tableViewDataSource[clickedRow];
    
    if ([seperateBtn.currentTitle isEqualToString:@"大"]) {
        panM.selectStrings = @"06 07 08 09 10 11";
    }else if([seperateBtn.currentTitle isEqualToString:@"小"]) {
        panM.selectStrings = @"01 02 03 04 05";
    }else if([seperateBtn.currentTitle isEqualToString:@"双"]) {
        panM.selectStrings = @"02 04 06 08 10";
    }else if([seperateBtn.currentTitle isEqualToString:@"单"]) {
        panM.selectStrings = @"01 03 05 07 09 11";
    }else if([seperateBtn.currentTitle isEqualToString:@"清"]) {
        panM.selectStrings = @"";
    }else if([seperateBtn.currentTitle isEqualToString:@"全"]) {
        panM.selectStrings = @"01 02 03 04 05 06 07 08 09 10 11";
    }

    NSIndexPath *path = [self.elevenChooseFiveTableView indexPathForCell:numberPanView];
    [self.elevenChooseFiveTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];

    // 遍历数据模型，显示已经选择的数字和注数
    [self setSelectedBettingText];
}

#pragma mark - 设置底部selectedNumbersLabel和selectedInfoLabel的文案
-(void)setSelectedBettingText{
    NSInteger chooseCount = [self getBettingCountFromPlayCategory];
    
    NSString *selectedAllNumbers = [[NSString alloc] init];
    NSString *selectedDanmaNumbers = [[NSString alloc] init];
    NSString *selectedTuomaNumbers = [[NSString alloc] init];
    for (LotteryNumberPanModel *numberPanModel in self.tableViewDataSource) {
        if (numberPanModel.selectStrings.length != 0) {
            
            if (chooseCount > 0) {
                NavigationTitleView *titleBtn = (NavigationTitleView *)self.navigationItem.titleView;
                if ([titleBtn.currentTitle containsString:@"胆拖"]) {
                    if ([numberPanModel.numberPanType isEqualToString:@"胆码"]) {
                        selectedDanmaNumbers = [NSString appendObjStr:numberPanModel.selectStrings toSelectedStr:selectedDanmaNumbers];
                    }else{
                        selectedTuomaNumbers = [NSString appendObjStr:numberPanModel.selectStrings toSelectedStr:selectedTuomaNumbers];
                    }
                }else{
                    if ([titleBtn.currentTitle isEqualToString:@"前二直选"] || [titleBtn.currentTitle isEqualToString:@"前三直选"]) {
                        selectedAllNumbers = [NSString stringFromArray:self.tableViewDataSource useSeperator:@"|" subSeperator:@","];
                    }else{
                        selectedAllNumbers = [NSString appendObjStr:numberPanModel.selectStrings toSelectedStr:selectedAllNumbers];
                    }
                }
            }else{
                selectedAllNumbers = [NSString appendObjStr:numberPanModel.selectStrings toSelectedStr:selectedAllNumbers];
            }
        }
    }
    
    
    if (selectedDanmaNumbers.length > 0) {
        selectedAllNumbers = [NSString stringWithFormat:@"(%@)%@",selectedDanmaNumbers,selectedTuomaNumbers];
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
    self.selectedInfoLabel.text = [NSString stringWithFormat:@"共%zd注 %@元",chooseCount,@(bettingMoney)];
    
    PlayCategory *playCategory = self.elevenChooseFiveDataSource[self.selectedIndex];
    
    if (self.playedVos.count != 0) {
        for (PlayedVo *playedVo in self.playedVos) {
            if ([playedVo.playedId isEqualToString:playCategory.playedId]) {
                VipVo *vip = KGetVip;
                self.PlayedVoLabel.text = [NSString stringWithFormat:@"%.2f-%.2f%%",playedVo.jiang,vip.fdPst];
            }
        }
    }
    
    self.clearSelectBtn.enabled = selectedAllNumbers.length == 0 ? NO : YES;
    self.sureBtn.enabled = chooseCount > 0 ? YES : NO;
    
    self.bettingCount = chooseCount;
    
    self.numbersForBettingList = selectedAllNumbers;
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
        // 根据选择的玩法，确定tableView的数据源
        NSInteger index = [self.playCategoryBtnsContainer indexOfObject:btn];
        self.selectedIndex = index;
        if (index > 11) {
            [titleBtn setTitle:[NSString stringWithFormat:@"%@胆拖",btn.currentTitle] forState:UIControlStateNormal];
        }else{
            [titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
        }
        self.chooseView.y = -self.chooseView.height;
        [titleBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        // 修改玩法说明文案
        [self playDescAttributeString:btn];
        
        self.tableViewDataSource = [self.elevenChooseFiveDataSource[index] valueForKey:@"numberPanModels"];
        [self.elevenChooseFiveTableView reloadData];
        
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
    NSInteger other = 0;
    NSInteger selectedPlayCategoryBtnIndex = [self.playCategoryBtnsContainer indexOfObject:self.selectedPlayCategorybtn];
    
    NSString *selectPlayName = self.selectedPlayCategorybtn.playCategory.playCategoryName;
    //普通选区
    if (selectedPlayCategoryBtnIndex < 12) {
        
        if (self.tableViewDataSource.count == 1) {
            LotteryNumberPanModel *panModel = [self.tableViewDataSource firstObject];
            NSArray *selectedStrs = [panModel.selectStrings componentsSeparatedByString:@" "];
            // 前六个任选的算法一致
            if (selectedPlayCategoryBtnIndex < 7) {
                    other = [self getBettingCountWithSelectedLength:selectedStrs.count baseCount:2 + selectedPlayCategoryBtnIndex];
                
            }else if([selectPlayName isEqualToString:@"前一"]){
                other =  selectedStrs.count;
            }else if([selectPlayName isEqualToString:@"前二组选"]){
                other =  [self getBettingCountWithSelectedLength:selectedStrs.count baseCount:2];
            }else if([selectPlayName isEqualToString:@"前三组选"]){
                other =  [self getBettingCountWithSelectedLength:selectedStrs.count baseCount:3];
            }
        }
        // 前二直选 前三直选的注数计算
        else{
            
            NSString *wanSelectedStr = [self.tableViewDataSource[0] selectStrings];
            NSString *qianSelectedStr = [self.tableViewDataSource[1] selectStrings];
            NSArray *wanSelectedArr = [wanSelectedStr componentsSeparatedByString:@" "];
            NSArray *qianSelectedArr = [qianSelectedStr componentsSeparatedByString:@" "];
            NSInteger wanSelectedCount = wanSelectedStr.length == 0 ? 0 : wanSelectedArr.count;
            NSInteger qianSelectedCount = qianSelectedStr.length == 0 ? 0 : qianSelectedArr.count;
            
            if([selectPlayName isEqualToString:@"前二直选"]){
                if (wanSelectedCount == 0 || qianSelectedCount == 0) {
                    other = 0;
                }else{
                    
                    NSInteger repeatCount = 0;
                    for (NSString *dmStr in wanSelectedArr) {
                        if ([qianSelectedArr containsObject:dmStr]) {
                            repeatCount++;
                        }
                    }
                    other = wanSelectedCount * qianSelectedCount - repeatCount;
                }
            }else if([selectPlayName isEqualToString:@"前三直选"]){
                NSString *baiSelectedStr = [self.tableViewDataSource[2] selectStrings];
                NSArray *baiSelectedArr = [baiSelectedStr componentsSeparatedByString:@" "];
                NSInteger baiSelectedCount = baiSelectedStr.length == 0 ? 0 : baiSelectedArr.count;
                
                
                if (wanSelectedCount == 0 || qianSelectedCount == 0 || baiSelectedCount == 0) {
                    other = 0;
                }else{
                    
                    NSInteger selectedCount = 0;
                    
                    for (NSString *wanStr in wanSelectedArr) {
                        for (NSString *qianStr in qianSelectedArr) {
                            for (NSString *baiStr in baiSelectedArr) {
                                if ([wanStr isEqualToString:qianStr]) {
                                    continue;
                                }
                                if ([wanStr isEqualToString:baiStr]) {
                                    continue;
                                }
                                if ([qianStr isEqualToString:baiStr]) {
                                    continue;
                                }
                                selectedCount++;
                            }
                        }
                    }
                    
                    other = selectedCount;
                }
            }
        }
    }
    //拖胆选取
    else{
        NSString *danMaSelectedStr = [[self.tableViewDataSource firstObject] selectStrings];
        NSString *tuoMaSelectedStr = [[self.tableViewDataSource lastObject] selectStrings];
        
        NSInteger danMaSelectedCount = danMaSelectedStr.length == 0 ? 0 : [[danMaSelectedStr componentsSeparatedByString:@" "] count];
        NSInteger tuoMaSelectedCount = tuoMaSelectedStr.length == 0 ? 0 : [[tuoMaSelectedStr componentsSeparatedByString:@" "] count];
        if (selectedPlayCategoryBtnIndex < 19) {
            other = [self getBettingCountWithDanMaCount:danMaSelectedCount TuoMaCount:tuoMaSelectedCount baseCount:selectedPlayCategoryBtnIndex - 10];
        }else if (selectedPlayCategoryBtnIndex == 19){
            other = [self getBettingCountWithDanMaCount:danMaSelectedCount TuoMaCount:tuoMaSelectedCount baseCount:2];
        }else if (selectedPlayCategoryBtnIndex == 20){
            other = [self getBettingCountWithDanMaCount:danMaSelectedCount TuoMaCount:tuoMaSelectedCount baseCount:3];
        }
    }
    return other;
}

#pragma mark - 普通玩法的注数计算方法
-(NSInteger)getBettingCountWithSelectedLength:(NSInteger)length baseCount:(NSInteger)baseCount{
    NSInteger temp = 1;
    for (NSInteger i = 0; i < baseCount; i++) {
        temp = temp * (length - i);
    }
    NSInteger result = temp / [self factorialFun:baseCount];
    return result;
}

#pragma mark - 胆拖玩法的注数计算方法
-(NSInteger)getBettingCountWithDanMaCount:(NSInteger)dmCount TuoMaCount:(NSInteger)tmCount baseCount:(NSInteger)baseCount{
    if (dmCount == 0) {
        return 0;
    }else{
        NSInteger temp = 1;
        for (NSInteger i = 0; i < (baseCount - dmCount); i++) {
            temp = temp * (tmCount - i);
        }
        NSInteger result = temp / [self factorialFun:(baseCount - dmCount)];
        return result;
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
    for (LotteryNumberPanModel *model in self.tableViewDataSource) {
        model.selectStrings = @"";
    }
    [self.elevenChooseFiveTableView reloadData];
    self.clearSelectBtn.enabled = NO;
    self.sureBtn.enabled = NO;
    self.selectedInfoLabel.text = @"";
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
            
            
            OrderCheckView *checkView = [[[NSBundle mainBundle] loadNibNamed:@"OrderCheckView" owner:nil options:nil] firstObject];//[[OrderCheckView alloc] init];
            checkView.frame = [UIScreen mainScreen].bounds;
            PlayCategory *category = self.elevenChooseFiveDataSource[self.selectedIndex];
            checkView.orderCheckDict = @{
                                         @"playedId":category.playedId,
                                         @"playedName":category.playedName,
                                         @"productId":self.lotteryType.productVo.productId,
                                         @"productName":self.lotteryType.productVo.name,
                                         @"periodName":self.lotteryType.periodVo.name,
                                         @"bettingContent":self.numbersForBettingList,
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

- (IBAction)historyInfoBtnClick:(id)sender {
    LotteryResultDetailViewController *resultDetail = [[LotteryResultDetailViewController alloc] init];
    resultDetail.result = self.lotteryType;
    resultDetail.hiddenBottomView = YES;
    [self.navigationController pushViewController:resultDetail animated:YES];
}
@end
