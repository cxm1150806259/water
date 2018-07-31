//
//  MHActivityModel.h
//  waterever
//
//  Created by qyyue on 2017/11/30.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MHActivityModel : NSObject
@property(nonatomic,strong) NSString *activityImageUrl;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *smallTitle;
@property(nonatomic,strong) NSString *activityUrl;
@property(nonatomic,strong) NSString *watchNum;
@property(nonatomic,strong) NSString *dateCreated;

@property(nonatomic,assign) CGFloat cellHeight;
@end
