//
//  MHExchangeCouponsViewController.m
//  waterever
//
//  Created by qyyue on 2017/11/27.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHExchangeCouponsViewController.h"
#import "UIBarButtonItem+MHEXTENSION.h"

@interface MHExchangeCouponsViewController ()

@end

@implementation MHExchangeCouponsViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.pushType == 1){
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_btn_back_black" HighlightedImage:nil Target:self Action:@selector(back)];
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        
        NSDictionary *titleAttribute=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
        [self.navigationController.navigationBar setTitleTextAttributes:titleAttribute];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换优惠券";
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
