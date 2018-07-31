//
//  MHHomeTopView.m
//  waterever
//
//  Created by qyyue on 2017/11/13.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHHomeTopView.h"
#import "MHCirclePerventView.h"
#import "POP.h"

@interface MHHomeTopView()
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;//单位
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;//剩余多少
@property (weak, nonatomic) IBOutlet UILabel *showLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *appltStatusLabel;//申请状态
@property (weak, nonatomic) IBOutlet MHCirclePerventView *homeTopView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)editBtnClicked;

@end
@implementation MHHomeTopView

-(instancetype)init{
    if(self = [super init]){
        self = [[[NSBundle mainBundle]loadNibNamed:@"MHHomeTopView" owner:self options:nil]lastObject];
        [self initCircleView];
    }
    return self;
}

-(void)initCircleView{
    [self.homeTopView drawCircleWithPercent:0 duration:1 lineWidth:12 clockwise:YES lineCap:kCALineCapRound fillColor:[UIColor clearColor] strokeColor:[UIColor whiteColor] animatedColors:nil];
    self.homeTopView.percentLabel.hidden = YES;
    [self.homeTopView startAnimation];
}

-(void)setHomeStatusModel:(MHHomeStatusModel *)homeStatusModel{
    _homeStatusModel = homeStatusModel;
    [self setContentWithHomeStatusModel:homeStatusModel];
}

-(void)setContentWithHomeStatusModel:(MHHomeStatusModel *)model{
    NSArray *statusArr1 = @[@"1",@"2",@"8"];
    NSArray *statusArr2 = @[@"4",@"5",@"6",@"10",@"11"];
    float circlePercent = 0;
    if(model){
        if([statusArr1 containsObject:model.applyStatus]){
            //申请中
            self.leftLabel.text = @"等待安装";
            self.appltStatusLabel.text = @"已申请";
            self.unitLabel.hidden = YES;
            self.showLeftLabel.hidden = YES;
        }else if([statusArr2 containsObject:model.applyStatus]){
            //未申请
            self.leftLabel.text = @"未来水源";
            self.appltStatusLabel.text = @"未申请";
            //用户移除设备后需要隐藏
            self.unitLabel.hidden = YES;
            self.showLeftLabel.hidden = YES;
            
        }else if([model.applyStatus isEqualToString:@"3"]){
            //设备已安装
            self.editBtn.hidden = NO;
            circlePercent = 100 * [model.streamOrPeriod floatValue]/[model.allStreamOrPeriod floatValue];
            self.unitLabel.hidden = NO;
            self.showLeftLabel.hidden = NO;
            self.appltStatusLabel.text = model.deviceName;
            POPBasicAnimation *anim = [POPBasicAnimation animation];
            anim.duration = 0.5;
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) { prop.readBlock = ^(id obj, CGFloat values[]) {
                values[0] = [[obj description] floatValue];};
                prop.writeBlock = ^(id obj, const CGFloat values[]) {
                    [obj setText:[NSString stringWithFormat:@"%.f",values[0]]];};
                prop.threshold = 1;}];
            anim.property = prop;
            
            int salePackageType = [model.salePackageType intValue];
            if(salePackageType == 1){
                //周期套餐
                anim.fromValue = @(0);
                self.unitLabel.text = @"天";
            }else if(salePackageType == 2){
                //流量套餐
                anim.fromValue = @(0.0);
                self.unitLabel.text = @"L";
            }
            anim.toValue = model.streamOrPeriod?@([model.streamOrPeriod intValue]):@0;;
            [self.leftLabel pop_addAnimation:anim forKey:@"counting"];
        }else{
            self.editBtn.hidden = YES;
            self.leftLabel.text = @"未来水源";
            self.appltStatusLabel.text = @"未申请";
            self.unitLabel.hidden = YES;
            self.showLeftLabel.hidden = YES;
        }
    }else{
        //如果model没获取到就显示默认
        self.editBtn.hidden = YES;
        self.leftLabel.text = @"未来水源";
        self.appltStatusLabel.text = @"未申请";
        self.unitLabel.hidden = YES;
        self.showLeftLabel.hidden = YES;
    }
    
    [self.homeTopView drawCircleWithPercent:circlePercent duration:1 lineWidth:12 clockwise:YES lineCap:kCALineCapRound fillColor:[UIColor clearColor] strokeColor:[UIColor whiteColor] animatedColors:nil];
    self.homeTopView.percentLabel.hidden = YES;
    [self.homeTopView startAnimation];
}

- (IBAction)editBtnClicked {    
    if([self.delegate respondsToSelector:@selector(editMachineName:)]){
        [self.delegate editMachineName:self.appltStatusLabel];
    }
}
@end
