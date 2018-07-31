//
//  MHCirclePerventView.h
//  waterever
//
//  Created by qyyue on 2017/10/17.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CirclePercentTypeLine = 0,
    CirclePercentTypePie
} CirclePercentType;
@interface MHCirclePerventView : UIView


@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;
@property (nonatomic, strong) UILabel *percentLabel;

- (void)drawCircleWithPercent:(CGFloat)percent
                     duration:(CGFloat)duration
                    lineWidth:(CGFloat)lineWidth
                    clockwise:(BOOL)clockwise
                      lineCap:(NSString *)lineCap
                    fillColor:(UIColor *)fillColor
                  strokeColor:(UIColor *)strokeColor
               animatedColors:(NSArray *)colors;

- (void)drawPieChartWithPercent:(CGFloat)percent
                       duration:(CGFloat)duration
                      clockwise:(BOOL)clockwise
                      fillColor:(UIColor *)fillColor
                    strokeColor:(UIColor *)strokeColor
                 animatedColors:(NSArray *)colors;

/*
 * Start draw animation
 */
- (void)startAnimation;

@end
