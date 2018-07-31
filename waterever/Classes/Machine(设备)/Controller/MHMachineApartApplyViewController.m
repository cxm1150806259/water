//
//  MHMachineApartApplyViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMachineApartApplyViewController.h"
#import "MHMachineApartAppliedViewController.h"
#import "MHCommonHeader.h"
#import "MHApartAppliedModel.h"

@interface MHMachineApartApplyViewController ()
@property(nonatomic,strong) MDButton *oldBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet MDTextField *descTextField;

- (IBAction)submitBtnClicked;

@end

@implementation MHMachineApartApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请拆机";
    [self getMDButton];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
}

-(void)getMDButton{
    for (MDButton *btn in self.topView.subviews) {
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
        [SVProgressHUD showErrorWithStatus:@"请选择拆机理由"];
        return;
    }
    if([self.descTextField.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"备注不能为空"];
        return;
    }
    
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userInfo.personDeviceId forKey:@"person_device_id"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",self.oldBtn.tag] forKey:@"device_remove_type_id"];
    [parameters setObject:self.descTextField.text forKey:@"remove_remark"];
    [parameters setObject:self.deviceCode forKey:@"device_remove_code"];
    
    [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"device/2.0/device_remove"] parameters:parameters success:^(id responseObject) {
        long code = [responseObject[@"code"] longValue];
        if(code == 0){
            MHApartAppliedModel *model = [MHApartAppliedModel mj_objectWithKeyValues:responseObject[@"data"]];
            MHMachineApartAppliedViewController *apartApplyVc = [[MHMachineApartAppliedViewController alloc]init];
            apartApplyVc.model = model;
            [self.navigationController pushViewController:apartApplyVc animated:YES];
            apartApplyVc.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backToRoot)];
            apartApplyVc.navigationItem.rightBarButtonItem=nil;
        }else if(code == -1){
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:nil];
    
}

-(void)backToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
