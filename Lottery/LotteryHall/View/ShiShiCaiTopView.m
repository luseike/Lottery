//
//  ShiShiCaiTopView.m
//  Lottery
//
//  Created by jiangyuanlu on 16/6/18.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "ShiShiCaiTopView.h"
#import "UIImage+ImageWithColor.h"

@interface ShiShiCaiTopView()<UIScrollViewDelegate>
@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,strong) UIButton *selectedPlayTypeBtn;
@property (nonatomic,strong) NSArray *dataKeys;
@property (nonatomic,strong) NSArray *dataValues;
/**
 *  选择按钮的view容器
 */
@property (nonatomic,strong) UIScrollView *selectedBtnsView;
/**
 *  玩法按钮的view容器
 */
@property (nonatomic,strong) UIView *playTypeBtnsView;
/**
 *  选中类别的index
 */
@property(nonatomic,assign) NSInteger categoryIndex;
/**
 *  上一次选中类别的index
 */
@property(nonatomic,assign) NSInteger lastCategoryIndex;
/**
 *  选中玩法的index
 */
@property(nonatomic,assign) NSInteger clickedBtnIndex;
/**
 *  选中按钮的容器
 */
@property(nonatomic,strong) NSMutableArray *playTypeBtnsContainer;
/**
 *  是否是第一次进入循环
 */
@property(nonatomic,assign) BOOL isFirstInput;
/**
 *  玩法选择按钮下面的横线
 */
@property (nonatomic,strong) UIView *bottomLineView;
@end

@implementation ShiShiCaiTopView

static NSInteger topViewHeight = 45;
static NSInteger playTypeBtnsViewHeight = 12;

-(NSMutableArray *)playTypeBtnsContainer{
    if (!_playTypeBtnsContainer) {
        _playTypeBtnsContainer = [NSMutableArray array];
    }
    return _playTypeBtnsContainer;
}

-(instancetype)initWithFrame:(CGRect)frame{
    NSArray *dataKeys = @[@"定位",@"前二",@"后二",@"前三",@"中三",@"后三",@"四星",@"五星",@"任二",@"任三",@"任四"];
    NSArray *dataValues = @[
                            @[@{@"":@[@"五星定位胆"]}],
                            @[
                                @{@"前二直选":@[@"直选复式",@"直选单式",@"直选和值",@"直选跨度"]},
                                @{@"前二组选":@[@"组选复式",@"组选单式",@"组选包胆"]}
                                ],
                            @[
                                @{@"后二直选":@[@"直选复式",@"直选单式",@"直选和值",@"直选跨度"]},
                                @{@"后二组选":@[@"组选复式",@"组选单式",@"组选包胆"]}
                                ],
                            @[
                                @{@"前三直选":@[@"直选复式",@"直选单式",@"前三组合",@"直选和值",@"直选跨度"]},
                                @{@"前三组选":@[@"组三复式",@"组三单式",@"组六复式",@"组六单式",@"组选包胆"]},
                                @{@"前三其他":@[@"和值尾数"]}
                                ],
                            @[
                                @{@"中三直选":@[@"直选复式",@"直选单式",@"中三组合",@"直选和值",@"直选跨度"]},
                                @{@"中三组选":@[@"组三复式",@"组三单式",@"组六复式",@"组六单式",@"组选包胆"]},
                                @{@"中三其他":@[@"和值尾数"]}
                                ],
                            @[
                                @{@"后三直选":@[@"直选复式",@"直选单式",@"后三组合",@"直选和值",@"直选跨度"]},
                                @{@"后三组选":@[@"组三复式",@"组三单式",@"组六复式",@"组六单式",@"组选包胆"]},
                                @{@"后三其他":@[@"和值尾数"]}
                                ],
                            @[
                                @{@"四星直选":@[@"直选复式",@"直选单式",@"四星组合"]},
                                @{@"四星组选":@[@"组选24",@"组选12",@"组选6",@"组选4"]}
                                ],
                            @[
                                @{@"五星直选":@[@"直选复式",@"直选单式",@"五星组合"]},
                                @{@"五星组选":@[@"组选120",@"组选60",@"组选30",@"组选20",@"组选10",@"组选5"]},
                                @{@"五星特殊":@[@"一帆风顺",@"好事成双",@"三星报喜",@"四季发财"]}
                                ],
                            @[
                                @{@"任二直选":@[@"直选复式",@"直选单式",@"直选和值"]},
                                @{@"任二组选":@[@"组选复式",@"组选单式",@"组选和值"]}
                                ],
                            @[
                                @{@"任三直选":@[@"直选复式",@"直选单式",@"直选和值"]},
                                @{@"任三组选":@[@"组三复式",@"组三单式",@"组六复式",@"组六单式"]}
                                ],
                            @[
                                @{@"任四直选":@[@"直选复式",@"直选单式"]},
                                @{@"任四组选":@[@"组选24",@"组选12",@"组选6",@"组选4"]}
                                ]
                            ];
    self.dataKeys = dataKeys;
    self.dataValues = dataValues;
    if (self = [super initWithFrame:frame]) {
        self.isFirstInput = NO;
        CGFloat btnW = KScreenWidth / 5;//dataKeys.count;
        
        UIScrollView *selectedBtnsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, topViewHeight)];
        selectedBtnsView.showsHorizontalScrollIndicator = NO;
        selectedBtnsView.delegate = self;
        self.selectedBtnsView = selectedBtnsView;
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight - 2, btnW, 2)];
        bottomLineView.backgroundColor = [UIColor colorWithHexString:@"EFA948"];
        [self addSubview:bottomLineView];
        self.bottomLineView = bottomLineView;
        
        UIView *playTypeBtnsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(selectedBtnsView.frame) + playTypeBtnsViewHeight, KScreenWidth, 400)];
        [self addSubview:playTypeBtnsView];
        self.playTypeBtnsView = playTypeBtnsView;
        
        for (NSInteger i = 0; i < dataKeys.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            [btn setTitle:dataKeys[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"686A6A"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"EFA948"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.frame = CGRectMake(btnW * i, 0, btnW, topViewHeight);
            [self.selectedBtnsView addSubview:btn];
            
            if (i == dataKeys.count - 1) {
                self.selectedBtnsView.contentSize = CGSizeMake(btnW * dataKeys.count, 0);
            }
        }
        
        [self addSubview:selectedBtnsView];
        [self btnClick:[self.selectedBtnsView.subviews firstObject]];
    }
    return self;
}

