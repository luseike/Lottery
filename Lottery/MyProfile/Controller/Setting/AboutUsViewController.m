//
//  AboutUsViewController.m
//  Lottery
//
//  Created by 蒋远路 on 16/5/31.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"aboutCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"返点规则";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"用户协议";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = RGB(97, 97, 97);
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KScreenHeight * 0.3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.height = KScreenHeight * 0.3;
    headerView.width = KScreenWidth;
    headerView.x = 0;
    headerView.y = 0;
    
    UIImageView *appIconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appIcon"]];
    appIconImgView.center = headerView.center;
    appIconImgView.layer.cornerRadius = 10;
    appIconImgView.layer.masksToBounds = YES;
    [headerView addSubview:appIconImgView];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"版本 %@",version];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor grayColor];
    versionLabel.font = [UIFont systemFontOfSize:12];
    versionLabel.width = KScreenWidth;
    versionLabel.height = 20;
    versionLabel.centerY = CGRectGetMaxY(appIconImgView.frame) + (headerView.height - CGRectGetMaxY(appIconImgView.frame)) * 0.3;//headerView.centerY;
    [headerView addSubview:versionLabel];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
    }else{
    }
}

@end
