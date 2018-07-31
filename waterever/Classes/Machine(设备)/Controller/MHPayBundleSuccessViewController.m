//
//  MHPayBundleSuccessViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHPayBundleSuccessViewController.h"
#import "UIBarButtonItem+MHEXTENSION.h"

@interface MHPayBundleSuccessViewController ()
- (IBAction)submitBtnClicked;

@end

@implementation MHPayBundleSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买成功";
}
- (IBAction)submitBtnClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
