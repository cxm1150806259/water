//
//  MHHomeStatusModel.h
//  waterever
//
//  Created by qyyue on 2017/8/28.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHHomeStatusModel : NSObject
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *typeInfo;
@property(nonatomic,strong) NSString *levelName;
@property(nonatomic,strong) NSString *leftDaysValue;
@property(nonatomic,strong) NSString *periodExpiredDateString;
@property(nonatomic,strong) NSString *usedTotalWater;
@property(nonatomic,strong) NSString *personId;
@property(nonatomic,strong) NSString *applyStatus;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *applyDeviceId;
@property(nonatomic,strong) NSString *deviceId;
@property(nonatomic,strong) NSString *deviceStatus;
@property(nonatomic,strong) NSString *personDeviceId;
@property(nonatomic,strong) NSString *surplusFlow;
@property(nonatomic,strong) NSString *deviceName;
@property(nonatomic,strong) NSString *allStreamOrPeriod;
@property(nonatomic,strong) NSString *streamOrPeriod;
@property(nonatomic,strong) NSString *salePackageType;
@property(nonatomic,strong) NSString *expressCompanyCode;
@property(nonatomic,strong) NSString *expressCode;
@property(nonatomic,strong) NSString *expressOffice;
@property(nonatomic,strong) NSString *expressDate;
@property(nonatomic,strong) NSString *contactName;
@property(nonatomic,strong) NSString *contactPhone;
@property(nonatomic,strong) NSString *applyDate;
@end
