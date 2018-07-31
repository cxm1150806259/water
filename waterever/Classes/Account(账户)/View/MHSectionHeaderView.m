//
//  MHSectionHeaderView.m
//  waterever
//
//  Created by qyyue on 2017/10/9.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHSectionHeaderView.h"
#import "UIView+MHEXTENSION.h"
@interface MHSectionHeaderView()
@property(nonatomic,weak)UIButton *sectionHeaderBtn;
@property(nonatomic,weak)UIImageView *sectionHeaderImageView;
@end


@implementation MHSectionHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithReuseIdentifier:reuseIdentifier]){
        UIButton *sectionHeaderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [sectionHeaderBtn setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forState:UIControlStateNormal];
        [sectionHeaderBtn setImage:[UIImage imageNamed:@"APP2.9-45-rightArror"] forState:UIControlStateNormal];
        sectionHeaderBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
        sectionHeaderBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
        sectionHeaderBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [sectionHeaderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sectionHeaderBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        sectionHeaderBtn.imageView.contentMode = UIViewContentModeCenter; // 不缩放，不压缩
        sectionHeaderBtn.imageView.clipsToBounds = NO;
        [self addSubview:sectionHeaderBtn];
        self.sectionHeaderBtn=sectionHeaderBtn;
        
        UIImageView *sectionHeaderImageView=[[UIImageView alloc]init];
        [self addSubview:sectionHeaderImageView];
        self.sectionHeaderImageView=sectionHeaderImageView;
        
    }
    return  self;
}

-(void)layoutSubviews{
    CGFloat btnX=0;
    CGFloat btnY=btnX;
    CGFloat btnW=self.width;
    CGFloat btnH=self.height;
    self.sectionHeaderBtn.frame=CGRectMake(btnX, btnY, btnW, btnH);
    
    CGFloat iconImageViewX=0;
    CGFloat iconImageViewY=iconImageViewX;
    CGFloat iconImageViewW=self.width-10;
    CGFloat iconImageViewH=self.height;
    self.sectionHeaderImageView.frame=CGRectMake(iconImageViewX, iconImageViewY, iconImageViewW, iconImageViewH);
}



-(void)btnClicked{
    
    if(self.groupModel.groupOpenAndCloseStatus==groupClose){
        self.groupModel.groupOpenAndCloseStatus=groupOpen;
    }else{
        self.groupModel.groupOpenAndCloseStatus=groupClose;
    }
    
    
    if([self.delegate respondsToSelector:@selector(sectionBtnClicked:)]){
        [self.delegate sectionBtnClicked:self];
    }
}


-(void)setGroupModel:(MHGuidanceGroupModel *)groupModel{
    _groupModel=groupModel;
    [self.sectionHeaderBtn setTitle:groupModel.name forState:UIControlStateNormal];
//    self.sectionHeaderImageView.image = [UIImage imageNamed:@"account_img3"];
    [self willMoveToSuperview:nil];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if(self.groupModel.groupOpenAndCloseStatus==groupClose){
        self.sectionHeaderBtn.imageView.transform=CGAffineTransformRotate(self.transform, 0);
    }else{
        self.sectionHeaderBtn.imageView.transform=CGAffineTransformRotate(self.transform, M_PI_2);
    }
}


@end
