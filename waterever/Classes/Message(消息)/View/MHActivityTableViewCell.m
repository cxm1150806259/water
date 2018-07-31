//
//  MHActivityTableViewCell.m
//  waterever
//
//  Created by qyyue on 2017/11/30.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHActivityTableViewCell.h"
#import "MHCommonHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "POP.h"
@interface MHActivityTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation MHActivityTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier=@"cellActivityIdentifier";
    MHActivityTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MHActivityTableViewCell" owner:self options:nil]lastObject];
    }
    
    return cell;
}

-(void)setModel:(MHActivityModel *)model{
    _model = model;
    
    self.titleLabel.text = model.smallTitle;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.dateCreated doubleValue]/ 1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    self.timeLabel.text = dateString;
    self.numLabel.text = model.watchNum;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.activityImageUrl] placeholderImage:[UIImage imageNamed:@""]];
    
    [self layoutIfNeeded];
    CGFloat cellHeight = CGRectGetMaxY(self.timeLabel.frame) + 14;
    self.model.cellHeight = cellHeight;
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x=10;
    frame.size.width-=2*frame.origin.x;
    //    frame.size.height-=2*frame.origin.x;
    [super setFrame:frame];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
