//
//  MHChangeTelViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHChangeTelViewController.h"
#import "MHChangeTelAppliedViewController.h"

@interface MHChangeTelViewController ()
- (IBAction)changeBtnClicked;

@end

@implementation MHChangeTelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"换绑手机";
}

- (IBAction)changeBtnClicked {
    MHChangeTelAppliedViewController *vc = [[MHChangeTelAppliedViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
