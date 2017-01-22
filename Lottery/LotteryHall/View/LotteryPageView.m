//
//  LotteryPageView.m
//  Lottery
//
//  Created by jiangyuanlu on 16/5/10.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//




#import "LotteryPageView.h"
#import "UIImageView+WebCache.h"

@interface LotteryPageView() <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LotteryPageView
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
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
- (void)setup
{
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    
    // 开启定时器
    [self startTimer];
}

+ (instancetype)pageView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    
    // 获得scrollview的尺寸
    CGFloat scrollW = self.scrollView.frame.size.width;
    CGFloat scrollH = self.scrollView.frame.size.height;
    
    // 设置pageControl
    CGFloat pageW = 100;
    CGFloat pageH = 20;
    CGFloat pageX = scrollW - pageW;
    CGFloat pageY = scrollH - pageH;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    
    self.scrollView.contentSize = CGSizeMake(self.imageUrls.count * scrollW, 0);
    
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        imageView.frame = CGRectMake(i * scrollW, 0, scrollW, scrollH);
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rollImageClick:)]];
    }
}

/**
 *  轮播图片被点击
 */
-(void)rollImageClick:(UITapGestureRecognizer *)tapGuesture{
    if ([self.delagate respondsToSelector:@selector(imgDidClick:imgUrl:)]) {
//        [self respondsToSelector:@selector(imgDidClick:imgUrl:)];
        [self.delagate imgDidClick:nil imgUrl:nil];
    }
}

#pragma mark - setter方法的重写
-(void)setImageUrls:(NSArray *)imageUrls{
    _imageUrls = imageUrls;
    for (int i = 0; i<imageUrls.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrls[i]]];
        [self.scrollView addSubview:imageView];
    }
    
    // 设置总页数
    self.pageControl.numberOfPages = imageUrls.count;
}

- (void)setCurrentColor:(UIColor *)currentColor{
    _currentColor = currentColor;
    self.pageControl.currentPageIndicatorTintColor = currentColor;
}

- (void)setOtherColor:(UIColor *)otherColor{
    _otherColor = otherColor;
    self.pageControl.pageIndicatorTintColor = otherColor;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

#pragma mark - 定时器控制
- (void)startTimer{
    // 创建一个定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

/**
 * 下一页
 */
- (void)nextPage{
    NSInteger page = self.pageControl.currentPage + 1;
    if (page == self.pageControl.numberOfPages) {
        page = 0;
    }
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = page * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:offset animated:YES];
}
@end
