//
//  MHActivityTableViewCell.h
//  waterever
//
//  Created by qyyue on 2017/11/30.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHActivityModel.h"

@interface MHActivityTableViewCell : UITableViewCell

@property(nonatomic,strong) MHActivityModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
