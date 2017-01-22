//
//  SanBuTongDanTuoView.h
//  Lottery
//
//  Created by jiangyuanlu on 16/5/25.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SanBuTongDanTuoView : UIView

@property(nonatomic,strong) NSString *danMaSelectedNumbers;

@property(nonatomic,strong) NSString *tuoMaSelectedNumbers;

-(void)clearAllSelected;

@end
