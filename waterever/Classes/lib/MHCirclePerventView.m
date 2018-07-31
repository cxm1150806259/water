//
//  MHCirclePerventView.m
//  waterever
//
//  Created by qyyue on 2017/10/17.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHCirclePerventView.h"
#define kStartAngle -M_PI_2
#import "UIView+MHEXTENSION.h"
#import <pop/pop.h>

@interface MHCirclePerventView()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *circle;
@property (nonatomic) CGPoint centerPoint;
@property (nonatomic) CGFloat duration;
@property (nonatomic) CGFloat percent;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) NSString *lineCap; // kCALineCapButt, kCALineCapRound, kCALineCapSquare
@property (nonatomic) BOOL clockwise;
@property (nonatomic, strong) NSMutableArray *colors;
@end

@implementation MHCirclePerventView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [self commonInit];
}

- (void)commonInit {
    self.backgroundLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.backgroundLayer];
    
    self.circle = [CAShapeLayer layer];
    [self.layer addSublayer:self.circle];
    
    self.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height / 2)];
    [self addSubview:self.percentLabel];
    
    //新增起点圆点
    //    self.startCircle = [CAShapeLayer layer];
    //    [self.layer addSublayer:self.startCircle];
    
    self.colors = [NSMutableArray new];
}

- (void)drawCircleWithPercent:(CGFloat)percent
                     duration:(CGFloat)duration
                    lineWidth:(CGFloat)lineWidth
                    clockwise:(BOOL)clockwise
                      lineCap:(NSString *)lineCap
                    fillColor:(UIColor *)fillColor
                  strokeColor:(UIColor *)strokeColor
               animatedColors:(NSArray *)colors {
    
    self.duration = duration;
    self.percent = percent;
    self.lineWidth = lineWidth;
    self.clockwise = clockwise;
    [self.colors removeAllObjects];
    if (colors != nil) {
        for (UIColor *color in colors) {
            [self.colors addObject:(id)color.CGColor];
        }
    } else {
        [self.colors addObject:(id)strokeColor.CGColor];
    }
    
    CGFloat min = MIN(self.frame.size.width, self.frame.size.height);
    self.radius = (min - lineWidth)  / 2;
    self.centerPoint = CGPointMake(self.frame.size.width / 2 - self.radius, self.frame.size.height / 2 - self.radius);
    self.lineCap = lineCap;
    
    [self setupBackgroundLayerWithFillColor:fillColor];
    [self setupCircleLayerWithStrokeColor:strokeColor];
    [self setupPercentLabel];
}

- (void)drawPieChartWithPercent:(CGFloat)percent
                       duration:(CGFloat)duration
                      clockwise:(BOOL)clockwise
                      fillColor:(UIColor *)fillColor
                    strokeColor:(UIColor *)strokeColor
                 animatedColors:(NSArray *)colors {
    
    self.duration = duration;
    self.percent = percent;
    self.clockwise = clockwise;
    [self.colors removeAllObjects];
    if (colors != nil) {
        
        for (UIColor *color in colors) {
            [self.colors addObject:(id)color.CGColor];
        }
    } else {
        [self.colors addObject:(id)strokeColor.CGColor];
    }
    
    CGFloat min = MIN(self.frame.size.width, self.frame.size.height);
    self.lineWidth = min  / 2;
    self.radius = (min - self.lineWidth) / 2;
    self.centerPoint = CGPointMake(self.frame.size.width / 2 - self.radius, self.frame.size.height / 2 - self.radius);
    self.lineCap = kCALineCapButt;
    
    [self setupBackgroundLayerWithFillColor:fillColor];
    [self setupCircleLayerWithStrokeColor:strokeColor];
    [self setupPercentLabel];
}

- (void)setupBackgroundLayerWithFillColor:(UIColor *)fillColor {
    
    self.backgroundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:kStartAngle endAngle:2*M_PI clockwise:self.clockwise].CGPath;
    
    // Center the shape in self.view
    self.backgroundLayer.position = self.centerPoint;
    
    // Configure the apperence of the circle
    self.backgroundLayer.fillColor = fillColor.CGColor;
    self.backgroundLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    self.backgroundLayer.lineWidth = self.lineWidth;
    self.backgroundLayer.lineCap = self.lineCap;
    self.backgroundLayer.rasterizationScale = 2 * [UIScreen mainScreen].scale;
    self.backgroundLayer.shouldRasterize = YES;
    
}

