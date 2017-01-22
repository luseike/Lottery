//
//  BettingListCell.m
//  Lottery
//
//  Created by 蒋远路 on 16/5/31.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "BettingListCell.h"
#import "BettingListModel.h"

@interface BettingListCell()
@property (weak, nonatomic) IBOutlet UILabel *selectedNumbersLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCateryLabel;
@property (weak, nonatomic) IBOutlet UILabel *bettingMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *subViews;

@end

@implementation BettingListCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"bettingListCell";
    BettingListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
        
    }
    return cell;
}
- (IBAction)closeBtnClick:(UITapGestureRecognizer *)sender {
    NSLog(@"删除按钮被点击");
//    
//    BettingListCell *cell = sender.view.superview.superview.superview;
//    self.
    
    if ([self.bettingListCellDelegate respondsToSelector:@selector(BettingListCellDidClick:)]) {
        [self.bettingListCellDelegate BettingListCellDidClick:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.subViews.layer.borderColor = RGB(230, 230, 230).CGColor;
    self.subViews.layer.borderWidth = 1.0;
    self.subViews.layer.cornerRadius = 2.0;
    self.subViews.layer.masksToBounds = YES;
}

-(void)setListModel:(BettingListModel *)listModel{
    _listModel = listModel;
    self.selectedNumbersLabel.text = listModel.selectedNumbers;
    self.playCateryLabel.text = listModel.playCatery;
    self.bettingMoneyLabel.text = [NSString stringWithFormat:@"%zd元 %zd注",listModel.bettingCount * 2,listModel.bettingCount];
    // 强制布局
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
