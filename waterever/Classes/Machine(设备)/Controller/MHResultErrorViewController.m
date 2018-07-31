//
//  MHResultErrorViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHResultErrorViewController.h"

@interface MHResultErrorViewController ()
- (IBAction)okBtnClicked;

@end

@implementation MHResultErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)okBtnClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
