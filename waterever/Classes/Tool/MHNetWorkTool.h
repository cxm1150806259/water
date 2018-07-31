//
//  MHNetWorkTool.h
//  waterever
//
//  Created by qyyue on 2016/12/29.
//  Copyright © 2016年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHUserInfoTool.h"

#define WATEREVERHOST @"http://japi.waterever.cn:8099/"
//http://192.168.0.115:8094/
//http://japi.waterever.cn:8099/
@interface MHNetWorkTool : NSObject

+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+(void)PATCH:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+(void)POSTWITHHEADER:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+(void)GETWITHHEADER:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+(void)PATCHWITHHEADER:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end
