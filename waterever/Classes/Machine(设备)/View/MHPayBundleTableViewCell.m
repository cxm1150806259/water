//
//  MHPayBundleTableViewCell.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHPayBundleTableViewCell.h"
#import "MHCommonHeader.h"

@interface MHPayBundleTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;

@end

@implementation MHPayBundleTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier=@"cellPayBundleIdentifier";
    MHPayBundleTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MHPayBundleTableViewCell" owner:self options:nil]lastObject];
        UIView *view = [[UIView alloc]initWithFrame:cell.frame];
        view.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = view;
    }
    
    return cell;
}

-(void)setSaleBundleModel:(MHSaleBundleModel *)saleBundleModel{
    _saleBundleModel = saleBundleModel;
    self.firstTitleLabel.text = _saleBundleModel.firstTitle;
    self.secondTitleLabel.text = _saleBundleModel.secondTitle;
}


@end
