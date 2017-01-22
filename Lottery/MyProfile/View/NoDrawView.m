//
//  NoDrawView.m
//  Lottery
//
//  Created by 蒋远路 on 16/7/18.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "NoDrawView.h"

@interface NoDrawView()
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation NoDrawView

-(void)setIconName:(NSString *)iconName{
    _iconName = iconName;
    self.typeImgView.image = [UIImage imageNamed:self.iconName];
}

-(void)setInfoText:(NSString *)infoText{
    _infoText = infoText;
    self.infoLabel.text = infoText;
}

@end
