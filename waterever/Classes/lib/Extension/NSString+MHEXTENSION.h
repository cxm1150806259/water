//
//  NSString+MHEXTENSION.h
//  waterever
//
//  Created by qyyue on 2017/8/25.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MHEXTENSION)
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
-(BOOL)isEmail;
-(BOOL)isIdentityCardNumber;
-(BOOL)isMobileNumber;
-(BOOL)isNameValid;
- (CGSize)stringSizeWithFont:(UIFont *)font Size:(CGSize)size;

@end
