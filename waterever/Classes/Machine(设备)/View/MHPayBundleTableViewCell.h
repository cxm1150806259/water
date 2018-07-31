//
//  MHPayBundleTableViewCell.h
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHSaleBundleModel.h"

@interface MHPayBundleTableViewCell : UITableViewCell

@property(nonatomic,strong) MHSaleBundleModel *saleBundleModel;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
