//
//  MHAddressManager.m
//  waterever
//
//  Created by qyyue on 2017/8/28.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHAddressManager.h"


@implementation MHAddressManager
singleton_implementation(MHAddressManager)

- (NSArray *)provinceDicAry {
    if (!_provinceDicAry) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
        _provinceDicAry = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _provinceDicAry;
}
@end
