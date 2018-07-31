//
//  MHResultSuccessViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHResultSuccessViewController.h"
#import "MHSelectBundleViewController.h"
#import "UIBarButtonItem+MHEXTENSION.h"

@interface MHResultSuccessViewController ()
- (IBAction)okBtnClicked;

@end

@implementation MHResultSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)okBtnClicked {
//    MHSelectBundleViewController *vc = [[MHSelectBundleViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    vc.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backToRoot)];
//    vc.navigationItem.rightBarButtonItem=nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)backToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
