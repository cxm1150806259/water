//
//  MHMessageModel.h
//  waterever
//
//  Created by qyyue on 2017/9/1.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHMessageExtrasModel.h"

@interface MHMessageModel : NSObject
@property(nonatomic,strong)NSString *msgId;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)MHMessageExtrasModel *extras;

@property(nonatomic,assign) CGFloat cellHeight;
@end
