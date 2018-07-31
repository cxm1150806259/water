//
//  MHOrderServeModel.h
//  waterever
//
//  Created by qyyue on 2017/11/7.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHOrderServeModel : NSObject
@property(nonatomic,strong) NSString *dateAppointment;
@property(nonatomic,strong) NSString *customerName;
@property(nonatomic,strong) NSString *customerPhone;
@property(nonatomic,strong) NSString *area;//区域
@property(nonatomic,strong) NSString *address;//详细地址
@end
