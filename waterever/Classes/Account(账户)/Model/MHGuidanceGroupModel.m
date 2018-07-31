//
//  MHGuidanceGroupModel.m
//  waterever
//
//  Created by qyyue on 2017/10/9.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHGuidanceGroupModel.h"

@implementation MHGuidanceGroupModel
-(instancetype)initWithDictionary:(NSDictionary *)dic{
    if(self=[super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return  self;
}

+(instancetype)groupModelWithDictionary:(NSDictionary *)dic{
    return [[self alloc]initWithDictionary:dic];
}
@end
