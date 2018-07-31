//
//  MHMarginMoneyViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMarginMoneyViewController.h"
#import "MHMarginMoneyStatusModel.h"
#import "SCLAlertView.h"

@interface MHMarginMoneyViewController ()
@property (weak, nonatomic) IBOutlet MDTextField *marginMoneyLabel;
@property (weak, nonatomic) IBOutlet MDTextField *marginMoneyStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (IBAction)submitBtnClicked;
@property (weak, nonatomic) IBOutlet MDButton *submitBtn;
@property(nonatomic,strong)MHMarginMoneyStatusModel *model;
@end

@implementation MHMarginMoneyViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMarginMoneyStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"履约保证金";
}

-(void)setContent{
    if(self.model){
        self.marginMoneyLabel.text = self.model.deposit?[NSString stringWithFormat:@"%.2f元",[self.model.deposit doubleValue]]:@"0元";
        self.marginMoneyStatusLabel.text = self.model.depositStatusMsg;
        if([self.model.depositStatus intValue] == 1){
            self.submitBtn.enabled = YES;
            self.iconImageView.image = [UIImage imageNamed:@"APP2.9-46"];
            [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"3-25"] forState:UIControlStateNormal];
        }else{
            self.submitBtn.enabled = NO;
            self.iconImageView.image = [UIImage imageNamed:@"APP2.9-45"];
        }
    }
}

-(void)getMarginMoneyStatus{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userInfo.personId forKey:@"person_id"];
    
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingFormat:@"finance/2.4/deposit/%@/%@",userInfo.personId,userInfo.applyDeviceId] parameters:parameters success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            self.model = [MHMarginMoneyStatusModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self setContent];
        }else if(code == -1){
//            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:nil];
}

-(void)withdrawMarginMoney{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if(userInfo.personDeviceId) [parameters setObject:userInfo.personDeviceId forKey:@"person_device_id"];
    [parameters setObject:userInfo.applyDeviceId forKey:@"apply_device_id"];
    [parameters setObject:userInfo.personId forKey:@"person_id"];
    [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"finance/2.0/return_deposit"] parameters:parameters success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            userInfo.currentStepVc = nil;
            [MHUserInfoTool saveUserInfo];
            //发送通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MHMachineCountRefresh" object:nil];
            
            SCLAlertView *alert = [[SCLAlertView alloc]init];
            [alert setHorizontalButtons:YES];
            alert.customViewColor = MHUIColorFromHex(0x3e91ff);
            [alert addButton:@"好的" actionBlock:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert showSuccess:self title:nil subTitle:[NSString stringWithFormat:@"\n%@\n",responseObject[@"msg"]] closeButtonTitle:nil duration:0.0f];
        }else if(code == -1){
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:nil];
}
- (IBAction)submitBtnClicked {
    [self withdrawMarginMoney];
}
@end
