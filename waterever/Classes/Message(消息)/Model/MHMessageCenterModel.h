//
//  MHMessageCenterModel.h
//  waterever
//
//  Created by qyyue on 2017/11/30.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHFandomInfoModel.h"
#import "MHActivityModel.h"

@interface MHMessageCenterModel : NSObject
@property(nonatomic,strong)MHFandomInfoModel *articleLatest;
@property(nonatomic,strong)MHActivityModel *activityLatest;
@property(nonatomic,strong) NSArray<MHActivityModel *> *activityPageList;

@end
