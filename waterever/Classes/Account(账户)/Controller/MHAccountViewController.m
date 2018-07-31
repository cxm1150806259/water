//
//  MHAccountViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHAccountViewController.h"
#import "MHCommonHeader.h"
#import "MHGuidanceViewController.h"
#import "MHMyBillViewController.h"
#import "MHWithdrawViewController.h"
#import "MHAboutUsViewController.h"
#import "MHShareViewController.h"
#import "MHMarginMoneyViewController.h"
#import "MHChangeTelViewController.h"
#import "MHMyGiftViewController.h"
#import "MHLoginViewController.h"
#import "MHBalanceModel.h"
#import "MHSetWithdrawPasswordViewController.h"
#import "MHNavViewController.h"
#import "MHPayDetailModel.h"
#import "JPUSHService.h"
#import "UIBarButtonItem+MHEXTENSION.h"
#import "MHPopTool.h"
#import "SCLAlertView.h"
#import "MHCommonHeader.h"


@interface MHAccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property(nonatomic,strong) MHBalanceModel *model;
@property(nonatomic,strong) NSMutableArray<MHPayDetailModel *> *payDetailDataArrayM;
//退出清空之前先保存下来，清空后重新保存
@property(nonatomic,strong) NSString *tempPhone;

- (IBAction)withdrawBtnClicked;
- (IBAction)firstFuncBtnClicked;
- (IBAction)secondFuncBtnClicked;
- (IBAction)thirdFuncBtnClicked;
- (IBAction)fourthFuncBtnClicked;
- (IBAction)fifthFuncBtnClicked;
- (IBAction)logoutFuncBtnClicked;

@end

@implementation MHAccountViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNav];
    //获取余额
    [self getBalance];
    //获取账单明细
    [self getPayList];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账户";
}

-(void)initNav{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:nil Target:self Action:@selector(dismissBtnClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(detailBtnClicked)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

-(NSMutableArray<MHPayDetailModel *> *)payDetailDataArrayM{
    if(!_payDetailDataArrayM){
        _payDetailDataArrayM = [NSMutableArray array];
    }
    return _payDetailDataArrayM;
}

- (void)detailBtnClicked {
    MHMyBillViewController *billVc = [[MHMyBillViewController alloc]init];
    billVc.payDetailDataArrayM = self.payDetailDataArrayM;
    billVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:billVc animated:YES];

}

//获取账单明细
-(void)getPayList{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingString:@"finance/2.0/pay_list"] parameters:@{@"person_id":userInfo.personId} success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            self.payDetailDataArrayM = [MHPayDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        }else if(code == -1){

        }
    } failure:nil];
}

//提现
- (IBAction)withdrawBtnClicked {
    //判断是否已设置提现密码
    if(self.model){
        if([self.model.passwordSet intValue] == 0){
            MHSetWithdrawPasswordViewController *vc = [[MHSetWithdrawPasswordViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MHWithdrawViewController *withdraw = [[MHWithdrawViewController alloc]init];
            [withdraw.view layoutIfNeeded];
            withdraw.balanceLabel.text = self.balanceLabel.text;

            withdraw.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:withdraw animated:YES];
        }
    }
}

- (IBAction)firstFuncBtnClicked {
    MHMyGiftViewController *vc = [[MHMyGiftViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)secondFuncBtnClicked {
    MHShareViewController *vc = [[MHShareViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)thirdFuncBtnClicked {
    MHMarginMoneyViewController *vc = [[MHMarginMoneyViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)fourthFuncBtnClicked {
    //用户指南
    MHGuidanceViewController *vc = [[MHGuidanceViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)fifthFuncBtnClicked {
    MHAboutUsViewController *vc = [[MHAboutUsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)logoutFuncBtnClicked {
    //退出
    SCLAlertView *alert = [[SCLAlertView alloc]init];
    [alert setHorizontalButtons:YES];
    alert.customViewColor = MHUIColorFromHex(0x3e91ff);
    [alert addButton:@"退出登录" actionBlock:^{
        [self clearFile];
        KEYWINDOW.rootViewController = [[MHNavViewController alloc]initWithRootViewController:[[MHLoginViewController alloc]init]];
    }];
    [alert showInfo:self title:nil subTitle:@"\n退出登录后将清空本地数据\n" closeButtonTitle:@"取消" duration:0.0f];

}

- (void)dismissBtnClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//获取账户信息
-(void)getBalance{
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    anim.duration = 0.5;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) { prop.readBlock = ^(id obj, CGFloat values[]) {
        values[0] = [[obj description] floatValue];};
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setText:[NSString stringWithFormat:@"%.2f",values[0]]];};
        prop.threshold = 1;}];
    anim.property = prop;
    anim.fromValue = @(0.00);
    
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingFormat:@"finance/2.0/balance/%@",userInfo.personId] parameters:@{@"person_id":userInfo.personId} success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            self.model = [MHBalanceModel mj_objectWithKeyValues:responseObject[@"data"]];
            anim.toValue = @([self.model.banance doubleValue]);
            [self.balanceLabel pop_addAnimation:anim forKey:@""];
        }else if(code == -1){

        }

    } failure:nil];
}

- (void)clearFile
{
    //清空前保存当前手机号
    self.tempPhone = [MHUserInfoTool sharedMHUserInfoTool].phone;
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:APPPATH]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:APPPATH];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [APPPATH stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    //删除之后 先重新加载一遍 避免删除失败
    [MHUserInfoTool loadUserInfo];
    
    //重新写入版本号，避免引导页再次出现
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *newVersion=[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [userDefaults setObject:newVersion forKey:@"CFBundleShortVersionString"];
    [userDefaults synchronize];
    
    //保存当前用户手机号
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    userInfo.phone = self.tempPhone;
    [MHUserInfoTool saveUserInfo];
    
    
    [JPUSHService deleteAlias:nil seq:0];
    
}

@end
