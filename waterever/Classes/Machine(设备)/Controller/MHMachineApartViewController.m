//
//  MHMachineApartViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMachineApartViewController.h"
#import "MHMachineApartApplyViewController.h"

@interface MHMachineApartViewController ()
- (IBAction)apartBtnClicked;
- (IBAction)continueBtnClicked;

@end

@implementation MHMachineApartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请拆机";
}

- (IBAction)apartBtnClicked {
    MHMachineApartApplyViewController *apartApplyVc = [[MHMachineApartApplyViewController alloc]init];
    apartApplyVc.deviceCode = self.deviceCode;
    [self.navigationController pushViewController:apartApplyVc animated:YES];
    
}

- (IBAction)continueBtnClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
