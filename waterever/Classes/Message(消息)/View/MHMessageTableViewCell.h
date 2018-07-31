//
//  MHMessageTableViewCell.h
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHMessageModel.h"

@interface MHMessageTableViewCell : UITableViewCell

@property(nonatomic,strong)MHMessageModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
