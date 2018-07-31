//
//  MHBundleUsageViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHBundleUsageViewController.h"
#import <MaterialControls/MaterialControls.h>
#import "POP.h"

@interface MHBundleUsageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *leftDaysLabel;
@property (weak, nonatomic) IBOutlet MDTextField *expireDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayStreamLabel;
- (IBAction)searchBtnClicked;
@property (weak, nonatomic) IBOutlet MDTextField *machineIdLabel;

@end

@implementation MHBundleUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"套餐查询";
    [self setContent];
}

-(void)setContent{
    self.machineIdLabel.text = self.machineStatusModel.deviceCode;
    
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.machineStatusModel.expirationDate doubleValue]/ 1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    self.expireDateLabel.text = dateString;
    
    
    [self addAnimationWithToValue:@([self.machineStatusModel.streamOrPeriod intValue]) andControl:self.leftDaysLabel];
    [self addAnimationWithToValue:@([self.machineStatusModel.yesterdayStream intValue]) andControl:self.todayStreamLabel];
}

-(void)addAnimationWithToValue:(id)toValue andControl:(id)obj{
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    anim.duration = 0.5;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) { prop.readBlock = ^(id obj, CGFloat values[]) {
        values[0] = [[obj description] floatValue];};
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setText:[NSString stringWithFormat:@"%.f",values[0]]];};
        prop.threshold = 1;}];
    anim.property = prop;
    anim.fromValue = @(0.0);
    anim.toValue = toValue;
    [obj pop_addAnimation:anim forKey:@""];
}

- (IBAction)searchBtnClicked {
    
}
@end
