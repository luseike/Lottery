//
//  MySettingViewController.m
//  Lottery
//
//  Created by Chris Deng on 16/4/16.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "MySettingViewController.h"
#import "FeedbackViewController.h"
#import "AboutUsViewController.h"

@interface MySettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mySettingTableView;
@property(nonatomic,strong) IBOutlet UIButton *exitBtn;
@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
//    self.view.backgroundColor = UIColorFromRGB(0xfefdf8);
    _mySettingTableView.delegate = self;
    _mySettingTableView.dataSource = self;
    _mySettingTableView.backgroundView = [[UIView alloc]init];
    _mySettingTableView.backgroundColor = [UIColor clearColor];
    
    VipVo *vip = KGetVip;
    if (vip == nil) {
        self.exitBtn.hidden = YES;
    }
    
}

- (IBAction)exitClick:(id)sender {
    UIAlertController *exitAlert = [UIAlertController alertControllerWithTitle:nil message:@"是否退出账号" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(exitAlert) weakAlert = exitAlert;
    [exitAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"vipvo.data"];
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        [SVProgressHUD showSuccessWithStatus:@"退出成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KLoginOutSuccessNotification" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [exitAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:exitAlert animated:YES completion:nil];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"MySettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"7B7B7B"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    switch (row) {
        case 0:
            [cell.imageView setImage:[UIImage imageNamed:@"FAQs"]];
            cell.textLabel.text = @"常见问题";
            break;
        case 1:
            [cell.imageView setImage:[UIImage imageNamed:@"agreement"]];
            cell.textLabel.text = @"服务协议";
            break;
        case 2:
            [cell.imageView setImage:[UIImage imageNamed:@"feedback"]];
            cell.textLabel.text = @"意见反馈";
            break;
        case 3:
            [cell.imageView setImage:[UIImage imageNamed:@"about"]];
            cell.textLabel.text = @"关于我们";
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 2:
        {
            FeedbackViewController *feedbackVc = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackVc animated:YES];
        }
            break;
        case 3:{
            AboutUsViewController *aboutVc = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutVc animated:YES];
        }break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)backBtnClicked:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
