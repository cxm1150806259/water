//
//  UIImage+MHEXTENSION.h
//  waterever
//
//  Created by qyyue on 2017/9/7.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MHEXTENSION)
// 通过颜色创建UIImage
+(UIImage*)imageWithColor:(UIColor*) color;

-(UIImage*)imageWithCornerRadius:(CGFloat)radius;

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;
@end
