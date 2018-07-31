//
//  MHFandomInfoModel.h
//  waterever
//
//  Created by qyyue on 2017/9/7.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MHFandomInfoModel : NSObject
@property(nonatomic,strong) NSString *dateCreated;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *smallTitle;
@property(nonatomic,strong) NSString *articleImageUrl;
@property(nonatomic,strong) NSString *articleUrl;

@property(nonatomic,assign) CGFloat cellHeight;
@end
