//
//  MHMyBillViewController.h
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHPayDetailModel.h"

@interface MHMyBillViewController : UIViewController
@property(nonatomic,strong) NSMutableArray<MHPayDetailModel *> *payDetailDataArrayM;
@end
