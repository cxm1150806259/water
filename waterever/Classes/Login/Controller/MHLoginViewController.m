//
//  MHLoginViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/22.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHLoginViewController.h"
#import "MHCommonHeader.h"
#import "MHPersonModel.h"
#import "MHSetupProgressViewController.h"
#import "MHSeeProtocolViewController.h"
#import "JPUSHService.h"
#import "MHNavViewController.h"
#import "MHHomeViewController.h"


@interface MHLoginViewController ()
- (IBAction)loginBtnClicked;
@property (weak, nonatomic) IBOutlet MHTextField *telTextField;
@property (weak, nonatomic) IBOutlet MHTextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)sendCodeBtnClicked;
- (IBAction)seeProtocolBtnClicked;


@end

@implementation MHLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    
    

    [self getUserSurport];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    //如果缓存中有账号 则设置上去
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    self.telTextField.text = userInfo.phone?userInfo.phone:@"";

    self.telTextField.mhMaxTextCount = 11;
    self.codeTextField.mhMaxTextCount = 6;
    
    //添加登录按钮的动画
    [self.loginBtn addTarget:self action:@selector(scaleToSmall) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self.loginBtn addTarget:self action:@selector(scaleAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn addTarget:self action:@selector(scaleToDefault) forControlEvents:UIControlEventTouchDragExit];
    
}

- (void)scaleToSmall
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
    [self.loginBtn.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 10.0f;
    [self.loginBtn.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.loginBtn.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}

- (IBAction)loginBtnClicked {
    if(self.telTextField.text.length == 11){
        if(self.codeTextField.text.length != 6){
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
            return;
        }
        [SVProgressHUD showWithStatus:@"正在登录..."];
        MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
        [MHUserInfoTool loadUserInfo];
        userInfo.phone = self.telTextField.text;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:userInfo.phone forKey:@"phone"];
        [parameters setObject:[self.codeTextField.text md5String] forKey:@"password"];
        
        [MHNetWorkTool POST:[WATEREVERHOST stringByAppendingString:@"god/2.2/login"] parameters:parameters success:^(id responseObject) {

            long code = [responseObject[@"code"] longValue];
            if(code == 0){
                MHPersonModel *personModel = [MHPersonModel mj_objectWithKeyValues:responseObject[@"data"]];
                userInfo.personId = personModel.personId;
                userInfo.token = personModel.token;
                userInfo.applyDeviceId = personModel.applyDeviceId;
                userInfo.isLogin = YES;
                userInfo.telePhone = personModel.telePhone;
                userInfo.personTypeId = personModel.personTypeId;
                userInfo.personAccount = personModel.personAccount;
                userInfo.tokenLimitDate = personModel.tokenLimitDate;
                [MHUserInfoTool saveUserInfo];
                
                KEYWINDOW.rootViewController = [[MHNavViewController alloc]initWithRootViewController:[[MHHomeViewController alloc]init]];
                 
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                
                [JPUSHService setAlias:self.telTextField.text completion:nil seq:0];
            }else if(code == -1){
                [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
            }
            
        } failure:^(NSError *error) {
            if(error){
                [SVProgressHUD showErrorWithStatus:@"网络超时"];
            }
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
    }
}



- (IBAction)sendCodeBtnClicked {
    if(self.telTextField.text.length == 11){
        [self.sendCodeBtn countDownWithTimeInterval:10];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:self.telTextField.text forKey:@"phone"];
        [parameters setObject:@1 forKey:@"code_type_id"];
        
        [MHNetWorkTool POST:[WATEREVERHOST stringByAppendingString:@"tools/2.0/get_mobile_code"] parameters:parameters success:^(id responseObject) {
            int code = [responseObject[@"code"] intValue];
            code == 0?[SVProgressHUD showSuccessWithStatus:@"验证码已发送"]:[SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            
        } failure:^(NSError *error) {
            if(error){
                [SVProgressHUD showErrorWithStatus:@"网络超时"];
            }
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
    }
}

- (IBAction)seeProtocolBtnClicked {
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    if(!userInfo.userSurportUrlString){
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
        return;
    }
    [MHUserInfoTool saveUserInfo];
    MHSeeProtocolViewController *vc = [[MHSeeProtocolViewController alloc]init];
    vc.urlString = userInfo.userSurportUrlString;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getUserSurport{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    if(userInfo.userSurportUrlString) return;
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingString:@"tools/2.0/user_surport"] parameters:nil success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            userInfo.userSurportUrlString = responseObject[@"data"];
        }
    } failure:nil];
}

@end
