//
//  MHTabBarController.m
//  网易彩票
//
//  Created by qyyue on 2016/11/8.
//  Copyright © 2016年 qyyue. All rights reserved.
//

#import "MHTabBarController.h"
#import "MHNavViewController.h"
#import "MHHomeViewController.h"
#import "MHMessageViewController.h"
#import "MHFandomViewController.h"
#import "MHAccountViewController.h"
#import "UIImage+MHEXTENSION.h"

#define MHUIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0  alpha:1.0]


@interface MHTabBarController ()

@end

@implementation MHTabBarController

+(instancetype)initView{
    return [[self alloc] addChildViewCOntrollers];
}

-(instancetype)addChildViewCOntrollers{
    [self addChildVC:[[MHHomeViewController alloc]init] Title:@"设备" Image:@"tabbar_v2_0_normal" SelectedImage:@"tabbar_v2_0_selected"];
    
    [self addChildVC:[[MHMessageViewController alloc]init] Title:@"消息" Image:@"tabbar_v2_1_normal" SelectedImage:@"tabbar_v2_1_selected"];
    
    
    [self addChildVC:[[MHFandomViewController alloc]init] Title:@"水粉圈" Image:@"tabbar_v2_2_normal" SelectedImage:@"tabbar_v2_2_selected"];
    
    [self addChildVC:[[MHAccountViewController alloc]init] Title:@"账户" Image:@"tabbar_v2_3_normal" SelectedImage:@"tabbar_v2_3_selected"];
    
    return self;
}

-(void)addChildVC:(UIViewController *)childVC Title:(NSString *)title Image:(NSString *)image SelectedImage:(NSString *)selectedImage{
    NSDictionary *titleAttributes=@{NSForegroundColorAttributeName:MHUIColorFromHex(0x19baff)};
    childVC.title=title;
    [childVC.tabBarItem setTitleTextAttributes:titleAttributes forState:UIControlStateSelected];
    childVC.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.image=[UIImage imageNamed:image];
    MHNavViewController *navVC=[[MHNavViewController alloc]initWithRootViewController:childVC];
    [self addChildViewController:navVC];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //去除tabbat上方黑线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
}
@end
