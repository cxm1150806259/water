//
//  MHFandomTableViewCell.h
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHFandomInfoModel.h"

@interface MHFandomTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong) MHFandomInfoModel *model;
@end
