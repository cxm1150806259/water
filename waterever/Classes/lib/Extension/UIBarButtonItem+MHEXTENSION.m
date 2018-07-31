//
//  UIBarButtonItem+MHEXTENSION.m
//  SinaWeibo
//
//  Created by qyyue on 2016/12/7.
//  Copyright © 2016年 qyyue. All rights reserved.
//

#import "UIBarButtonItem+MHEXTENSION.h"
#import "UIView+MHEXTENSION.h"

@implementation UIBarButtonItem (MHEXTENSION)
+(instancetype)itemWithTitle:(NSString *)title Target:(id)target Action:(SEL)action{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.size=btn.currentImage.size;
    btn.size = CGSizeMake(30, 30);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

+(instancetype)itemWithImage:(NSString *)image HighlightedImage:(NSString *)highLighted{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLighted] forState:UIControlStateHighlighted];
//    btn.size=btn.currentImage.size;
    btn.size = CGSizeMake(30, 30);
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

+(instancetype)itemWithImage:(NSString *)image HighlightedImage:(NSString *)highLighted Target:(id)target Action:(SEL)action{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLighted] forState:UIControlStateHighlighted];
//    btn.size=btn.currentImage.size;
    btn.size = CGSizeMake(30, 30);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
@end
