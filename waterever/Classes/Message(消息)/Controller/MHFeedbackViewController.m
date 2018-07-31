//
//  MHFeedbackViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHFeedbackViewController.h"
#import "MHNetWorkTool.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MHTextView.h"

@interface MHFeedbackViewController ()
- (IBAction)submitBtnClicked;

@property (weak, nonatomic) IBOutlet MHTextView *descTextView;
@end

@implementation MHFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self.descTextView addObserver];
}

- (IBAction)submitBtnClicked {
    if([self.descTextView.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请填写反馈内容"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[MHUserInfoTool sharedMHUserInfoTool].personId forKey:@"person_id"];
    [parameters setObject:self.descTextView.text forKey:@"description"];
    [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"god/2.0/feedback"] parameters:parameters success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            [SVProgressHUD showSuccessWithStatus:@"反馈成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if(code == -1){
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }

    } failure:nil];
}
@end
