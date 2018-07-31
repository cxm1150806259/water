//
//  MHPayDetailModel.h
//  1
//
//  Created by qyyue on 2017/9/13.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHPayDetailModel : NSObject
//"status": 1,
//"paymentType": 1,
//"tradeNo": "2017091321001004660246646454",
//"totalMoney": 0.01,
//"saleBillDetailId": null,
//"paymentSubject": 0, 0:申请记录  1:周期套餐  2：流量套餐
//"paymentBody": "保证金-498",
//"paymentTitle": "缴纳保证金",
//"applyDeviceId": 11169,
//"personId": 1147,
//"dateCreated": 1505266814000,
//"orderId": "2017091309401406101147",
//"paymentId": 131

@property(nonatomic,strong) NSString *paymentTitle;
@property(nonatomic,strong) NSString *paymentBody;
@property(nonatomic,strong) NSString *paymentType;
//@property(nonatomic,strong) NSString *paymentSubject;
@property(nonatomic,strong) NSString *totalMoney;
@property(nonatomic,strong) NSString *dateCreated;
@end
