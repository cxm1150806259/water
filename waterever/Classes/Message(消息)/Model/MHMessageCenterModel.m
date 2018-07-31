//
//  MHMessageCenterModel.m
//  waterever
//
//  Created by qyyue on 2017/11/30.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMessageCenterModel.h"
#import <MJExtension/MJExtension.h>

@implementation MHMessageCenterModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"activityPageList":@"MHActivityModel"};
}
@end
