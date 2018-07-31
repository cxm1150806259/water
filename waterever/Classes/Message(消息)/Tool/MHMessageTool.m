//
//  MHMessageTool.m
//  waterever
//
//  Created by qyyue on 2017/9/1.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMessageTool.h"
#import <FMDB/FMDB.h>
#import "MHUserInfoTool.h"
#import <MJExtension/MJExtension.h>


#define MESSAGECHEPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"waterever.db"]

@implementation MHMessageTool

static FMDatabaseQueue *_queue;

+(void)initialize{
    _queue=[FMDatabaseQueue databaseQueueWithPath:MESSAGECHEPATH];
    [_queue inDatabase:^(FMDatabase *db) {
        if([db executeUpdate:[NSString stringWithFormat:@"create table if not exists msg%@(id integer primary key autoincrement,msgType varchar(20),msgTitle varchar(20),msgDate varchar(20),msgText varchar(100))",[MHUserInfoTool sharedMHUserInfoTool].phone]]){
            NSLog(@"创建成功");
        }
    }];
}

+(void)saveMessageWithDictionary:(NSDictionary *)dic{
    //字典转模型
    MHMessageModel *model = [MHMessageModel mj_objectWithKeyValues:dic];
    _queue=[FMDatabaseQueue databaseQueueWithPath:MESSAGECHEPATH];
    [_queue inDatabase:^(FMDatabase *db) {
        if([db executeUpdate:[NSString stringWithFormat:@"insert into msg%@(msgType,msgTitle,msgDate,msgText) values(?,?,?,?)",[MHUserInfoTool sharedMHUserInfoTool].phone],model.extras.type,model.extras.title,model.extras.date,model.content]){
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    }];
}

+(NSMutableArray<MHMessageModel *> *)getMessageArry{
    
    __block NSMutableArray *arrM = [NSMutableArray array];
    
    _queue=[FMDatabaseQueue databaseQueueWithPath:MESSAGECHEPATH];
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [[FMResultSet alloc]init];
        result = [db executeQuery:[NSString stringWithFormat:@"select * from msg%@ order by id desc",[MHUserInfoTool sharedMHUserInfoTool].phone]];
        
        while ([result next]) {
            MHMessageModel *model = [[MHMessageModel alloc]init];
            model.extras = [[MHMessageExtrasModel alloc]init];
            model.msgId = [result stringForColumn:@"id"];
            model.content = [result stringForColumn:@"msgText"];
            model.extras.title = [result stringForColumn:@"msgTitle"];
            model.extras.type = [result stringForColumn:@"msgType"];
            model.extras.date = [result stringForColumn:@"msgDate"];
            [arrM addObject:model];
        }

    }];
    
    return arrM;
}

+(void)deleteWithMsgId:(NSString *)msgId{
    _queue=[FMDatabaseQueue databaseQueueWithPath:MESSAGECHEPATH];
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:[NSString stringWithFormat:@"delete from msg%@ where id = ?",[MHUserInfoTool sharedMHUserInfoTool].phone],msgId];
    }];
}
@end
