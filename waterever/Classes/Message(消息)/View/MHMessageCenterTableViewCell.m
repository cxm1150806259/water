//
//  MHMessageCenterTableViewCell.m
//  waterever
//
//  Created by qyyue on 2017/11/27.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMessageCenterTableViewCell.h"

@implementation MHMessageCenterTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier=@"cellMessageCenterIdentifier";
    MHMessageCenterTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MHMessageCenterTableViewCell" owner:self options:nil]lastObject];
    }
    
    return cell;
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
