//
//  HeZhiView.m
//  Lottery
//
//  Created by 蒋远路 on 16/5/24.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "HeZhiView.h"

@interface HeZhiView()
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end

@implementation HeZhiView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        
        // 添加子控件代码
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

/**
 * 初始化代码
 */
- (void)setup{
    // 添加16个numberView
    for (NSInteger i = 0; i < 16; i++) {
        UIView *view = [[UIView alloc] init];
        view.layer.borderWidth = 1;
        view.layer.borderColor = RGB(221, 222, 226).CGColor;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 2.0;
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.textColor = RGB(86, 86, 86);
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = [UIFont systemFontOfSize:18];
        UILabel *boundsLabel = [[UILabel alloc] init];
        boundsLabel.textColor = RGB(124, 124, 124);
        boundsLabel.textAlignment = NSTextAlignmentCenter;
        boundsLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:numberLabel];
        [view addSubview:boundsLabel];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberViewCllick:)]];
        [self.viewContainer addSubview:view];
    }
}

-(void)numberViewCllick:(UITapGestureRecognizer *)tapGesture{
    UIView *numberView = tapGesture.view;
    UILabel *numberLabel = [numberView.subviews firstObject];
    UILabel *boundsLabel = [numberView.subviews lastObject];
    if (numberView.backgroundColor == [UIColor whiteColor]) {
        numberView.backgroundColor = [UIColor colorWithHexString:@"eb5228"];
        numberLabel.textColor = [UIColor whiteColor];
        boundsLabel.textColor = [UIColor whiteColor];
        numberView.layer.borderWidth = 0;
//        self.selectedNumbers = [NSString appendObjStr:numberLabel.text toSelectedStr:self.selectedNumbers];
    }else{
        numberView.backgroundColor = [UIColor whiteColor];
        numberLabel.textColor = RGB(86, 86, 86);
        boundsLabel.textColor = RGB(124, 124, 124);
        numberView.layer.borderWidth = 1;
        numberView.layer.borderColor = RGB(221, 222, 226).CGColor;
//        self.selectedNumbers = [NSString deleteObjStr:numberLabel.text fromSelectedStr:self.selectedNumbers];
    }
    self.selectedNumbers = @"";
    for (UIView *subNumberView in self.viewContainer.subviews) {
        //背景不是白色，说明已经被选中
        if (subNumberView.backgroundColor != [UIColor whiteColor]) {
            UILabel *numberLabel = [subNumberView.subviews firstObject];
            self.selectedNumbers = [NSString appendObjStr:numberLabel.text toSelectedStr:self.selectedNumbers];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HeZhiNumberViewClickNotification" object:nil userInfo:@{@"selectedNumbers":self.selectedNumbers}];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat viewMargin = 5;
    CGFloat viewRowMargin = 10;
    NSInteger maxColumn = 4;
    CGFloat viewWidth = (self.viewContainer.width - (maxColumn - 1) * viewMargin) / maxColumn;
    CGFloat viewHeight = viewWidth * 0.75;
    
    for (NSInteger i = 0; i < self.viewContainer.subviews.count; i++) {
        UIView *view = self.viewContainer.subviews[i];
        NSUInteger row = i / maxColumn;
        NSUInteger column = i % maxColumn;
        
        
        view.frame = CGRectMake((viewWidth + viewMargin) * column,(viewHeight + viewRowMargin) * row,viewWidth, viewHeight);
        
        UILabel *numberLabel = [view.subviews firstObject];
        numberLabel.width = view.width;
        numberLabel.x = 0;
        numberLabel.y = view.height * 0.1;
        numberLabel.height = view.height * 0.4;
        
        UILabel *boundsLabel = [view.subviews lastObject];
        boundsLabel.x = 0;
        boundsLabel.y = CGRectGetMaxY(numberLabel.frame) + view.height * 0.1;
        boundsLabel.width = view.width;
        boundsLabel.height = view.height * 0.2;
    }
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    for (NSInteger i = 0; i < dataArr.count; i++) {
        UIView *numberView = self.viewContainer.subviews[i];
        UILabel *numberLabel = [numberView.subviews firstObject];
        UILabel *boundsLabel = [numberView.subviews lastObject];
        
        NSDictionary *dict = dataArr[i];
        numberLabel.text = [dict valueForKey:@"number"];
        
        boundsLabel.text = [NSString stringWithFormat:@"奖金%@元",[dict valueForKey:@"bounds"]];
    }
}

-(void)clearAllSelected{
    for (UIView *subView in self.viewContainer.subviews) {
//        subView.backgroundColor = [UIColor whiteColor];
        
//        UIView *numberView = tapGesture.view;
        UILabel *numberLabel = [subView.subviews firstObject];
        UILabel *boundsLabel = [subView.subviews lastObject];
        if (subView.backgroundColor != [UIColor whiteColor]) {
            subView.backgroundColor = [UIColor whiteColor];
            numberLabel.textColor = RGB(86, 86, 86);
            boundsLabel.textColor = RGB(124, 124, 124);
            subView.layer.borderWidth = 1;
            subView.layer.borderColor = RGB(221, 222, 226).CGColor;
            self.selectedNumbers = @"";
        }
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
