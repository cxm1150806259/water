//
//  UIWindow+MHEXTENSION.m
//  waterever
//
//  Created by qyyue on 2017/9/8.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "UIWindow+MHEXTENSION.h"
#import "MHNewFeatureViewController.h"
#import "MHUserInfoTool.h"
#import "MHLoginViewController.h"
#import "MHNavViewController.h"
#import "MHHomeViewController.h"

//下个版本删除
#define APPPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

@implementation UIWindow (MHEXTENSION)
-(void)switchRootController{
    
    //加载本地用户数据
    [MHUserInfoTool loadUserInfo];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *oldVersion=[userDefaults stringForKey:@"CFBundleShortVersionString"];
    
    NSString *newVersion=[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    
    if([oldVersion isEqualToString:newVersion]){
        
        MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
        
        if(userInfo.isLogin){
            //判断时间戳
            NSDate *nowDate = [NSDate date];
            NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970] * 1000;
            NSTimeInterval limitTimeInterval = [userInfo.tokenLimitDate doubleValue];
            if(nowTimeInterval >= limitTimeInterval){
                self.rootViewController = [[MHNavViewController alloc]initWithRootViewController:[[MHLoginViewController alloc]init]];
            }else{
                self.rootViewController = [[MHNavViewController alloc]initWithRootViewController:[[MHHomeViewController alloc]init]];
            }
            
        }else{
            self.rootViewController = [[MHNavViewController alloc]initWithRootViewController:[[MHLoginViewController alloc]init]];
        }
    }else{
        self.rootViewController = [[MHNewFeatureViewController alloc]init];
        [userDefaults setObject:newVersion forKey:@"CFBundleShortVersionString"];
        [userDefaults synchronize];
    }
}

@end
