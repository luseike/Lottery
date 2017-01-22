//
//  PlayCategoryBtn.m
//  Lottery
//
//  Created by 蒋远路 on 16/5/12.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "PlayCategoryBtn.h"
#import "PlayCategory.h"

@implementation PlayCategoryBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setPlayCategory:(PlayCategory *)playCategory{
    _playCategory = playCategory;
    [self setTitle:playCategory.playCategoryName forState:UIControlStateNormal];
    [self setTitle:playCategory.playCategoryName forState:UIControlStateSelected];
}

@end