/**
 *  topView内部按钮的点击，切换不同类别的玩法
 */
-(void)btnClick:(UIButton *)btn{
//    NSInteger totalIndex = self.dataKeys.count;
    NSInteger clickCategoryIndex = [self.selectedBtnsView.subviews indexOfObject:btn];
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (self.selectedBtnsView.contentOffset.x > 0) {
            self.bottomLineView.x = btn.x - self.selectedBtnsView.contentOffset.x;
        }else{
            self.bottomLineView.x = btn.x;
        }
        
        CGPoint btnOffSet = self.selectedBtnsView.contentOffset;
        btnOffSet.x = btn.center.x - self.selectedBtnsView.width * 0.5;
        if (btnOffSet.x < 0) {
            btnOffSet.x = 0;
        }
        
        CGFloat maxBtnOffsetX = self.selectedBtnsView.contentSize.width - self.selectedBtnsView.width;
        if (btnOffSet.x > maxBtnOffsetX) {
            btnOffSet.x = maxBtnOffsetX;
        }
        [self.selectedBtnsView setContentOffset:btnOffSet animated:YES];
      
    }];
    
    //添加新的玩法类别之前，先删除之前就的类别的玩法
    NSUInteger subViewsCount = self.playTypeBtnsView.subviews.count;
    for (NSInteger i = 0; i < subViewsCount; i++) {
        [[self.playTypeBtnsView.subviews firstObject] removeFromSuperview];
    }
    [self.playTypeBtnsContainer removeAllObjects];
    NSArray *showDict = self.dataValues[btn.tag];
    self.categoryIndex = btn.tag;
    //currentMaxY 记录子view最大的Y值
    __block CGFloat currentMaxY = 0;
    CGFloat playTypeBtnH = 33;
    NSUInteger maxColumn = 3;
    NSUInteger columnMargin = 10;
    CGFloat playTypeBtnW = (KScreenWidth - ((maxColumn + 1) * columnMargin)) / maxColumn;
    UIFont *subViewFont = [UIFont systemFontOfSize:12];
    for (NSInteger i = 0; i < showDict.count; i++) {
        NSDictionary *subDict = showDict[i];
        [subDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSArray *btnTexts = obj;
            if (showDict.count > 1) {
                
                // lineLabel
                UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
                bgLabel.backgroundColor = [UIColor colorWithHexString:@"DBDEDD"];
                // 显示玩法类别的label
                UIView *lastSubView = [self.playTypeBtnsView.subviews lastObject];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, lastSubView == nil ? 0 : CGRectGetMaxY(lastSubView.frame), 0, 20)];
                if (i > 0) {
                    label.y += columnMargin;
                }
                
                label.text = key;
                label.font = subViewFont;
                label.textColor = [UIColor colorWithHexString:@"828484"];
                label.textAlignment = NSTextAlignmentCenter;
                label.width = [label.text sizeWithAttributes:@{NSFontAttributeName:subViewFont}].width + 20;
                label.centerX = KScreenWidth * 0.5;
                label.backgroundColor = [UIColor whiteColor];
                bgLabel.centerY = label.centerY;
                [self.playTypeBtnsView addSubview:bgLabel];
                [self.playTypeBtnsView addSubview:label];
                
                // 更新子view 及其 最大Y值
                lastSubView = [self.playTypeBtnsView.subviews lastObject];
                currentMaxY = CGRectGetMaxY(lastSubView.frame);
            }
            
            
            for (NSInteger j = 0; j < btnTexts.count; j++) {
                UIButton *playTypebtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [playTypebtn setTitle:btnTexts[j] forState:UIControlStateNormal];
                playTypebtn.titleLabel.font = subViewFont;
                playTypebtn.layer.borderColor = [UIColor colorWithHexString:@"E0E2E4"].CGColor;
                playTypebtn.layer.borderWidth = 1.0;
                [playTypebtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                [playTypebtn setBackgroundImage:[UIImage imageWithColor:RGB(247, 180, 91)] forState:UIControlStateSelected];
                [playTypebtn setTitleColor:[UIColor colorWithHexString:@"111212"] forState:UIControlStateNormal];
                [playTypebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [playTypebtn addTarget:self action:@selector(playTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.playTypeBtnsContainer addObject:playTypebtn];
                NSUInteger row = j / maxColumn;
                NSUInteger column = j % maxColumn;
                playTypebtn.frame = CGRectMake((playTypeBtnW + columnMargin) * column + columnMargin,(playTypeBtnH + columnMargin) * row + columnMargin + currentMaxY,playTypeBtnW, playTypeBtnH);
                if (j == 0 && i == 0) {
                    
                    if (!self.isFirstInput) {
                        self.isFirstInput = YES;
                        [self playTypeBtnClick:playTypebtn];
                        [self.delegate shiShiCaiTopViewDidClick:self atCategoryIndex:0 atClickedIndex:0];
                    }
                    
                }
                
                // 判断当前点击的类别index和按钮index 是否与上次选中的按钮相同  若相同  将按钮设为选中状态
                if(self.clickedBtnIndex == self.playTypeBtnsContainer.count - 1 && self.lastCategoryIndex == clickCategoryIndex){
                    playTypebtn.selected = YES;
                }
                [self.playTypeBtnsView addSubview:playTypebtn];
            }
        }];
    }
    
    UIView *lastSubView = [self.playTypeBtnsView.subviews lastObject];
    self.height = CGRectGetMaxY(lastSubView.frame) + CGRectGetMaxY(self.selectedBtnsView.frame) + columnMargin + playTypeBtnsViewHeight;
}

-(void)playTypeBtnClick:(UIButton *)typeBtn{
    self.selectedPlayTypeBtn.selected = NO;
    typeBtn.selected = YES;
    self.selectedPlayTypeBtn = typeBtn;
    
    NSLog(@"%@",typeBtn.currentTitle);
    
    if ([self.delegate respondsToSelector:@selector(shiShiCaiTopViewDidClick:atCategoryIndex:atClickedIndex:)]) {
        self.clickedBtnIndex = [self.playTypeBtnsContainer indexOfObject:typeBtn];
        self.lastCategoryIndex = self.categoryIndex;
        [self.delegate shiShiCaiTopViewDidClick:self atCategoryIndex:self.categoryIndex atClickedIndex:self.clickedBtnIndex];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.selectedBtnsView.contentOffset.x > 0) {
        self.bottomLineView.x = self.selectedBtn.x - self.selectedBtnsView.contentOffset.x;
    }else{
        self.bottomLineView.x = self.selectedBtn.x;
    }
}

@end
