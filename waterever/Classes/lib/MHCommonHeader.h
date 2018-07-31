//
//  MHCommonHeader.h
//  waterever
//
//  Created by qyyue on 2016/12/7.
//  Copyright © 2016年 qyyue. All rights reserved.
//

#import "UIView+MHEXTENSION.h"
#import "UIBarButtonItem+MHEXTENSION.h"
#import "MHTabBarController.h"
#import "UIButton+MHEXTENSION.h"
#import "MHNetWorkTool.h"
#import "NSString+MHEXTENSION.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import <MaterialControls/MaterialControls.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import <FMDB/FMDB.h>
#import "NSString+Hash.h"
#import "POP.h"
#import "MHMDTextField.h"
#import "MHReachTool.h"
#import "MHTextView.h"
#import "UIImage+MHEXTENSION.h"
#import "MHTextField.h"

#define APPPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define MHARCCOLOR [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
#define MHCOLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define MHUIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0  alpha:1.0]
#define SCREENBOUNDS [UIScreen mainScreen].bounds
#define KEYWINDOW [UIApplication sharedApplication].keyWindow
#define TabbarHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) // 适配iPhone x 底栏高度
