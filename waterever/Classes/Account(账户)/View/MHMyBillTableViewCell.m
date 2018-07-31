//
//  MHMyBillTableViewCell.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMyBillTableViewCell.h"

@interface MHMyBillTableViewCell()
//@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *paymentTitleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *paymentBodyLabel;
//@property (weak, nonatomic) IBOutlet UILabel *paymentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@end

@implementation MHMyBillTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier=@"cellMyBillIdentifier";
    MHMyBillTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MHMyBillTableViewCell" owner:self options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(MHPayDetailModel *)model{
    _model = model;
    
//    int payType = [model.paymentType intValue];
//    if(payType == 1){
//        self.paymentTypeLabel.text = @"支付宝付款";
//    }else if(payType == 2){
//        self.paymentTypeLabel.text = @"微信付款";
//    }
    
    self.paymentTitleLabel.text = model.paymentTitle;
//    self.paymentBodyLabel.text = model.paymentBody;
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%@元",model.totalMoney];
    
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.dateCreated doubleValue]/ 1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    self.dateCreatedLabel.text = dateString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
