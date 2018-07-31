//
//  MHAccountTableViewCell.h
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHAccountFunctionsModel.h"

@interface MHAccountTableViewCell : UITableViewCell

@property(nonatomic,strong) MHAccountFunctionsModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
