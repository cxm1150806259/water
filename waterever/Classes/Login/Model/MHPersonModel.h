//
//  MHPersonModel.h
//  waterever
//
//  Created by qyyue on 2017/8/25.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHPersonModel : NSObject<NSCoding>
@property(nonatomic,strong) NSString *applyDeviceId;
@property(nonatomic,strong) NSString *balance;
@property(nonatomic,strong) NSString *personAccount;
@property(nonatomic,strong) NSString *personId;
@property(nonatomic,strong) NSString *personTypeId;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *telePhone;
@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *tokenLimitDate;
@end
