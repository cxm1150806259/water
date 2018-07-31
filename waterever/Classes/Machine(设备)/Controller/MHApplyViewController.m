//
//  MHApplyViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHApplyViewController.h"
#import "MHCommonHeader.h"
#import "MHUserInfoTool.h"
#import "MHApplyIdentityViewController.h"
#import "MHAddressSubmitViewController.h"

@interface MHApplyViewController ()
- (IBAction)applyBtnClicked;
@property (weak, nonatomic) IBOutlet MHMDTextField *identityNumberTextField;
@property (weak, nonatomic) IBOutlet MDTextField *nameTextField;

@end

@implementation MHApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.title = @"身份认证";
    self.identityNumberTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.identityNumberTextField.mhMaxTextCount = 18;
}


- (IBAction)applyBtnClicked {
    if(![self.nameTextField.text isNameValid]){
        [SVProgressHUD showErrorWithStatus:@"请输入合法的姓名"];
        return;
    }
    if(![self.identityNumberTextField.text isIdentityCardNumber]){
        [SVProgressHUD showErrorWithStatus:@"请输入合法的身份证号码"];
        return;
    }
    
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.nameTextField.text forKey:@"name"];
    [parameters setObject:self.identityNumberTextField.text forKey:@"id_card"];
    [parameters setObject:userInfo.personId forKey:@"person_id"];
    
    [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"apply/2.0/apply_device/mayi_score"] parameters:parameters success:^(id responseObject) {
        if([responseObject[@"status"] intValue] == 3000){
            //认证通过
            userInfo.applyDeviceId = responseObject[@"data"][@"applyDeviceId"];
            [MHUserInfoTool saveUserInfo];
            [SVProgressHUD showSuccessWithStatus:@"恭喜您，认证通过！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MHAddressSubmitViewController *vc = [[MHAddressSubmitViewController alloc]init];
                
                [self.navigationController pushViewController:vc animated:YES];
                
                //填写地址后 无法返回继续填写 直接返回首页
                vc.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backToRoot)];
                vc.navigationItem.rightBarButtonItem=nil;
            });
        }else if([responseObject[@"status"] intValue] == 3001){
            //上传身份证
            userInfo.applyDeviceId = responseObject[@"data"][@"applyDeviceId"];
            [MHUserInfoTool saveUserInfo];
            [SVProgressHUD showErrorWithStatus:@"认证失败，请上传身份证"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MHApplyIdentityViewController *vc = [[MHApplyIdentityViewController alloc]
                                                     init];
                vc.identifyCard = self.identityNumberTextField.text;
                [self.navigationController pushViewController:vc animated:YES];
                
                //认证失败进入上传身份证页面 无法直接返回重新认证
                vc.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backToRoot)];
                vc.navigationItem.rightBarButtonItem=nil;
            });
        }
    } failure:nil];
}

-(void)backToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
