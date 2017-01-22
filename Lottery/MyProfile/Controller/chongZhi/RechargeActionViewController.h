//
//  RechargeActionViewController.h
//  Lottery
//
//  Created by 蒋远路 on 16/7/27.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeActionViewController : UIViewController{
    BOOL theBool;
    //IBOutlet means you can place the progressView in Interface Builder and connect it to your code
    UIProgressView* myProgressView;
    NSTimer *myTimer;
    UIWebView *webView;
}
@property(nonatomic,copy) NSString *rechargeUrl;


@end
