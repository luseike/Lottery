//
//  LotteryFastThreeViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/5/20.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "FastThreeViewController.h"
#import "NavigationTitleView.h"
#import "UIImage+ImageWithColor.h"
#import "NumberPanView.h"
#import "PlayCategoryBtn.h"
#import "MJExtension.h"
#import "PlayCategory.h"
#import "LotteryElevenChooseFiveNumberPanCell.h"
#import "LotteryNumberPanModel.h"
#import "HeZhiView.h"
#import "SanTongHaoView.h"
#import "SanBuTongHaoView.h"
#import "ErTongHaoView.h"
#import "ErBuTongHaoView.h"
#import "SanBuTongDanTuoView.h"
#import "ErBuTongDanTuoView.h"
#import "OrderCheckView.h"
#import "FaceViewController.h"
#import "PlayedVo.h"

@interface FastThreeViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *chooseView;
@property (nonatomic,strong) UIButton *maskBtnView;
@property (nonatomic,strong) NSArray *playedVos;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *playDescriptionLabel;
@property (nonatomic,copy) NSMutableString *playDescriptionStr;
@property (nonatomic,strong) NSMutableArray *playCategoryBtnsContainer;

@property(nonatomic,weak) PlayCategoryBtn *selectedPlayCategorybtn;    //记录选中的玩法按钮
@property (weak, nonatomic) IBOutlet UIButton *clearSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UILabel *playedVoLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UILabel *kjResultLabel;    //开奖结果
@property (weak, nonatomic) IBOutlet UIView *kjResultImgView;


@property(nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,copy) NSString *playedId;

@property(nonatomic,strong) HeZhiView *heZhiView;
@property(nonatomic,strong) SanTongHaoView *sanTongHaoView;
@property(nonatomic,strong) SanBuTongHaoView *sanBuTongHaoView;
@property (nonatomic,strong) ErTongHaoView *erTongHaoView;
@property (nonatomic,strong) ErBuTongHaoView *erBuTongHaoView;
@property (nonatomic,strong) SanBuTongDanTuoView *sanBuTongDanTuoView;
@property (nonatomic,strong) ErBuTongDanTuoView *erBuTongDanTuoView;
@property (weak, nonatomic) IBOutlet UILabel *closingDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *closingInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *multipleField;
@property (weak, nonatomic) IBOutlet UIButton *modelBtn;
@property (nonatomic,strong) UIButton *maskBtn;

/**
 *  倒计时剩余秒数
 */
@property(nonatomic,assign) NSInteger kuai3RetainSecond;
/**
 *  当前选中的注数
 */
@property(nonatomic,assign) NSUInteger bettingCount;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,copy) NSString *selectedContent;
@end

@implementation FastThreeViewController

-(NSMutableArray *)playCategoryBtnsContainer{
    if (!_playCategoryBtnsContainer) {
        _playCategoryBtnsContainer = [NSMutableArray array];
    }
    return _playCategoryBtnsContainer;
}
-(NSArray *)playedVos{
    if (!_playedVos) {
        _playedVos = [NSArray array];
    }
    return _playedVos;
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
            
            NSArray *periodsArr = [[responseObject valueForKey:@"result"] valueForKey:@"periods"];
            PeriodVo *lastPeriod = [PeriodVo mj_objectWithKeyValues:[periodsArr firstObject]];
            NSLog(@"%@",lastPeriod.name);
            //如果该彩种停止销售，倒计时不开启，显示时间做特殊处理
            if (product.state == 1) {
                self.closingInfoLabel.text = @"距**期截止:";
                self.closingDateLabel.text = @"--:--";
            }else{
                NSDate *nowDate = [NSDate getDateFromDateString:[[responseObject valueForKey:@"result"] valueForKey:@"now"]];
                NSDictionary *dict = [responseObject valueForKey:@"result"];
                PeriodVo *period = [PeriodVo mj_objectWithKeyValues:[dict valueForKey:@"period"]];
                self.lotteryType.periodVo = period;
                NSDate *endDate = [NSDate getDateFromDateString:period.timeEnd];
                self.kuai3RetainSecond = [endDate timeIntervalSinceReferenceDate] - [nowDate timeIntervalSinceReferenceDate];
                if (self.timer) {
                    //计时器存在，说明上一期次已结束
                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"期次已切换，当前是%@期",self.lotteryType.periodVo.name]];
                }
                // 开启定时器，开始倒计时
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setCloseDateLabelText:) userInfo:nil repeats:YES];
                
                
                
                
                
                
                NSString *periodName = lastPeriod.name;
                NSString *kjNum = lastPeriod.kjNum;
                if (kjNum.length != 0) {
                    UILabel *kjTapLabel = [self.topView viewWithTag:10];
                    if (kjTapLabel) {
                        [kjTapLabel removeFromSuperview];
                    }
                    
                    self.kjResultLabel.text = [NSString stringWithFormat:@"%@期开奖",[periodName substringFromIndex:periodName.length - 2]];
                    
                    NSArray *kjNumArr = [kjNum componentsSeparatedByString:@" "];
                    for (NSInteger i = 0; i < kjNumArr.count; i++) {
                        NSString *currentStr = kjNumArr[i];
                        UIImageView *imgView = self.kjResultImgView.subviews[i];
                        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"kuai3_%@",currentStr]];
                    }
                    
                }else{
                    
                    self.kjResultLabel.text = [NSString stringWithFormat:@"%@期开奖中……", periodName.length > 0 ? [periodName substringFromIndex:periodName.length - 2] : @"**"];
                    UILabel *kjTipLabel = [[UILabel alloc] initWithFrame:self.kjResultImgView.frame];
                    kjTipLabel.width = KScreenWidth * 0.5;
                    kjTipLabel.x = 0;
                    kjTipLabel.backgroundColor = [UIColor whiteColor];
                    kjTipLabel.tag = 10;
                    kjTipLabel.text = @"等待开奖";
                    kjTipLabel.textColor = [UIColor greenColor];
                    kjTipLabel.textAlignment = NSTextAlignmentCenter;
                    [self.topView addSubview:kjTipLabel];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}
