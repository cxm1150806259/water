//
//  MHAccountTableViewCell.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHAccountTableViewCell.h"

@interface MHAccountTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *functionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation MHAccountTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier=@"cellAccountIdentifier";
    MHAccountTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MHAccountTableViewCell" owner:self options:nil]lastObject];
    }
    
    return cell;
}

-(void)setModel:(MHAccountFunctionsModel *)model{
    _model = model;
    self.functionLabel.text = model.function;
    self.iconImageView.image = [UIImage imageNamed:model.icon];
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
