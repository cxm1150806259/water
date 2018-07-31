//
//  MHReachTool.m
//  waterever
//
//  Created by qyyue on 2017/9/26.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHReachTool.h"
#import "JDStatusBarNotification.h"

@implementation MHReachTool
singleton_implementation(MHReachTool)

+(void)startNotifier{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:[MHReachTool sharedMHReachTool] selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

-(void)reachabilityChanged:(NSNotification *)noti{
    Reachability *currentReach = [noti object];
    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    switch ([currentReach currentReachabilityStatus]) {
        case NotReachable:{
            self.isReachable = NO;
            [JDStatusBarNotification showWithStatus:@"网络连接失败" styleName:JDStatusBarStyleDefault];
            break;
        }
        case ReachableViaWiFi:{
            self.isReachable = YES;
            [JDStatusBarNotification showWithStatus:@"已切换至Wifi网络" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
            break;
        }
        case ReachableViaWWAN:{
            self.isReachable = YES;
            [JDStatusBarNotification showWithStatus:@"正在使用移动网络" dismissAfter:2 styleName:JDStatusBarStyleWarning];
            break;
        }
        default:
            self.isReachable = NO;
            break;
    }
}

+(Boolean)isReachable{
    return [MHReachTool sharedMHReachTool].isReachable;
}

@end
