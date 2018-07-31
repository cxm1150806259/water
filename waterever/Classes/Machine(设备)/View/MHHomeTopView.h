//
//  MHHomeTopView.h
//  waterever
//
//  Created by qyyue on 2017/11/13.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHHomeStatusModel.h"

@protocol MHHomeTopViewDelegate <NSObject>
-(void)editMachineName:(UILabel *)nameLabel;
@end

@interface MHHomeTopView : UIView
@property(nonatomic,strong) MHHomeStatusModel *homeStatusModel;
@property(nonatomic,strong) id<MHHomeTopViewDelegate> delegate;

@end
