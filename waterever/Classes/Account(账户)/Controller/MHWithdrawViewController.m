//
//  MHWithdrawViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHWithdrawViewController.h"
#import "MHCommonHeader.h"
#import "DNPayAlertView.h"
#import "NSString+Hash.h"

@interface MHWithdrawViewController ()

@property (weak, nonatomic) IBOutlet MDTextField *receiptsAccountLabel;
@property (weak, nonatomic) IBOutlet MDTextField *nameLabel;
@property (weak, nonatomic) IBOutlet MDTextField *moneyLabel;

- (IBAction)submitBtnClicked;
@end

@implementation MHWithdrawViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD setMinimumDismissTimeInterval:0.75];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.title = @"余额提现";
    self.moneyLabel.keyboardType = UIKeyboardTypeDecimalPad;
}

- (IBAction)submitBtnClicked {
//    if([self.balanceLabel.text doubleValue]<100){
//        [SVProgressHUD showErrorWithStatus:@"余额不足"];
//        return;
//    }

    if([self.receiptsAccountLabel.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"提现账户不能为空"];
        return;
    }
    
    if(![self.nameLabel.text isNameValid]){
        [SVProgressHUD showErrorWithStatus:@"请输入收款人姓名"];
        return;
    }
    
//    if([self.moneyLabel.text doubleValue]<100){
//        [SVProgressHUD showErrorWithStatus:@"提现金额不能少于100元"];
//        return;
//    }
    
    DNPayAlertView *payAlert = [[DNPayAlertView alloc]init];
    payAlert.title = @"请输入支付密码";
    payAlert.detail = @"提现";
    payAlert.amount= [self.moneyLabel.text floatValue];
    [payAlert show];
    payAlert.completeHandle = ^(NSString *inputPwd) {
        //doSomething
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[MHUserInfoTool sharedMHUserInfoTool].personId forKey:@"person_id"];
        [parameters setObject:self.moneyLabel.text forKey:@"money"];
        [parameters setObject:self.receiptsAccountLabel.text forKey:@"alipay_account"];
        [parameters setObject:self.nameLabel.text forKey:@"alipay_account_name"];
        [parameters setObject:[inputPwd md5String] forKey:@"md5_password"];
        [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"finance/2.0/out_balance"] parameters:parameters success:^(id responseObject) {
            int code = [responseObject[@"code"] intValue];
            if(code == 0){
                [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
            }else if(code == -1){
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            if(error){
                [SVProgressHUD showErrorWithStatus:@"网络超时"];
            }
        }];

    };
    
    
}
@end
