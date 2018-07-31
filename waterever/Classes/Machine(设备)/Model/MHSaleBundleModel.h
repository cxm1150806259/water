//
//  MHSaleBundleModel.h
//  waterever
//
//  Created by qyyue on 2017/8/30.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHSaleBundleModel : NSObject
@property(nonatomic,strong) NSString *salePackageId;
@property(nonatomic,strong) NSString *salePackageName;
@property(nonatomic,strong) NSString *salePackageTypeId;
@property(nonatomic,strong) NSString *streamOrPeriod;
@property(nonatomic,strong) NSString *salePrice;
@property(nonatomic,strong) NSString *firstTitle;
@property(nonatomic,strong) NSString *secondTitle;
@property(nonatomic,strong) NSString *dateModified;
@property(nonatomic,strong) NSString *dateCreated;
@end
