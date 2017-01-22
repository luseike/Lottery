//
//  ShiShiCaiTopView.h
//  Lottery
//
//  Created by jiangyuanlu on 16/6/18.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShiShiCaiTopView;

@protocol ShiShiCaiTopViewDelegate <NSObject>

-(void)shiShiCaiTopViewDidClick:(ShiShiCaiTopView *)topView atCategoryIndex:(NSInteger)categoryIndex  atClickedIndex:(NSInteger)clickedIndex;

@end

@interface ShiShiCaiTopView : UIView

@property(nonatomic,weak) id<ShiShiCaiTopViewDelegate> delegate;

@end
