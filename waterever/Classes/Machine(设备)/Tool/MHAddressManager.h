//
//  MHAddressManager.h
//  waterever
//
//  Created by qyyue on 2017/8/28.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface MHAddressManager : NSObject
singleton_interface(MHAddressManager)
@property (nonatomic,strong) NSArray *provinceDicAry;//省字典数组

#define kAddressManager [MHAddressManager sharedMHAddressManager]
@end
