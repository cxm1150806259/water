//
//  MHMyGiftViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMyGiftViewController.h"
#import "MHCommonHeader.h"
#import "MHMyGiftModel.h"

@interface MHMyGiftViewController ()
@property(nonatomic,strong) NSArray<MHMyGiftModel *> *giftArray;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *fortyNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifteenNumberLabel;
- (IBAction)saveInBtnClicked;

@end

@implementation MHMyGiftViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的红包";
    [self getMyGiftInfo];
}

-(void)getMyGiftInfo{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingFormat:@"finance/2.0/red_packet/%@",userInfo.personId] parameters:@{@"":userInfo.personId} success:^(id responseObject) {
        [SVProgressHUD dismiss];
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            self.giftArray = [MHMyGiftModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshContent];
            });
        }else if(code == -1){
//            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        if(error){
            [SVProgressHUD showErrorWithStatus:@"网络超时"];
        }
    }];
}

-(void)refreshContent{
    double totalMoney = 0;
    for (MHMyGiftModel *model in self.giftArray) {
        if([model.rewardId isEqualToString:@"1"]){
            //40
            self.fortyNumberLabel.text = [NSString stringWithFormat:@"新增%@个分享红包",model.number];
            totalMoney+=[model.money intValue];
        }else if([model.rewardId isEqualToString:@"2"]){
            //15
            self.fifteenNumberLabel.text = [NSString stringWithFormat:@"新增%@个奖励红包",model.number];
            totalMoney+=[model.money intValue];
        }
    }
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f",totalMoney];
}
- (IBAction)saveInBtnClicked {
    if([self.totalMoneyLabel.text doubleValue] <= 0){
        [SVProgressHUD showErrorWithStatus:@"红包余额不足"];
        return;
    }
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    [MHNetWorkTool PATCHWITHHEADER:[WATEREVERHOST stringByAppendingFormat:@"finance/2.0/red_packet/%@",userInfo.personId] parameters:@{@"person_id":userInfo.personId} success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            [SVProgressHUD showSuccessWithStatus:@"转入成功"];
        }else if(code == -1){
            [SVProgressHUD showErrorWithStatus:@"转入失败，请稍后重试"];
        }
    } failure:nil];
}
@end
