//
//  MHUserInfoTool.h
//  waterever
//
//  Created by qyyue on 2017/8/25.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
//#import "MHPersonModel.h"

@interface MHUserInfoTool : NSObject
singleton_interface(MHUserInfoTool)
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *personId;
@property(nonatomic,strong) NSString *applyDeviceId;
@property(nonatomic,strong) NSString *personDeviceId;
@property(nonatomic,strong) NSString *deviceId;
@property(nonatomic,strong) NSString *applyStatus;
@property(nonatomic,strong) NSString *token;
@property(nonatomic,assign) BOOL isLogin;
@property(nonatomic,strong) NSString *currentStepVc;
@property(nonatomic,strong) NSString *telePhone;
@property(nonatomic,strong) NSString *personTypeId;
@property(nonatomic,strong) NSString *personAccount;
@property(nonatomic,strong) NSString *userSurportUrlString;
@property(nonatomic,strong) NSString *shareRuleUrlString;
@property(nonatomic,strong) NSString *tokenLimitDate;
@property(nonatomic,assign) BOOL hasNewMsg;

+(void)saveUserInfo;
+(void)loadUserInfo;
@end
