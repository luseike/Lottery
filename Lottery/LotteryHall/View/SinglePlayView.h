//
//  SinglePlayView.h
//  Lottery
//
//  Created by jiangyuanlu on 16/8/13.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayCategory.h"

@protocol SinglePlayViewDelegate <NSObject>

-(void)singlePlayViewClickDown:(NSInteger)bettingCount bettingContent:(NSString *)bettingContent;

@end

@interface SinglePlayView : UIView
@property (weak, nonatomic) IBOutlet UITextView *selectedNumbersTextView;

@property (nonatomic,weak) id<SinglePlayViewDelegate> delegate;

@property (nonatomic,strong) PlayCategory *category;
/**
 *  singleView的投注注数
 */
@property (nonatomic,assign) NSInteger bettingCount;

/**
 *  singleView的投注注数
 */
@property (nonatomic,copy) NSString *bettingContent;
/**
 *  单式的类型
 */
@property (nonatomic,assign) NSInteger singlePlayViewType;

/**
 *  单式组合的类型
 */
//@property (nonatomic,assign) NSInteger singlePlayViewGroupType;

-(void)clearBettingContent;

@end
