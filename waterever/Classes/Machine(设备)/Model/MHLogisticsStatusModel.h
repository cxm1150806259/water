//
//  MHLogisticsStatusModel.h
//  waterever
//
//  Created by qyyue on 2017/9/8.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHLogisticsStatusModel : NSObject
@property(nonatomic,strong) NSString *ShipperCode; //快递公司编码
@property(nonatomic,strong) NSString *State;//物流状态：2-在途中,3-签收,4-问题件
@property(nonatomic,strong) NSString *LogisticCode;//物流运单号
@property(nonatomic,strong) NSString *EBusinessID;//用户ID
@end
