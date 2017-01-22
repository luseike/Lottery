//
//  TeamGameVo.h
//  Lottery
//
//  Created by jiangyuanlu on 16/9/8.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  团队游戏

#import <Foundation/Foundation.h>

@interface TeamGameVo : NSObject
/**
 *  String	团队成员用户名
 */
@property (nonatomic,copy) NSString *userUid;
/**
 *  Date	下单时间。格式：yyyy-MM-dd HH:mm:ss
 */
@property (nonatomic,copy) NSString *dtAdd;
/**
 *  String	彩种名称
 */
@property (nonatomic,copy) NSString *productName;
/**
 *  String	彩种ID
 */
@property (nonatomic,copy) NSString *productId;
/**
 *  String	期次
 */
@property (nonatomic,copy) NSString *period;
/**
 *  String	玩法名称
 */
@property (nonatomic,copy) NSString *playedName;
/**
 *  彩种图片
 */
@property (nonatomic,copy) NSString *productPic;
/**
 *  int	倍数模式： 1:元 10:角 100:分
 */
@property (nonatomic,assign) NSInteger unit;
/**
 *  int	注数
 */
@property (nonatomic,assign) NSInteger num;
/**
 *  int	倍数
 */
@property (nonatomic,assign) NSInteger beis;
/**
 *  String	投注内容
 */
@property (nonatomic,copy) NSString *data;
/**
 *  double	投注金额.
 */
@property (nonatomic,assign) NSInteger jg;
/**
 *  double	开奖后，若中奖，则此字段显示中奖金额。
 */
@property (nonatomic,assign) double jiang;
/**
 *  String	开奖号码（只有已开奖的才有开奖号码）
 */
@property (nonatomic,copy) NSString *kjNum;
/**
 *  int	状态： 0:待开奖 1:开奖中 2:未中奖 3:已派奖(即中奖了)
 */
@property (nonatomic,assign) NSInteger state;


@end
