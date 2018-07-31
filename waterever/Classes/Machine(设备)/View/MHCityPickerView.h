//
//  MHCityPickerView.h
//  waterever
//
//  Created by qyyue on 2017/9/28.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHCityPickerView;

@protocol MHCityPickerViewDelegate <NSObject>

NS_ASSUME_NONNULL_BEGIN

/**
 *  告诉代理，用户选择了省市区
 *
 *  @param picker   picker
 *  @param province 省
 *  @param city     市
 *  @param district 区
 */
- (void)cityPickerView:(MHCityPickerView *)picker
    finishPickProvince:(NSString *)province
                  city:(NSString *)city
              district:(NSString *)district;

@end


@interface MHCityPickerView : UIPickerView

@property (nonatomic, weak, nullable) id<MHCityPickerViewDelegate> cityPickerDelegate;

NS_ASSUME_NONNULL_END

@end

