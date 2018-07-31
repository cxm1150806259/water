//
//  MHNetWorkTool.m
//  waterever
//
//  Created by qyyue on 2016/12/29.
//  Copyright © 2016年 qyyue. All rights reserved.
//

#import "MHNetWorkTool.h"
#import "AFNetworking.h"

@implementation MHNetWorkTool

static AFHTTPSessionManager *mgr ;

+ (AFHTTPSessionManager *)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [AFHTTPSessionManager manager];
        mgr.requestSerializer.timeoutInterval = 5.0;
    });
    return mgr;
}


+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    mgr=[MHNetWorkTool manager];
    
    [mgr.requestSerializer setTimeoutInterval:3.0];
    NSLog(@"请求网址L：%@",URLString);
    
    [mgr POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
    }];

}

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    mgr=[MHNetWorkTool manager];
    [mgr.requestSerializer setTimeoutInterval:3.0];
    [mgr GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
    }];

}

+(void)POSTWITHHEADER:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    mgr=[MHNetWorkTool manager];
    [mgr.requestSerializer setTimeoutInterval:3.0];
    [mgr.requestSerializer setValue:userInfo.token forHTTPHeaderField:@"Authorization"];
    [mgr POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
    }];
}

+(void)GETWITHHEADER:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    mgr=[MHNetWorkTool manager];
    [mgr.requestSerializer setTimeoutInterval:3.0];
    [mgr.requestSerializer setValue:userInfo.token forHTTPHeaderField:@"Authorization"];
    [mgr GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
    }];
}

+(void)PATCH:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    mgr=[MHNetWorkTool manager];
    [mgr.requestSerializer setTimeoutInterval:3.0];
    [mgr PATCH:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
    }];
}

+(void)PATCHWITHHEADER:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    mgr=[MHNetWorkTool manager];
    [mgr.requestSerializer setTimeoutInterval:3.0];
    [mgr.requestSerializer setValue:userInfo.token forHTTPHeaderField:@"Authorization"];
    [mgr PATCH:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
    }];
}
@end
