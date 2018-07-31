//
//  MHUserInfoTool.m
//  waterever
//
//  Created by qyyue on 2017/8/25.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHUserInfoTool.h"
@implementation MHUserInfoTool
singleton_implementation(MHUserInfoTool)

+(void)saveUserInfo{
    MHUserInfoTool *userInfo=[MHUserInfoTool sharedMHUserInfoTool];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userInfo.phone forKey:@"phone"];
    [userDefaults setObject:userInfo.applyDeviceId forKey:@"applyDeviceId"];
    [userDefaults setObject:userInfo.personId forKey:@"personId"];
    [userDefaults setObject:userInfo.token forKey:@"token"];
    [userDefaults setBool:userInfo.isLogin forKey:@"isLogin"];
    [userDefaults setObject:userInfo.currentStepVc forKey:@"currentStepVc"];
    [userDefaults setObject:userInfo.personDeviceId forKey:@"personDeviceId"];
    [userDefaults setObject:userInfo.deviceId forKey:@"deviceId"];
    [userDefaults setObject:userInfo.applyStatus forKey:@"applyStatus"];
    [userDefaults setObject:userInfo.telePhone forKey:@"telePhone"];
    [userDefaults setObject:userInfo.personTypeId forKey:@"personTypeId"];
    [userDefaults setObject:userInfo.personAccount forKey:@"personAccount"];
    [userDefaults setObject:userInfo.userSurportUrlString forKey:@"userSurportUrlString"];
    [userDefaults setObject:userInfo.shareRuleUrlString forKey:@"shareRuleUrlString"];
    [userDefaults setObject:userInfo.tokenLimitDate forKey:@"tokenLimitDate"];
    [userDefaults setBool:userInfo.hasNewMsg forKey:@"hasNewMsg"];
    [userDefaults synchronize];
}

+(void)loadUserInfo{
    MHUserInfoTool *userInfo=[MHUserInfoTool sharedMHUserInfoTool];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    userInfo.phone=[userDefaults objectForKey:@"phone"];
    userInfo.applyDeviceId=[userDefaults objectForKey:@"applyDeviceId"];
    userInfo.personId=[userDefaults objectForKey:@"personId"];
    userInfo.token=[userDefaults objectForKey:@"token"];
    userInfo.isLogin=[userDefaults boolForKey:@"isLogin"];
    userInfo.currentStepVc = [userDefaults objectForKey:@"currentStepVc"];
    userInfo.personDeviceId=[userDefaults objectForKey:@"personDeviceId"];
    userInfo.deviceId=[userDefaults objectForKey:@"deviceId"];
    userInfo.applyStatus=[userDefaults objectForKey:@"applyStatus"];
    userInfo.telePhone=[userDefaults objectForKey:@"telePhone"];
    userInfo.personTypeId=[userDefaults objectForKey:@"personTypeId"];
    userInfo.personAccount=[userDefaults objectForKey:@"personAccount"];
    userInfo.userSurportUrlString=[userDefaults objectForKey:@"userSurportUrlString"];
    userInfo.shareRuleUrlString=[userDefaults objectForKey:@"shareRuleUrlString"];
    userInfo.tokenLimitDate=[userDefaults objectForKey:@"tokenLimitDate"];
    userInfo.hasNewMsg=[userDefaults boolForKey:@"hasNewMsg"];
}
@end
