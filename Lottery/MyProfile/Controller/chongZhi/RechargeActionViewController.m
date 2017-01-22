//
//  RechargeActionViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/7/27.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "RechargeActionViewController.h"

@interface RechargeActionViewController ()<UIWebViewDelegate>

@end

@implementation RechargeActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    myProgressView = [[UIProgressView alloc] initWithFrame:barFrame];
    myProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    myProgressView.progressTintColor = [UIColor colorWithRed:43.0/255.0 green:186.0/255.0  blue:0.0/255.0  alpha:1.0];
    [self.navigationController.navigationBar addSubview:myProgressView];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.rechargeUrl]]];
    [self.view addSubview:webView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 移除 progress view
    [myProgressView removeFromSuperview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    myProgressView.progress = 0;
    theBool = false;
    myProgressView.hidden = false;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    myProgressView.hidden = true;
    [myTimer invalidate];
    myTimer = nil;
    NSLog(@"webViewDidFinishLoad");
}

-(void)timerCallback {
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (theBool) {
        myProgressView.progress += 0.1;
        
    }
    else {
        myProgressView.progress += 0.05;
        if (myProgressView.progress >= 0.95) {
            myProgressView.progress = 0.95;
        }
    }
}


@end
