//
//  MHGuidanceGroupModel.h
//  waterever
//
//  Created by qyyue on 2017/10/9.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    groupClose,
    groupOpen,
}groupOpenAndClose;

@interface MHGuidanceGroupModel : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSArray *intros;
@property(nonatomic,strong)NSArray *icon;
@property(nonatomic,assign)groupOpenAndClose groupOpenAndCloseStatus;

+(instancetype)groupModelWithDictionary:(NSDictionary *)dic;
@end
