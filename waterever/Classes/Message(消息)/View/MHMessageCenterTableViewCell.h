//
//  MHMessageCenterTableViewCell.h
//  waterever
//
//  Created by qyyue on 2017/11/27.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHMessageCenterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
