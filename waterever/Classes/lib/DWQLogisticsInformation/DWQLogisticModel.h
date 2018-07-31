//
//  DWQLogisticModel.h
//  DWQLogisticsInformation
//
//  Created by 杜文全 on 16/7/9.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DWQLogisticModel : NSObject
@property (copy, nonatomic)NSString *AcceptStation;
@property (copy, nonatomic)NSString *AcceptTime;
@property (assign, nonatomic, readonly)CGFloat height;
@end
