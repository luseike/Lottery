//
//  NoDrawView.h
//  Lottery
//
//  Created by 蒋远路 on 16/7/18.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDrawView : UIView

@property(nonatomic,assign) BOOL isTixian;

@property (nonatomic,copy) NSString *iconName;
@property (nonatomic,copy) NSString *infoText;

@end
