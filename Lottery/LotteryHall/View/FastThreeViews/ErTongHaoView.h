//
//  ErTongHaoView.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/25.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErTongHaoView : UIView

@property(nonatomic,strong) NSString *tongHaoSelectedNumbers;

@property(nonatomic,strong) NSString *buTongHaoSelectedNumbers;

@property(nonatomic,strong) NSString *fuXuanSelectedNumbers;

-(void)clearAllSelected;

@end
