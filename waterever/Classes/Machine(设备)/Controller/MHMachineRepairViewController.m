//
//  MHMachineRepairViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMachineRepairViewController.h"
#import "MHMachineRepairAppliedViewController.h"
#import <MaterialControls/MaterialControls.h>
#import "MHCommonHeader.h"

#define MHUIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0  alpha:1.0]

@interface MHMachineRepairViewController ()
@property(nonatomic,strong) MDButton *oldBtn;
@property (weak, nonatomic) IBOutlet UIView *topBtnsView;
- (IBAction)submitBtnClicked;
@property (weak, nonatomic) IBOutlet MDTextField *descTextField;

@end

@implementation MHMachineRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"故障报修";
    
    [self getMDButton];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
}

-(void)getMDButton{
    for (MDButton *btn in self.topBtnsView.subviews) {
        [btn addTarget:self action:@selector(mdButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)mdButtonClicked:(MDButton *)btn{
    self.oldBtn.enabled = YES;
    
    btn.enabled = NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"3-25"] forState:UIControlStateDisabled];
    
    self.oldBtn = btn;
}

- (IBAction)submitBtnClicked {
    if(!self.oldBtn){
        [SVProgressHUD showErrorWithStatus:@"请选择故障类型"];
        return;
    }
    if([self.descTextField.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"备注不能为空"];
        return;
    }
    
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userInfo.personDeviceId forKey:@"person_device_id"];
    [parameters setObject:self.descTextField.text forKey:@"error_remark"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",self.oldBtn.tag] forKey:@"device_error_type_id"];
    
    
    [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"device/2.0/device_error"] parameters:parameters success:^(id responseObject) {
        long code = [responseObject[@"code"] longValue];
        if(code == 0){
            MHMachineRepairAppliedViewController *appliedVc = [[MHMachineRepairAppliedViewController alloc]init];
            [self.navigationController pushViewController:appliedVc animated:YES];
            appliedVc.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backToRoot)];
            appliedVc.navigationItem.rightBarButtonItem=nil;
        }else if(code == -1){
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:nil];
}

-(void)backToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
