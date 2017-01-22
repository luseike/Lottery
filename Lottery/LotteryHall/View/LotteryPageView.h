//
//  LotteryPageView.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/10.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol LotteryPageViewDelegate <NSObject>

-(void)imgDidClick:(UIImage *)imgView imgUrl:(NSString *)url;

@end

@interface LotteryPageView : UIView
+ (instancetype)pageView;
/** 图片名字 */
@property (nonatomic, strong) NSArray *imageUrls;
/** 其他圆点颜色 */
@property (nonatomic, strong) UIColor *otherColor;
/** 当前圆点颜色 */
@property (nonatomic, strong) UIColor *currentColor;
@property(nonatomic,weak) id<LotteryPageViewDelegate> delagate;
@end
