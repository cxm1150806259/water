//
//  MHWaterUsageViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHWaterUsageViewController.h"
#import "MHDailyWaterUsageViewController.h"
#import <MaterialControls/MaterialControls.h>
#import "POP.h"

@interface MHWaterUsageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *totalStreamLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayStreamLabel;
@property (weak, nonatomic) IBOutlet MDTextField *machineIdLabel;

- (IBAction)dailyUsageBtnClicked;

@end

@implementation MHWaterUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"流量查询";
    [self setContent];
}

-(void)setContent{
    [self addAnimationWithToValue:@([self.machineStatusModel.streamOrPeriod intValue]) andControl:self.totalStreamLabel];
    [self addAnimationWithToValue:@([self.machineStatusModel.yesterdayStream intValue]) andControl:self.todayStreamLabel];
    
    self.machineIdLabel.text = self.machineStatusModel.deviceCode;
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

- (IBAction)dailyUsageBtnClicked {
    MHDailyWaterUsageViewController *dailyWaterUsageVc = [[MHDailyWaterUsageViewController alloc]init];
    [self.navigationController pushViewController:dailyWaterUsageVc animated:YES];
    
}

@end
