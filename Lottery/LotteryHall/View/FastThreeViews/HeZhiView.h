//
//  HeZhiView.h
//  Lottery
//
//  Created by 蒋远路 on 16/5/24.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeZhiView : UIView
@property(nonatomic,strong) NSArray *dataArr;

@property(nonatomic,strong) NSString *selectedNumbers;

-(void)clearAllSelected;
@end
