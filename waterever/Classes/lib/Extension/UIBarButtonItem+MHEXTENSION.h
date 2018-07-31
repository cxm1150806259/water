//
//  UIBarButtonItem+MHEXTENSION.h
//  SinaWeibo
//
//  Created by qyyue on 2016/12/7.
//  Copyright © 2016年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MHEXTENSION)
//+(instancetype)itemWithTitle:(NSString *)title Target:(id)target Action:(SEL)action;
+(instancetype)itemWithImage:(NSString *)image HighlightedImage:(NSString *)highLighted;
+(instancetype)itemWithImage:(NSString *)image HighlightedImage:(NSString *)highLighted Target:(id)target Action:(SEL)action;
@end
