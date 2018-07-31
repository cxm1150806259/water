//
//  MHMessageTableViewCell.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMessageTableViewCell.h"
#import "POP.h"

@interface MHMessageTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *msgTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
@implementation MHMessageTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellIdentifier=@"cellMessageIdentifier";
    MHMessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MHMessageTableViewCell" owner:self options:nil]lastObject];
    }
    
    return cell;
}

-(void)setModel:(MHMessageModel *)model{
    _model = model;
    self.msgTitleLabel.text = model.extras.title;
    self.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"msg_icon%@",model.extras.type]];
    self.msgTextLabel.text = model.content;
    
    [self layoutIfNeeded];
    CGFloat cellHeight = CGRectGetMaxY(self.msgTextLabel.frame) + 10;
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
