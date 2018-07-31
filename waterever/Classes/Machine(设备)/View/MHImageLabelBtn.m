//
//  MHImageLabelBtn.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHImageLabelBtn.h"
#import "UIView+MHEXTENSION.h"

@implementation MHImageLabelBtn

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.x=0;
    self.imageView.x=CGRectGetMaxX(self.titleLabel.frame)+5;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self sizeToFit];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    frame.size.width+=5;
}

@end
