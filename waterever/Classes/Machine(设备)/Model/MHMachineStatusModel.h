//
//  MHMachineStatusModel.h
//  waterever
//
//  Created by qyyue on 2017/8/30.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHMachineStatusModel : NSObject
//"status": 1,
//"deviceId": 11289,
//"deviceCode": "M631116M0202N0001175;861853030041735;898602B4111630298693",
//"batterySOC": null,
//"dateCreated": 1504074705000,
//"deviceMac": null,
//"batteryStatus": null,
//"elecSwitchStatus": 0
@property(nonatomic,strong) NSString *deviceId;
@property(nonatomic,strong) NSString *deviceCode;
@property(nonatomic,strong) NSString *dateCreated;
@property(nonatomic,strong) NSString *batteryStatus;
@property(nonatomic,strong) NSString *elecSwitchStatus;
@property(nonatomic,strong) NSString *salePackageType;
@property(nonatomic,strong) NSString *streamOrPeriod;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *expirationDate;
@property(nonatomic,strong) NSString *yesterdayStream;
@property(nonatomic,strong) NSString *batterySOC;
@property(nonatomic,strong) NSString *deviceName;

@end
