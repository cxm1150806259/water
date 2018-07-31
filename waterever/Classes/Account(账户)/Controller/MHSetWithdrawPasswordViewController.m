//
//  MHSetWithdrawPasswordViewController.m
//  waterever
//
//  Created by qyyue on 2017/9/8.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHSetWithdrawPasswordViewController.h"
#import "MHCodeView.h"
#import "MHCommonHeader.h"
#import "NSString+Hash.h"

@interface MHSetWithdrawPasswordViewController ()
- (IBAction)submitBtnClicked;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property(nonatomic,strong) NSString *password;
@end

@implementation MHSetWithdrawPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码设置";
    [self addCodeView];
}

-(void)addCodeView{
    MHCodeView *codeView = [[MHCodeView alloc]initWithFrame:CGRectMake(0, 0, 290, 43) num:6 lineColor:[UIColor blackColor] textFont:20];
    codeView.hasUnderLine = YES;
    codeView.hasSpaceLine = YES;
    codeView.codeType = CodeViewTypeSecret;
    codeView.EndEditBlcok = ^(NSString *str) {
        self.password = str;
    };
    [self.contentView addSubview:codeView];
}

- (IBAction)submitBtnClicked {
    if(!self.password){
        [SVProgressHUD showErrorWithStatus:@"请设置6位提现密码"];
        return;
    }else{
        MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:userInfo.personId forKey:@"person_id"];
        [parameters setObject:[self.password md5String] forKey:@"md5_password"];
        
        [MHNetWorkTool PATCHWITHHEADER:[WATEREVERHOST stringByAppendingFormat:@"finance/2.0/password/%@",userInfo.personId] parameters:parameters success:^(id responseObject) {
            int code = [responseObject[@"code"] intValue];
            if(code == 0){
                [SVProgressHUD showSuccessWithStatus:@"设置提现密码成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else if(code == -1){
                [SVProgressHUD showErrorWithStatus:@"设置失败"];
            }
            
        } failure:^(NSError *error) {
            if(error){
                NSLog(@"%@",error);
            }
        }];
    }
}
@end