-(void)setCloseDateLabelText:(NSTimer *)timer{
    NSInteger currentSecond = --self.kuai3RetainSecond;
    NSInteger mimute = currentSecond / 60;
    NSInteger second = currentSecond % 60;
    NSString *retainTime = [NSString stringWithFormat:@"%02ld:%02ld",(long)mimute,(long)second];
    self.closingDateLabel.text = retainTime;
    
    self.closingInfoLabel.text = [NSString stringWithFormat:@"距%@期截止：",[self.lotteryType.periodVo.name substringFromIndex:self.lotteryType.periodVo.name.length - 2]];
    
    if (self.kuai3RetainSecond == 0) {
        [timer invalidate];
        timer = nil;
        [self getRetainSeconds];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBettingCountWithNotification:) name:@"HeZhiNumberViewClickNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBettingCountWithNotification:) name:@"SanTongHaoNumberViewClickNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBettingCountWithNotification:) name:@"SanBuTongHaoNumberViewClickNotification" object:nil];
    // 二同号传过来的数字  先用空格分割不同的组  在用逗号分割组内不同的数字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBettingCountWithNotification:) name:@"ErTongHaoNumberViewClickNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBettingCountWithNotification:) name:@"ErBuTongHaoNumberViewClickNotification" object:nil];
    // 三不同号胆拖
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBettingCountWithNotification:) name:@"SanBuTongDanTuoNumberViewClickNotification" object:nil];
    // 三不同号胆拖
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBettingCountWithNotification:) name:@"ErBuTongDanTuoNumberViewClickNotification" object:nil];
    
}

