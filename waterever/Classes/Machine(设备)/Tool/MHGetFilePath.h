//
//  MHGetFilePath.h
//  waterever
//
//  Created by qyyue on 2017/8/28.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MHGetFilePath : NSObject
//获取要保存的本地文件路径
+ (NSString *)getSavePathWithFileSuffix:(NSString *)suffix;
+ (UIImage *)getImage:(NSString *)filePath;
@end
