//
//  MHMessageTool.h
//  waterever
//
//  Created by qyyue on 2017/9/1.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHMessageModel.h"
@interface MHMessageTool : NSObject
+(void)saveMessageWithDictionary:(NSDictionary *)dic;
+(NSMutableArray<MHMessageModel *> *)getMessageArry;
+(void)deleteWithMsgId:(NSString *)msgId;
@end
