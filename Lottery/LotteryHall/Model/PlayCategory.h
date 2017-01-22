//
//  PlayCategory.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/13.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//  玩法分类模型

#import <UIKit/UIKit.h>

@interface PlayCategory : UIView

/**
 *  选定玩法名称
 */
@property(nonatomic,copy) NSString *playCategoryName;
/**
 *  选定玩法至少选择的数字
 */
@property(nonatomic,assign) NSUInteger numberCount;
/**
 *  玩法说明
 */
@property (nonatomic,copy) NSString *playDesc;

/**
 *  选定玩法包含的数字面板的数组
 */
@property (nonatomic,strong) NSArray *numberPanModels;
/**
 *  玩法ID
 */
@property (nonatomic,copy) NSString *playedId;
/**
 *  玩法名称
 */
@property(nonatomic,copy) NSString *playedName;
@end
