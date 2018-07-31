//
//  UIButton+MHEXTENSION.h
//  waterever
//
//  Created by qyyue on 2017/9/8.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MHCategoryType) {
    MHCategoryTypeLeft = 0,
    MHCategoryTypeBottom,
};

@interface UIButton (MHEXTENSION)
//验证码倒计时
-(void)countDownWithTimeInterval:(NSTimeInterval) duration;

//图片和文字的位置
- (void)setbuttonType:(MHCategoryType)type;
@end
