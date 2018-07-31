//
//  MHReachTool.h
//  waterever
//
//  Created by qyyue on 2017/9/26.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "Reachability.h"
@interface MHReachTool : NSObject
singleton_interface(MHReachTool)

@property(nonatomic,assign) BOOL isReachable;


+(void)startNotifier;

+(Boolean)isReachable;
@end