- (void)setupCircleLayerWithStrokeColor:(UIColor *)strokeColor {
    // Set up the shape of the circle
    
    CGFloat endAngle = [self calculateToValueWithPercent:self.percent];
    
    //新增起始圆点
//    self.startCircle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:kStartAngle endAngle:endAngle clockwise:self.clockwise].CGPath;
//    self.startCircle.position = self.centerPoint;
//    self.startCircle.fillColor = [UIColor clearColor].CGColor;
//    self.startCircle.strokeColor = strokeColor.CGColor;
//    self.startCircle.lineWidth = self.lineWidth + 30;
//    self.startCircle.lineCap = self.lineCap;
//    self.startCircle.shouldRasterize = YES;
//    self.startCircle.rasterizationScale = 2 * [UIScreen mainScreen].scale;
    
    
    // Make a circular shape
    self.circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:kStartAngle endAngle:endAngle clockwise:self.clockwise].CGPath;
    

    self.circle.position = self.centerPoint;
    
    self.circle.fillColor = [UIColor clearColor].CGColor;
    self.circle.strokeColor = strokeColor.CGColor;
    self.circle.lineWidth = self.lineWidth;
    self.circle.lineCap = self.lineCap;
    self.circle.shouldRasterize = YES;
    self.circle.rasterizationScale = 2 * [UIScreen mainScreen].scale;
    
}

- (void)setupPercentLabel {
    
    NSLayoutConstraint *centerHor = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.percentLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerVer = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.percentLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    self.percentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[centerHor, centerVer]];
    [self layoutIfNeeded];
    self.percentLabel.text = [NSString stringWithFormat:@"%d%%", (int)self.percent];
}

- (void)startAnimation {
    [self drawBackgroundCircle];
    [self drawCircle];
}

- (void)drawCircle {
//    [self.startCircle removeAllAnimations];
    
    [self.circle removeAllAnimations];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = self.duration;
    drawAnimation.repeatCount         = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
//    [self.startCircle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    [self.circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    
    CAKeyframeAnimation *colorsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    colorsAnimation.values = self.colors;
    //    colorsAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3], [NSNumber numberWithFloat:0.8], [NSNumber numberWithFloat:1.0], nil];
    colorsAnimation.calculationMode = kCAAnimationPaced;
    colorsAnimation.removedOnCompletion = NO;
    colorsAnimation.fillMode = kCAFillModeForwards;
    colorsAnimation.duration = self.duration;
    
//    [self.startCircle addAnimation:colorsAnimation forKey:@"strokeColor"];
    [self.circle addAnimation:colorsAnimation forKey:@"strokeColor"];
}

- (void)drawBackgroundCircle {
    [self.backgroundLayer removeAllAnimations];
    return;
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = self.duration;
    drawAnimation.repeatCount         = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.backgroundLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}

- (CGFloat)calculateToValueWithPercent:(CGFloat)percent {
    return (kStartAngle + (percent * 2 * M_PI) / 100);
}

- (NSArray *)calculateColorsWithPercent:(CGFloat)percent {
    NSMutableArray *colorsArray = [NSMutableArray new];
    if (percent <= 30) {
        [colorsArray addObject:(id)[UIColor greenColor].CGColor];
    }
    
    if (percent > 30 && percent <= 80 ) {
        [colorsArray addObject:(id)[UIColor greenColor].CGColor];
        [colorsArray addObject:(id)[UIColor yellowColor].CGColor];
    }
    
    if (percent > 80) {
        [colorsArray addObject:(id)[UIColor greenColor].CGColor];
        [colorsArray addObject:(id)[UIColor yellowColor].CGColor];
        [colorsArray addObject:(id)[UIColor orangeColor].CGColor];
        [colorsArray addObject:(id)[UIColor redColor].CGColor];
    }
    
    return colorsArray;
}

@end
