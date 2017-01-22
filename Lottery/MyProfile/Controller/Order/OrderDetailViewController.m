//
//  OrderDetailViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/6/15.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderVo.h"
#import "OrderItemVo.h"
#import "PeriodVo.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"

@interface OrderDetailViewController ()
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *killOrderView;
@end

@implementation OrderDetailViewController

static NSInteger labelHeight = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记录详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"E8EAEB"];
    
    UIColor *grayColor = [UIColor colorWithHexString:@"9FA2A2"];
    UIColor *blackColor = [UIColor colorWithHexString:@"2D2F2F"];
    UIColor *lineColor = [UIColor colorWithHexString:@"ECEFEF"];
    UIColor *redColor = [UIColor colorWithHexString:@"C20000"];
    UIFont *commonFont = [UIFont systemFontOfSize:15];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = scrollView.size;
    scrollView.scrollEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    
    if (self.orderVo.canKillOrder) {
        self.scrollView.size = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - 60);
    }
    
    [self.view addSubview:self.scrollView];
    
    CGFloat commonM = 14;
    
//    UIImageView *avtorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(commonM, commonM, 20, 20)];
//    avtorImgView.image = [UIImage imageNamed:@"myprofile_user"];
//    [self.scrollView addSubview:avtorImgView];
//    
//    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(avtorImgView.frame) + commonM, commonM, 200, avtorImgView.height)];
//    VipVo *vip = KGetVip;
//    userNameLabel.text = vip.uid;
//    userNameLabel.textColor = [UIColor colorWithHexString:@"353838"];
//    userNameLabel.font = commonFont;
//    [self.scrollView addSubview:userNameLabel];
//    
//    UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(userNameLabel.frame) + commonM, KScreenWidth, 1)];
//    lineView0.backgroundColor = lineColor;
//    [self.scrollView addSubview:lineView0];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(commonM,commonM, labelHeight + 10, labelHeight + 10)];;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.orderVo.product.pic]];
    [self.scrollView addSubview:imageView];
    
    UILabel *productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, imageView.y, KScreenWidth - 85, imageView.height)];
    productNameLabel.textColor = [UIColor colorWithHexString:@"353838"];
    productNameLabel.font = commonFont;
    
    productNameLabel.text = [NSString stringWithFormat:@"%@ 第%@期",self.orderVo.product.name,self.orderVo.period.name];
    [self.scrollView addSubview:productNameLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + commonM, KScreenWidth, 1)];
    lineView.backgroundColor = lineColor;
    [self.scrollView addSubview:lineView];
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(commonM, CGRectGetMaxY(lineView.frame) + commonM, 100, 30)];
    successLabel.textColor = grayColor;
    successLabel.text = @"交易成功";
    successLabel.font = commonFont;//[UIFont systemFontOfSize:18];
    [self.scrollView addSubview:successLabel];
    
    UILabel *kjLabel = [[UILabel alloc] initWithFrame:CGRectMake(commonM, CGRectGetMaxY(successLabel.frame) + commonM, KScreenWidth - commonM, 30)];
    kjLabel.textColor = grayColor;
    if (self.orderVo.period.kjNum.length == 0) {
        kjLabel.text = @"当期开奖号：";
    }else{
        NSString *kjStr = [NSString stringWithFormat:@"当期开奖号：%@",self.orderVo.period.kjNum];
        NSMutableAttributedString *attrKjStr = [[NSMutableAttributedString alloc] initWithString:kjStr];
        [attrKjStr addAttribute:NSForegroundColorAttributeName value:redColor range:[kjStr rangeOfString:self.orderVo.period.kjNum]];
        kjLabel.attributedText = attrKjStr;
    }
    kjLabel.font = commonFont;
    [self.scrollView addSubview:kjLabel];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(kjLabel.frame) + commonM, KScreenWidth, 1)];
    lineView1.backgroundColor = lineColor;
    [self.scrollView addSubview:lineView1];
    UILabel *zjInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(commonM, CGRectGetMaxY(lineView1.frame), 80, labelHeight)];
    zjInfoLabel.text = @"中奖信息";
    zjInfoLabel.textColor = blackColor;
    zjInfoLabel.font = commonFont;
    [self.scrollView addSubview:zjInfoLabel];
    
    UILabel *zjValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zjInfoLabel.frame), zjInfoLabel.y, KScreenWidth - CGRectGetMaxX(zjInfoLabel.frame), zjInfoLabel.height)];
    zjValueLabel.font = commonFont;
    
    switch (self.orderVo.state) {
        case 0:{
            zjValueLabel.text = @"待开奖";
            zjValueLabel.textColor = [UIColor colorWithHexString:@"869941"];
        }
            break;
        case 1:{
            zjValueLabel.text = @"开奖中";
            zjValueLabel.textColor = [UIColor colorWithHexString:@"869941"];
        }
            break;
        case 2:{
            zjValueLabel.text = @"未中奖";
            zjValueLabel.textColor = RGB(157, 157, 157);
        }
            break;
        case 3:{
            if (self.orderVo.jiang) {
                zjValueLabel.textColor = grayColor;
                NSString *jiangJinStr = [NSString stringWithFormat:@"%@元",self.orderVo.jiang];
                NSString *str = [NSString stringWithFormat:@"奖金%@已发放到账户",jiangJinStr];
                NSRange jiangJinRange = [str rangeOfString:jiangJinStr];
                NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
                [mutableStr addAttribute:NSForegroundColorAttributeName value:redColor range:jiangJinRange];
                zjValueLabel.attributedText = mutableStr;
            }else{
                zjValueLabel.textColor = RGB(193, 0, 18);
                zjValueLabel.text = @"已派奖";
            }
        }
            break;
        default:
            break;
    }
    [self.scrollView addSubview:zjValueLabel];
    
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(zjInfoLabel.frame), KScreenWidth, 1)];
    lineView3.backgroundColor = lineColor;
    [self.scrollView addSubview:lineView3];
    
    // 创建时间
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(commonM, CGRectGetMaxY(lineView3.frame), 80, labelHeight)];
    dateLabel.text = @"创建时间";
    dateLabel.textColor = blackColor;
    dateLabel.font = commonFont;
    [self.scrollView addSubview:dateLabel];

    UILabel *dateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel.frame), dateLabel.y, KScreenWidth - dateLabel.x, dateLabel.height)];
    dateValueLabel.font = commonFont;
    dateValueLabel.text = self.orderVo.dtAdd;
    dateValueLabel.textColor = grayColor;
    [self.scrollView addSubview:dateValueLabel];
    
    CGFloat itemVoH = 130;
    // 订单条目的最大Y值
    CGFloat itemVoMaxHeight = 0;
    for (NSInteger i = 0; i < self.orderVo.items.count; i++) {
        OrderItemVo *itemVo = self.orderVo.items[i];
        
        UIView *itemVoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dateLabel.frame) + itemVoH * i, KScreenWidth, 0)];
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        seperatorView.backgroundColor = lineColor;
        [itemVoView addSubview:seperatorView];
        
        // 投注内容 title
        UILabel *tznrLabel = [[UILabel alloc] init];
        tznrLabel.textColor = blackColor;
        tznrLabel.font = commonFont;
        NSString *tznrStr = @"投注内容：";
        CGSize tznrSize = [tznrStr sizeWithAttributes:@{NSFontAttributeName: tznrLabel.font}];
        tznrLabel.text = tznrStr;
        tznrLabel.frame = CGRectMake(commonM, commonM + 12, tznrSize.width, tznrSize.height);
        [itemVoView addSubview:tznrLabel];
        
        
        // 投注内容 content
        UILabel *tznrContentLabel = [[UILabel alloc] init];
        tznrContentLabel.textColor = redColor;
        tznrContentLabel.numberOfLines = 0;
        tznrContentLabel.font = commonFont;
        NSString *tznrContentStr = itemVo.dataStr;
        
        CGFloat maxContentWidth = KScreenWidth - CGRectGetMaxX(tznrLabel.frame) - commonM;
        CGSize tznrContentSize = [tznrContentStr boundingRectWithSize:CGSizeMake(maxContentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: tznrContentLabel.font} context:nil].size;
        tznrContentLabel.text = tznrContentStr;
        tznrContentLabel.x = CGRectGetMaxX(tznrLabel.frame);
        tznrContentLabel.y = commonM + 12;
        tznrContentLabel.width = tznrContentSize.width;
        tznrContentLabel.height = tznrContentSize.height;
        [itemVoView addSubview:tznrContentLabel];
        
        // 投注详情
        UILabel *tzxqLabel = [[UILabel alloc] initWithFrame:CGRectMake(commonM, CGRectGetMaxY(tznrContentLabel.frame) + commonM, KScreenWidth - commonM * 2, 40)];
        tzxqLabel.font = commonFont;
        tzxqLabel.textColor = blackColor;
        tzxqLabel.numberOfLines = 0;
        tzxqLabel.text = [NSString stringWithFormat:@"投注详情：%@",itemVo.playedName];
        [tzxqLabel sizeToFit];
        [itemVoView addSubview:tzxqLabel];
        
        // 投注金额
        UILabel *tzjeLabel = [[UILabel alloc] initWithFrame:CGRectMake(commonM, CGRectGetMaxY(tzxqLabel.frame) + 1, KScreenWidth - commonM * 2, 40)];
        tzjeLabel.font = commonFont;
        tzxqLabel.textColor = blackColor;
        NSString *model = nil;
        switch (itemVo.unit) {
            case 1:
                model = @"元";
                break;
            case 10:
                model = @"角";
                break;
            case 100:
                model = @"分";
                break;
            default:
                break;
        }
        NSString *bettingCount = [NSString stringWithFormat:@"%zd",itemVo.num];
        NSString *bettingMoney = [NSString stringWithFormat:@"%zd",itemVo.jg];
        NSString *bettingMul = [NSString stringWithFormat:@"%zd",itemVo.beis];
        NSString *tzjeStr = [NSString stringWithFormat:@"投注金额：共%@注 %@元 倍数：%@ 模式：%@",bettingCount,bettingMoney,bettingMul,model];
        
        NSMutableAttributedString *tzjeAttrStr = [[NSMutableAttributedString alloc] initWithString:tzjeStr];
        [tzjeAttrStr addAttribute:NSForegroundColorAttributeName value:redColor range:[tzjeStr rangeOfString:bettingCount]];
        [tzjeAttrStr addAttribute:NSForegroundColorAttributeName value:redColor range:[tzjeStr rangeOfString:bettingMoney]];
        [tzjeAttrStr addAttribute:NSForegroundColorAttributeName value:redColor range:[tzjeStr rangeOfString:bettingMul options:NSBackwardsSearch]];
        [tzjeAttrStr addAttribute:NSForegroundColorAttributeName value:redColor range:[tzjeStr rangeOfString:model options:NSBackwardsSearch]];
        
        tzjeLabel.attributedText = tzjeAttrStr;
        [itemVoView addSubview:tzjeLabel];
        
        itemVoView.height = CGRectGetMaxY(tzjeLabel.frame);
        
        [self.scrollView addSubview:itemVoView];
        
        if (i == self.orderVo.items.count - 1) {
            itemVoMaxHeight = CGRectGetMaxY(itemVoView.frame);
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, itemVoMaxHeight, KScreenWidth, KScreenHeight)];
            bottomView.backgroundColor = self.view.backgroundColor;
            [self.scrollView addSubview:bottomView];
        }
    }
    
    if (itemVoMaxHeight < KScreenHeight) {
        self.scrollView.height = itemVoMaxHeight + 6;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(0, itemVoMaxHeight);
    }

    self.scrollView.contentSize = CGSizeMake(0, itemVoMaxHeight + 64);
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 60 - 64, KScreenWidth, 60)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *killOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [killOrderBtn setTitle:@"撤单" forState:UIControlStateNormal];
    [killOrderBtn setTitleColor:[UIColor colorWithHexString:@"79AB18"] forState:UIControlStateNormal];
    killOrderBtn.layer.cornerRadius = 5;
    killOrderBtn.layer.masksToBounds = YES;
    killOrderBtn.layer.borderColor = [UIColor colorWithHexString:@"D7D7D7"].CGColor;
    killOrderBtn.layer.borderWidth = 1;
    killOrderBtn.frame = CGRectMake(20, 10, KScreenWidth - 40, 40);
    [killOrderBtn addTarget:self action:@selector(killOrder) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:killOrderBtn];
    [self.view addSubview:view];
    
    self.killOrderView = view;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.orderVo.canKillOrder) {
        self.killOrderView.hidden = NO;
    }else{
        self.killOrderView.hidden = YES;
    }
}

-(void)killOrder{
    VipVo *vip = KGetVip;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:vip.vipId forKey:@"vipId"];
    [paramDict setValue:vip.token forKey:@"vipToken"];
    [paramDict setValue:self.orderVo.orderId forKey:@"orderId"];
    [[AFHTTPSessionManager manager] GET:[KServerUrl stringByAppendingPathComponent:@"order/kill"] parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject valueForKey:@"statusCode"] integerValue] == 200) {
            
            
            [SVProgressHUD showSuccessWithStatus:[responseObject valueForKey:@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:[responseObject valueForKey:@"message"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"撤单请求失败"];
    }];
}


@end
