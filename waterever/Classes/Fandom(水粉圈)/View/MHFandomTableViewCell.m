//
//  MHFandomTableViewCell.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHFandomTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "POP.h"
@interface MHFandomTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *seeAllLabel;//最后一个计算cell高度

@end

@implementation MHFandomTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *cellIdentifier=@"cellFandomIdentifier";
    
    MHFandomTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MHFandomTableViewCell" owner:self options:nil]lastObject];
    }
    return cell;
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x=10;
    frame.size.width-=2*frame.origin.x;
    //    frame.size.height-=2*frame.origin.x;
    [super setFrame:frame];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0;
}

-(void)setModel:(MHFandomInfoModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.articleImageUrl] placeholderImage:[UIImage imageNamed:@"APP-42"]];
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.dateCreated doubleValue]/ 1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    self.timeLabel.text = dateString;
    self.smallTitleLabel.text = model.smallTitle;
    
    [self layoutIfNeeded];
    
    CGFloat cellHeight = CGRectGetMaxY(self.seeAllLabel.frame) + 14;
    self.model.cellHeight = cellHeight;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
        [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    } else {
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        scaleAnimation.springBounciness = 20.f;
        [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}

@end