#pragma mark - 初始化一些样式，添加导航按钮
-(void)setupView{
    self.clearSelectBtn.enabled = NO;
    self.clearSelectBtn.layer.cornerRadius = 5;
    self.clearSelectBtn.layer.masksToBounds = YES;
    self.sureBtn.enabled = NO;
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    
//    NSString *periodName = self.lotteryType.periodVo.name;
//    NSString *kjNum = self.lotteryType.periodVo.kjNum;
//    if (kjNum.length != 0) {
//        UILabel *kjTapLabel = [self.topView viewWithTag:10];
//        if (kjTapLabel) {
//            [kjTapLabel removeFromSuperview];
//        }
//        
//        self.kjResultLabel.text = [NSString stringWithFormat:@"%@期开奖",[periodName substringFromIndex:periodName.length - 2]];
//        
//        NSArray *kjNumArr = [kjNum componentsSeparatedByString:@" "];
//        for (NSInteger i = 0; i < kjNumArr.count - 1; i++) {
//            NSString *currentStr = kjNumArr[i];
//            UIImageView *imgView = self.kjResultImgView.subviews[i];
//            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"kuai3_%@",currentStr]];
//        }
//        
//    }else{
//        
//        self.kjResultLabel.text = [NSString stringWithFormat:@"%@期开奖中……", periodName.length > 0 ? [periodName substringFromIndex:periodName.length - 2] : @"**"];
//        UILabel *kjTipLabel = [[UILabel alloc] initWithFrame:self.kjResultImgView.frame];
//        kjTipLabel.width = KScreenWidth * 0.5;
//        kjTipLabel.x = 0;
//        kjTipLabel.backgroundColor = [UIColor whiteColor];
//        kjTipLabel.tag = 10;
//        kjTipLabel.text = @"等待开奖";
//        kjTipLabel.textColor = [UIColor greenColor];
//        kjTipLabel.textAlignment = NSTextAlignmentCenter;
//        [self.topView addSubview:kjTipLabel];
//    }
    
    
    NavigationTitleView *titleView = [[NavigationTitleView alloc] init];
    [titleView addTarget:self action:@selector(titleViewClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    
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
            self.selectedInfoLabel.text = self.bettingCount > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",(unsigned long)self.bettingCount,@(bettingMoney)] : @"";
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
    for (NSInteger i = 0; i < 5; i++) {
        PlayCategoryBtn *playCategorybtn = [PlayCategoryBtn buttonWithType:UIButtonTypeCustom];
        switch (i) {
            case 0:
                [playCategorybtn setTitle:@"和值" forState:UIControlStateNormal];
                break;
            case 1:
                [playCategorybtn setTitle:@"三同号" forState:UIControlStateNormal];
                break;
            case 2:
                [playCategorybtn setTitle:@"三不同号" forState:UIControlStateNormal];
                break;
            case 3:
                [playCategorybtn setTitle:@"二同号" forState:UIControlStateNormal];
                break;
            case 4:
                [playCategorybtn setTitle:@"二不同号" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        playCategorybtn.titleLabel.font = [UIFont systemFontOfSize:12];
        playCategorybtn.layer.borderColor = RGB(234, 234, 234).CGColor;
        playCategorybtn.layer.borderWidth = 1.0;
        [playCategorybtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [playCategorybtn setBackgroundImage:[UIImage imageWithColor:RGB(247, 180, 91)] forState:UIControlStateSelected];
        [playCategorybtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        [playCategorybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [playCategorybtn addTarget:self action:@selector(chooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        playCategorybtn.frame = CGRectMake((shopViewW + columnMargin) * column + columnMargin, columnMargin + (shopViewH + columnMargin) * row + CGRectGetMaxY(normalLabel.frame),shopViewW, shopViewH);
        [self.playCategoryBtnsContainer addObject:playCategorybtn];
        [chooseView addSubview:playCategorybtn];
        if (i == 0) {
            [self chooseBtnClicked:playCategorybtn];
        }
        if (i == 4) {
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
    
    
    for (NSInteger i = 0; i < 2; i++) {
        PlayCategoryBtn *playCategorybtn = [PlayCategoryBtn buttonWithType:UIButtonTypeCustom];
        switch (i) {
            case 0:
                [playCategorybtn setTitle:@"三不同号" forState:UIControlStateNormal];
                break;
            case 1:
                [playCategorybtn setTitle:@"二不同号" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        playCategorybtn.titleLabel.font = [UIFont systemFontOfSize:12];
        playCategorybtn.layer.borderColor = RGB(234, 234, 234).CGColor;
        playCategorybtn.layer.borderWidth = 1.0;
        [playCategorybtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [playCategorybtn setBackgroundImage:[UIImage imageWithColor:RGB(247, 180, 91)] forState:UIControlStateSelected];
        [playCategorybtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        [playCategorybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [playCategorybtn addTarget:self action:@selector(chooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        playCategorybtn.frame = CGRectMake((shopViewW + columnMargin) * column + columnMargin, (shopViewH + columnMargin) * row + CGRectGetMaxY(dantuoLabel.frame) + columnMargin,shopViewW, shopViewH);
        [self.playCategoryBtnsContainer addObject:playCategorybtn];
        [chooseView addSubview:playCategorybtn];
        if (i == 1) {
            chooseView.height = CGRectGetMaxY(playCategorybtn.frame) + columnMargin;
        }
    }
    
    
    chooseView.width = KScreenWidth;
    chooseView.x = 0;
    chooseView.y = -chooseView.height;
    [self.view addSubview:chooseView];
    self.chooseView = chooseView;
}


-(void)getBettingCountWithNotification:(NSNotification *)nofi{
    [self setSelectedInfoLabelContentWithSelectedNumbers];
}

#pragma mark - 根据选择的数字，计算注数（需要从navigatioTitle上得知选择的是那种玩法）
-(void)setSelectedInfoLabelContentWithSelectedNumbers{
    NSUInteger selectedCount = 0;
    if (self.selectedIndex == 0 || self.selectedIndex == 1) {
        NSString *selectedNumbers = self.selectedIndex == 0 ? self.heZhiView.selectedNumbers : self.sanTongHaoView.selectedNumbers;
        
        self.selectedContent = [selectedNumbers stringByReplacingOccurrencesOfString:@" " withString:@","];
        if (selectedNumbers.length > 0) {
            self.clearSelectBtn.enabled = YES;
            NSArray *selectedArr = [selectedNumbers componentsSeparatedByString:@" "];
            selectedCount = selectedArr.count;
        }else{
            self.clearSelectBtn.enabled = NO;
        }
        
        
        
        if (self.selectedIndex == 0) {
            self.playedId = @"k3_sum";
        }else{
            if ([selectedNumbers containsString:@"三同号通选"]) {
                self.playedId = @"k3_3t";
            }else{
                self.playedId = @"k3_3td";
            }
        }
    }else if (self.selectedIndex == 2) {
        //三不同号，判断有没有选择“三连号通选”，只要选择了“三连号通选”就计一注
        NSArray *selectedArr = nil;
        NSString *selectedNumbers = self.sanBuTongHaoView.selectedNumbers;
        self.selectedContent = selectedNumbers;
        if (selectedNumbers.length > 0) {
            self.clearSelectBtn.enabled = YES;
            if ([selectedNumbers containsString:@"三连号通选"]) {
                selectedCount++;
                NSString *newSelectedNumbers = [NSString deleteObjStr:@"三连号通选" fromSelectedStr:selectedNumbers];
                selectedArr = [newSelectedNumbers componentsSeparatedByString:@" "];
            }else{
                selectedArr = [selectedNumbers componentsSeparatedByString:@" "];
            }
            if (selectedArr.count >= 3) {
                NSUInteger selectedLength = selectedArr.count;
                selectedCount = selectedCount + selectedLength *(selectedLength - 1)*(selectedLength - 2)/6;
            }
        }else{
            self.clearSelectBtn.enabled = NO;
        }
        
        
        
        if ([selectedNumbers containsString:@"三连号通选"]) {
            self.playedId = @"k3_3lt";
        }else{
            self.playedId = @"k3_3b";
        }
        
        
    }else if (self.selectedIndex == 3){
        //二同号
        if (self.erTongHaoView.fuXuanSelectedNumbers.length > 0) {
            selectedCount = [[self.erTongHaoView.fuXuanSelectedNumbers componentsSeparatedByString:@" "] count];
            self.selectedContent = [self.erTongHaoView.fuXuanSelectedNumbers stringByReplacingOccurrencesOfString:@" " withString:@","];
        }
        if (self.erTongHaoView.tongHaoSelectedNumbers.length > 0 && self.erTongHaoView.buTongHaoSelectedNumbers.length > 0) {
            NSArray *tongHaoArr = [self.erTongHaoView.tongHaoSelectedNumbers componentsSeparatedByString:@" "];
            NSArray *butongHaoArr = [self.erTongHaoView.buTongHaoSelectedNumbers componentsSeparatedByString:@" "];
            selectedCount = tongHaoArr.count * butongHaoArr.count + selectedCount;
            
            if (self.erTongHaoView.fuXuanSelectedNumbers.length > 0) {
                self.selectedContent = [NSString stringWithFormat:@"%@#%@ %@",self.erTongHaoView.tongHaoSelectedNumbers,self.erTongHaoView.buTongHaoSelectedNumbers,[self.erTongHaoView.fuXuanSelectedNumbers stringByReplacingOccurrencesOfString:@" " withString:@","]];
            }else{
                self.selectedContent = [NSString stringWithFormat:@"%@#%@",self.erTongHaoView.tongHaoSelectedNumbers,self.erTongHaoView.buTongHaoSelectedNumbers];
            }
        }
        if (self.erTongHaoView.tongHaoSelectedNumbers.length > 0 || self.erTongHaoView.buTongHaoSelectedNumbers.length > 0 || self.erTongHaoView.fuXuanSelectedNumbers.length > 0) {
            self.clearSelectBtn.enabled = YES;
        }else{
            self.clearSelectBtn.enabled = NO;
        }
        
        if (self.erTongHaoView.fuXuanSelectedNumbers.length > 0) {
            self.playedId = @"k3_2tf";
        }else{
            self.playedId = @"k3_2td";
        }
    }else if (self.selectedIndex == 4){
        //二不同号
        NSArray *selectedArr = [self.erBuTongHaoView.selectedNumbers componentsSeparatedByString:@" "];
        if (selectedArr.count > 1) {
            selectedCount = selectedArr.count*(selectedArr.count - 1) / 2;
        }
        if (self.erBuTongHaoView.selectedNumbers.length > 0) {
            self.clearSelectBtn.enabled = YES;
        }else{
            self.clearSelectBtn.enabled = NO;
        }
        self.selectedContent = self.erBuTongHaoView.selectedNumbers;
        
        self.playedId = @"k3_2b";
    }else if (self.selectedIndex == 5){
        // 三不同号  胆拖
        // 当选2个胆码，选了n个拖码（n>=1），会形成n注 ；当选了1个胆码，n个拖码（n>=2），会形成n*(n-1)/2!注。
        if (self.sanBuTongDanTuoView.danMaSelectedNumbers.length > 0 && self.sanBuTongDanTuoView.tuoMaSelectedNumbers.length > 0) {
            NSArray *danMaArr = [self.sanBuTongDanTuoView.danMaSelectedNumbers componentsSeparatedByString:@" "];
            NSArray *tuoMaArr = [self.sanBuTongDanTuoView.tuoMaSelectedNumbers componentsSeparatedByString:@" "];
            if (danMaArr.count == 1) {
                if (tuoMaArr.count >= 2) {
                    selectedCount = tuoMaArr.count * (tuoMaArr.count - 1) / 2;
                }
            }else{
                if (tuoMaArr.count >= 1) {
                    selectedCount = tuoMaArr.count;
                }
            }
        }
        if (self.sanBuTongDanTuoView.danMaSelectedNumbers.length > 0 || self.sanBuTongDanTuoView.tuoMaSelectedNumbers.length > 0) {
            self.clearSelectBtn.enabled = YES;
        }else{
            self.clearSelectBtn.enabled = NO;
        }
        self.selectedContent = [NSString stringWithFormat:@"(%@)%@",self.sanBuTongDanTuoView.danMaSelectedNumbers,self.sanBuTongDanTuoView.tuoMaSelectedNumbers];
        
        self.playedId = @"k3_3b";
    }else if (self.selectedIndex == 6){
        // 二不同号  胆拖
        
        if (self.erBuTongDanTuoView.danMaSelectedNumbers.length > 0 || self.erBuTongDanTuoView.tuoMaSelectedNumbers.length > 0) {
            self.clearSelectBtn.enabled = YES;
            
            // 二不同号的 1个胆码，n个拖码（n>=2），会形成n注
            if (self.erBuTongDanTuoView.danMaSelectedNumbers.length > 0 && self.erBuTongDanTuoView.tuoMaSelectedNumbers.length > 0) {
                NSArray *danMaArr = [self.erBuTongDanTuoView.danMaSelectedNumbers componentsSeparatedByString:@" "];
                NSArray *tuoMaArr = [self.erBuTongDanTuoView.tuoMaSelectedNumbers componentsSeparatedByString:@" "];
                if (danMaArr.count == 1) {
                    if (tuoMaArr.count >= 1) {
                        selectedCount = tuoMaArr.count;
                    }
                }
            }
        }else{
            self.clearSelectBtn.enabled = NO;
        }
        self.selectedContent = [NSString stringWithFormat:@"(%@)%@",self.erBuTongDanTuoView.danMaSelectedNumbers,self.erBuTongDanTuoView.tuoMaSelectedNumbers];
        self.playedId = @"k3_2b";
    }
    
    self.bettingCount = selectedCount;
    self.sureBtn.enabled = selectedCount > 0;
    
    if (self.clearSelectBtn.enabled) {
        NSInteger mul = [self.multipleField.text integerValue];
        NSString *model = self.modelBtn.currentTitle;
        float bettingMoney = 1;
        if ([model isEqualToString:@"角"]) {
            bettingMoney = selectedCount * 2 * mul * 0.1;
        }else if ([model isEqualToString:@"分"]){
            bettingMoney = selectedCount * 2 * mul * 0.01;
        }else{
            bettingMoney = selectedCount * 2 * mul;
        }
        self.selectedInfoLabel.text = selectedCount > 0 ? [NSString stringWithFormat:@"共%zd注 %@元",(unsigned long)selectedCount,@(bettingMoney)] : @"";
        
        
        // 设置返点和赔率的值
        if (self.playedVos.count != 0) {
            for (PlayedVo *playedVo in self.playedVos) {
                if ([playedVo.playedId isEqualToString:self.playedId]) {
                    VipVo *vip = KGetVip;
                    self.playedVoLabel.text = [NSString stringWithFormat:@"%.2f-%.2f%%",playedVo.jiang,vip.fdPst];
                }
            }
        }
        
        
    }else{
        self.selectedInfoLabel.text = @"";
    }
}



#pragma mark - 选择不同的玩法，触发的事件
-(void)chooseBtnClicked:(PlayCategoryBtn *)btn{
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
        
        if (index > 4) {
            [titleBtn setTitle:[NSString stringWithFormat:@"%@胆拖",btn.currentTitle] forState:UIControlStateNormal];
        }else{
            [titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
        }
        self.chooseView.y = -self.chooseView.height;
        [titleBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        // 修改玩法说明文案
        [self setupSubViewsWithPlayBtnIndex:index];
        
    } completion:^(BOOL finished) {
        [self.maskBtnView removeFromSuperview];
    }];
}



#pragma mark - 根据不同的玩法选择，画不同的画面
-(void)setupSubViewsWithPlayBtnIndex:(NSUInteger)index{
    switch (index) {
        case 0:
            [self setupHeZhiViews];
            break;
        case 1:
            [self setupSanTongHaoView];
            break;
        case 2:
            [self setupHeSanBuTongHaoView];
            break;
        case 3:
            [self setupErTongHaoView];
            break;
        case 4:
            [self setupErBuTongHaoView];
            break;
        case 5:
            [self setupSanBuTongDanTuoView];
            break;
        case 6:
            [self setupErBuTongDanTuoView];
            break;
        default:
            break;
    }
}

-(void)setupErBuTongDanTuoView{
    if (self.erBuTongDanTuoView) {
        [self.centerView bringSubviewToFront:self.erBuTongDanTuoView];
    }else{
        ErBuTongDanTuoView *erBuTongDanTuoView = [[[NSBundle mainBundle] loadNibNamed:@"ErBuTongDanTuoView" owner:nil options:nil] firstObject];
        erBuTongDanTuoView.frame = self.centerView.frame;
        erBuTongDanTuoView.y = 0;
        self.erBuTongDanTuoView = erBuTongDanTuoView;
        [self.centerView addSubview:erBuTongDanTuoView];
    }
    [self setSelectedInfoLabelContentWithSelectedNumbers];
}

-(void)setupSanBuTongDanTuoView{
    if (self.sanBuTongDanTuoView) {
        [self.centerView bringSubviewToFront:self.sanBuTongDanTuoView];
    }else{
        SanBuTongDanTuoView *sanBuTongDanTuoView = [[[NSBundle mainBundle] loadNibNamed:@"SanBuTongDanTuoView" owner:nil options:nil] firstObject];
        sanBuTongDanTuoView.frame = self.centerView.frame;
        sanBuTongDanTuoView.y = 0;
        self.sanBuTongDanTuoView = sanBuTongDanTuoView;
        [self.centerView addSubview:sanBuTongDanTuoView];
    }
    [self setSelectedInfoLabelContentWithSelectedNumbers];
}
-(void)setupErBuTongHaoView{
    if (self.erBuTongHaoView) {
        [self.centerView bringSubviewToFront:self.erBuTongHaoView];
    }else{
        ErBuTongHaoView *erBuTongHaoView = [[[NSBundle mainBundle] loadNibNamed:@"ErBuTongHaoView" owner:nil options:nil] firstObject];
        erBuTongHaoView.frame = self.centerView.frame;
        erBuTongHaoView.y = 0;
        self.erBuTongHaoView = erBuTongHaoView;
        [self.centerView addSubview:erBuTongHaoView];
    }
    [self setSelectedInfoLabelContentWithSelectedNumbers];
}

-(void)setupErTongHaoView{
    if (self.erTongHaoView) {
        [self.centerView bringSubviewToFront:self.erTongHaoView];
    }else{
        ErTongHaoView *erTongHaoView = [[[NSBundle mainBundle] loadNibNamed:@"ErTongHaoView" owner:nil options:nil] firstObject];
        erTongHaoView.frame = self.centerView.frame;
        erTongHaoView.y = 0;
        self.erTongHaoView = erTongHaoView;
        [self.centerView addSubview:erTongHaoView];
    }
    [self setSelectedInfoLabelContentWithSelectedNumbers];
}

-(void)setupHeSanBuTongHaoView{
    if (self.sanBuTongHaoView) {
        [self.centerView bringSubviewToFront:self.sanBuTongHaoView];
    }else{
        SanBuTongHaoView *sanBuTongHaoView = [[[NSBundle mainBundle] loadNibNamed:@"SanBuTongHaoView" owner:nil options:nil] firstObject];
        sanBuTongHaoView.frame = self.centerView.frame;
        sanBuTongHaoView.y = 0;
        self.sanBuTongHaoView = sanBuTongHaoView;
        [self.centerView addSubview:sanBuTongHaoView];
    }
    [self setSelectedInfoLabelContentWithSelectedNumbers];
}
-(void)setupSanTongHaoView{
    if (self.sanTongHaoView) {
        [self.centerView bringSubviewToFront:self.sanTongHaoView];
    }else{
        SanTongHaoView *sanTongHaoView = [[[NSBundle mainBundle] loadNibNamed:@"SanTongHaoView" owner:nil options:nil] firstObject];
        sanTongHaoView.dataArr = @[
                              @{@"number":@"111",@"bounds":@"240"},
                              @{@"number":@"222",@"bounds":@"240"},
                              @{@"number":@"333",@"bounds":@"240"},
                              @{@"number":@"444",@"bounds":@"240"},
                              @{@"number":@"555",@"bounds":@"240"},
                              @{@"number":@"666",@"bounds":@"240"},
                              @{@"number":@"三同号通选",@"bounds":@"40"}
                              ];
        sanTongHaoView.frame = self.centerView.frame;
        sanTongHaoView.y = 0;
        self.sanTongHaoView = sanTongHaoView;
        [self.centerView addSubview:sanTongHaoView];
    }
    [self setSelectedInfoLabelContentWithSelectedNumbers];
}
-(void)setupHeZhiViews{
    if (self.heZhiView) {
        [self.centerView bringSubviewToFront:self.heZhiView];
    }else{
        HeZhiView *hezhiView = [[[NSBundle mainBundle] loadNibNamed:@"HeZhiView" owner:nil options:nil] firstObject];
        hezhiView.dataArr = @[
                              @{@"number":@"3",@"bounds":@"240"},
                              @{@"number":@"4",@"bounds":@"80"},
                              @{@"number":@"5",@"bounds":@"40"},
                              @{@"number":@"6",@"bounds":@"25"},
                              @{@"number":@"7",@"bounds":@"16"},
                              @{@"number":@"8",@"bounds":@"12"},
                              @{@"number":@"9",@"bounds":@"10"},
                              @{@"number":@"10",@"bounds":@"9"},
                              @{@"number":@"11",@"bounds":@"9"},
                              @{@"number":@"12",@"bounds":@"10"},
                              @{@"number":@"13",@"bounds":@"12"},
                              @{@"number":@"14",@"bounds":@"16"},
                              @{@"number":@"15",@"bounds":@"25"},
                              @{@"number":@"16",@"bounds":@"40"},
                              @{@"number":@"17",@"bounds":@"80"},
                              @{@"number":@"18",@"bounds":@"240"}
                              ];
        hezhiView.frame = self.centerView.frame;
        hezhiView.y = 0;
        [self.centerView addSubview:hezhiView];
        self.heZhiView = hezhiView;
    }
    [self setSelectedInfoLabelContentWithSelectedNumbers];
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
    switch (self.selectedIndex) {
        case 0:
            [self.heZhiView clearAllSelected];
            break;
        case 1:
            [self.sanTongHaoView clearAllSelected];
            break;
        case 2:
            [self.sanBuTongHaoView clearAllSelected];
            break;
        case 3:
            [self.erTongHaoView clearAllSelected];
            break;
        case 4:
            [self.erBuTongHaoView clearAllSelected];
            break;
        case 5:
            [self.sanBuTongDanTuoView clearAllSelected];
            break;
        case 6:
            [self.erBuTongDanTuoView clearAllSelected];
            break;
        default:
            break;
    }
//    for (LotteryNumberPanModel *model in self.tableViewDataSource) {
//        model.selectStrings = @"";
//    }
    self.clearSelectBtn.enabled = NO;
    self.sureBtn.enabled = NO;
    self.selectedInfoLabel.text = @"";
    [self setSelectedInfoLabelContentWithSelectedNumbers];
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
            NSString *modelStr = @"1";
            if ([model isEqualToString:@"角"]) {
                modelF = 0.1;
                modelStr = @"10";
            }else if ([model isEqualToString:@"分"]){
                modelF = 0.01;
                modelStr = @"100";
            }
            //投注金额
            NSString *amount = [NSString stringWithFormat:@"%@",@(self.bettingCount * 2 * mul * modelF)];
            
            NSMutableDictionary *orderCheckDict = [NSMutableDictionary dictionaryWithObjects:
                                                   @[
                                                     self.lotteryType.productVo.name,
                                                     self.lotteryType.periodVo.name,
                                                     self.selectedContent,
                                                     [NSString stringWithFormat:@"%zd",self.bettingCount],
                                                     amount,
                                                     self.multipleField.text,
                                                     self.lotteryType.productVo.productId,
                                                     model
                                                     ] forKeys:
                                                   @[
                                                     @"productName",
                                                     @"periodName",
                                                     @"bettingContent",
                                                     @"bettingCount",
                                                     @"bettingMoney",
                                                     @"multiple",
                                                     @"productId",
                                                     @"model"
                                                     ]];
            
            NSMutableDictionary *baseDict = [NSMutableDictionary dictionaryWithObjects:
                                             @[
                                               amount,
                                               self.lotteryType.periodVo.name,
                                               self.lotteryType.productVo.productId
                                               ] forKeys:
                                             @[
                                               @"jg",
                                               @"period",
                                               @"productId"
                                               ]];
            
            if (self.selectedIndex == 0) {
                
                [baseDict setObject:@[
                                      @{
                                          @"playedId":@"k3_sum",
                                          @"playedName":@"和值",
                                          @"data":self.selectedContent,
                                          @"num":@(self.bettingCount),
                                          @"jg":amount,
                                          @"beis":self.multipleField.text,
                                          @"unit":modelStr
                                          }
                                      ] forKey:@"dataList"];
            }else if (self.selectedIndex == 4 || self.selectedIndex == 6){  // 二不同号
                [baseDict setObject:@[
                                      @{
                                          @"playedId":@"k3_2b",
                                          @"playedName":@"二不同号",
                                          @"data":self.selectedContent,
                                          @"num":@(self.bettingCount),
                                          @"jg":amount,
                                          @"beis":self.multipleField.text,
                                          @"unit":modelStr
                                          }
                                      ] forKey:@"dataList"];
            }else if (self.selectedIndex == 5){  // 三不同号
                [baseDict setObject:@[
                                      @{
                                          @"playedId":@"k3_3b",
                                          @"playedName":@"三不同号",
                                          @"data":self.selectedContent,
                                          @"num":@(self.bettingCount),
                                          @"jg":amount,
                                          @"beis":self.multipleField.text,
                                          @"unit":modelStr
                                          }
                                      ] forKey:@"dataList"];
            }else if (self.selectedIndex == 1){     //三同号
                NSLog(@"%@",self.sanTongHaoView.selectedNumbers);
                NSString *selectNumbers = self.sanTongHaoView.selectedNumbers;
                NSArray *selectNumArr = [selectNumbers componentsSeparatedByString:@" "];
                NSMutableArray *dataDict = [NSMutableArray array];
                for (NSString *numberStr in selectNumArr) {
                    [dataDict addObject:@{
                                          @"playedId":[numberStr containsString:@"三同号通选"] ? @"k3_3t" : @"k3_3td",
                                          @"playedName":[numberStr containsString:@"三同号通选"] ? @"三同号通选" : @"三同号单选",
                                          @"data":numberStr,
                                          @"num":@(1),
                                          @"jg":@(1 * modelF * 2),
                                          @"beis":self.multipleField.text,
                                          @"unit":modelStr
                                          }];
                }
                [baseDict setObject:dataDict forKey:@"dataList"];
            }else if (self.selectedIndex == 2){     //三不同号
                
                NSMutableArray *dataDict = [NSMutableArray array];
                NSString *selectNumbers = self.sanBuTongHaoView.selectedNumbers;
                NSArray *selectNumArr = [selectNumbers componentsSeparatedByString:@" "];
                
                if ([selectNumArr containsObject:@"三连号通选"]) {
                    if (selectNumArr.count > 3) {
                        // 不同号和通号都选的情况( 1 3 5|三连号通选 )
                        NSString *dataStr = @"";
                        NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:selectNumArr];
                        [mutableArr removeObject:@"三连号通选"];
                        dataStr = [mutableArr componentsJoinedByString:@" "];
                        
                        [dataDict addObject:@{
                                              @"playedId":@"k3_3lt",
                                              @"playedName":@"三连号通选",
                                              @"data":@"三连号通选",
                                              @"num":@(1),
                                              @"jg":@(1 * modelF * 2),
                                              @"beis":self.multipleField.text,
                                              @"unit":modelStr
                                              }];
                        [dataDict addObject:@{
                                              @"playedId":@"k3_3b",
                                              @"playedName":@"三不同号",
                                              @"data":dataStr,
                                              @"num":@(self.bettingCount - 1),
                                              @"jg":@((self.bettingCount - 1) * modelF * 2),
                                              @"beis":self.multipleField.text,
                                              @"unit":modelStr
                                              }];
                    }else{
                        [dataDict addObject:@{
                                              @"playedId":@"k3_3lt",
                                              @"playedName":@"三连号通选",
                                              @"data":@"三连号通选",
                                              @"num":@(1),
                                              @"jg":@(1 * modelF * 2),
                                              @"beis":self.multipleField.text,
                                              @"unit":modelStr
                                              }];
                        
                        
                        [orderCheckDict setValue:@"三连号通选" forKey:@"bettingContent"];
                    }
                }else{
                    [dataDict addObject:@{
                                          @"playedId":@"k3_3b",
                                          @"playedName":@"三不同号",
                                          @"data":[selectNumbers stringByReplacingOccurrencesOfString:@" " withString:@" "],
                                          @"num":@(self.bettingCount),
                                          @"jg":@(self.bettingCount * modelF * 2),
                                          @"beis":self.multipleField.text,
                                          @"unit":modelStr
                                          }];
                }
                [baseDict setObject:dataDict forKey:@"dataList"];
            }else{      //二同号
                NSString *fuxuanSelectNumbers = self.erTongHaoView.fuXuanSelectedNumbers;
                NSString *tongHaoSelectNumbers = self.erTongHaoView.tongHaoSelectedNumbers;
                NSString *buTongHaoSelectNumbers = self.erTongHaoView.buTongHaoSelectedNumbers;
                NSArray *fuXuanSelectArr = [fuxuanSelectNumbers componentsSeparatedByString:@" "];
                if (tongHaoSelectNumbers.length > 0 && fuxuanSelectNumbers.length > 0) {
                    // 都有
                    [baseDict setObject:@[
                                          @{
                                              @"playedId":@"k3_2td",
                                              @"playedName":@"二同号单选",
                                              @"data":[NSString stringWithFormat:@"%@#%@",tongHaoSelectNumbers, buTongHaoSelectNumbers], //11 22 33#4 5 6
                                              @"num":@(self.bettingCount - fuXuanSelectArr.count),
                                              @"jg":@((self.bettingCount - fuXuanSelectArr.count) * modelF * 2),
                                              @"beis":self.multipleField.text,
                                              @"unit":modelStr
                                              },
                                          @{
                                              @"playedId":@"k3_2tf",
                                              @"playedName":@"二同号复选",
                                              @"data":[fuxuanSelectNumbers stringByReplacingOccurrencesOfString:@" " withString:@","],
                                              @"num":@(fuXuanSelectArr.count),
                                              @"jg":@(fuXuanSelectArr.count * modelF * 2),
                                              @"beis":self.multipleField.text,
                                              @"unit":modelStr
                                              }
                                          ] forKey:@"dataList"];
                }else if (fuxuanSelectNumbers.length > 0){
                    //只有复选
                    [baseDict setObject:@[
                                          @{
                                              @"playedId":@"k3_2tf",
                                              @"playedName":@"二同号复选",
                                              @"data":[fuxuanSelectNumbers stringByReplacingOccurrencesOfString:@" " withString:@","],
                                              @"num":@(fuXuanSelectArr.count),
                                              @"jg":@(fuXuanSelectArr.count * modelF * 2),
                                              @"beis":self.multipleField.text,
                                              @"unit":modelStr
                                              }
                                          ] forKey:@"dataList"];
                }else{
                    //只有单选
                    [baseDict setObject:@[
                                          @{
                                              @"playedId":@"k3_2td",
                                              @"playedName":@"二同号单选",
                                              @"data":[NSString stringWithFormat:@"%@#%@",tongHaoSelectNumbers, buTongHaoSelectNumbers], //11 22 33#4 5 6
                                              @"num":@(self.bettingCount),
                                              @"jg":@(self.bettingCount * modelF * 2),
                                              @"beis":self.multipleField.text,
                                              @"unit":modelStr
                                              }
                                          ] forKey:@"dataList"];
                }
            }
            OrderCheckView *checkView = [[[NSBundle mainBundle] loadNibNamed:@"OrderCheckView" owner:nil options:nil] firstObject];
            checkView.frame = [UIScreen mainScreen].bounds;
            
            checkView.orderCheckDict = orderCheckDict;
            checkView.kuaiSanDictParam = baseDict;
            checkView.isKuaiSan = YES;
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
