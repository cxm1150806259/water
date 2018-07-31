//
//  MHPayCashViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHPayCashViewController.h"
#import "MHCommonHeader.h"
#import "MHApplySuccessViewController.h"
#import "MHWXPayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>


@interface MHPayCashViewController ()
@property(nonatomic,assign) int flag;
@property (weak, nonatomic) IBOutlet UIImageView *wxpayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alipayImageView;
@property (weak, nonatomic) IBOutlet UIView *wxpayView;
@property (weak, nonatomic) IBOutlet UIView *alipayView;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyDescLabel;
@property (strong, nonatomic) MHWXPayModel *wxPayModel;
- (IBAction)payBtnClicked;
@end

@implementation MHPayCashViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //获取保证金数额
    [self getDepositCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    self.title = @"支付";
//    self.moneyDescLabel.text = self.setupFlag==0?@"含保证金498元+首年套餐365元":@"含保证金498元+首年套餐550元+上门安装80元";
    self.moneyDescLabel.width = 0.6*width;
    [self saveCurrentVc];
    [self addNoti];
    [self addGes];
}

-(void)addGes{
    //wx
    UITapGestureRecognizer *wxTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wxpayViewClicked)];
    [self.wxpayView addGestureRecognizer:wxTap];
    //ali
    UITapGestureRecognizer *aliTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alipayViewpayClicked)];
    [self.alipayView addGestureRecognizer:aliTap];
}

-(void)wxpayViewClicked{
    self.flag = 0;
    self.wxpayImageView.image = [UIImage imageNamed:@"pay_selected"];
    self.alipayImageView.image = [UIImage imageNamed:@"pay_unselected"];
}

-(void)alipayViewpayClicked{
    self.flag = 1;
    self.alipayImageView.image = [UIImage imageNamed:@"pay_selected"];
    self.wxpayImageView.image = [UIImage imageNamed:@"pay_unselected"];
}

-(void)getDepositCount{
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    anim.duration = 0.5;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) { prop.readBlock = ^(id obj, CGFloat values[]) {
        values[0] = [[obj description] floatValue];};
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setText:[NSString stringWithFormat:@"￥%.f",values[0]]];};
        prop.threshold = 1;}];
    anim.property = prop;
    anim.fromValue = @(0.0);
    
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingFormat:@"apply/3.0/amount/%@",userInfo.applyDeviceId] parameters:nil success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == -1){
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }else{
//            anim.toValue = @([responseObject[@"data"] intValue]);
            //@Mark2Win 2018-07-24
            NSDictionary *data = [responseObject objectForKey:@"data"];
//            float totalmoney = [[data objectForKey:@"totalMoney"] floatValue] * 0.01 ;
            NSString *totalmoney = [data objectForKey:@"totalMoney"];
            NSLog(@"data is %@",[data objectForKey:@"description"]);
//            [self.depositLabel pop_addAnimation:anim forKey:@""];
            self.depositLabel.text = [@"¥" stringByAppendingString:totalmoney]  ;
            self.moneyDescLabel.text = [data objectForKey:@"description"];
        }
    } failure:nil];
}

-(void)saveCurrentVc{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    userInfo.currentStepVc = @"MHPayCashViewController";
    [MHUserInfoTool saveUserInfo];
}

- (IBAction)payBtnClicked {
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userInfo.applyDeviceId forKey:@"apply_device_id"];
    [parameters setObject:userInfo.personId forKey:@"person_id"];
    if(self.flag == 0){
        //  微信支付
        [parameters setObject:@"2" forKey:@"pay_type"];
        [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"apply/3.0/pay_all"] parameters:parameters success:^(id responseObject) {
            int code = [responseObject[@"code"] intValue];
            if(code == -1){
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }else{
                self.wxPayModel = [MHWXPayModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self payWithWx];
            }

        } failure:^(NSError *error) {
            if(error) {
                NSLog(@"%@",error);
            }
        }];
    }else{
        //支付宝支付
        [parameters setObject:@"1" forKey:@"pay_type"];

        [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"apply/3.0/pay_all"] parameters:parameters success:^(id responseObject) {
            int code = [responseObject[@"code"] intValue];
            if(code == -1){
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }else{
                [[AlipaySDK defaultService] payOrder:responseObject[@"data"] fromScheme:@"alisdkdemo" callback:^(NSDictionary *resultDic) {
                    [self checkAliPayResultDic:resultDic];

                }];
            }
        } failure:nil];
    }

}

- (void)checkAliPayResultDic:(NSDictionary *)resultDic
{
    NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
    NSString *memo;
    if ([resultStatus intValue] == 9000) {
        memo = @"支付成功!";
        [SVProgressHUD showSuccessWithStatus:memo];
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MHMachineCountRefresh" object:nil];
        [self submitAliPayResultDic:resultDic];
    }else {
        switch ([resultStatus intValue]) {
            case 4000:
                memo = @"订单支付失败!";
                break;
            case 6001:
                memo = @"用户中途取消!";
                break;
            case 6002:
                memo = @"网络连接出错!";
                break;
            case 8000:
                memo = @"正在处理中...";
                break;
            default:
                memo = [resultDic objectForKey:@"memo"];
                break;
        }
        [SVProgressHUD showErrorWithStatus:memo];
    }
    
}


//支付宝 支付成功后 回调给后台
-(void)submitAliPayResultDic:(NSDictionary *)resultDic{
    NSString *resultkey = resultDic[@"result"];
    NSString *resultStatusKey = resultDic[@"resultStatus"];
    
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:resultkey forKey:@"pay_result_json"];
    [parameters setObject:userInfo.applyDeviceId forKey:@"apply_device_id"];
    [parameters setObject:resultStatusKey forKey:@"result_status"];
    [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"pay/3.0/alipay_notify"] parameters:parameters success:^(id responseObject) {
        //支付成功后进入下一界面
        [self depositPaid];
    } failure:nil];
}

-(void)payWithWx{
    PayReq* req = [[PayReq alloc] init];
    req.partnerId = self.wxPayModel.partnerid;
    req.prepayId = self.wxPayModel.prepayid;
    req.nonceStr = self.wxPayModel.noncestr;
    req.timeStamp = self.wxPayModel.timestamp;
    req.package = self.wxPayModel.package;
    req.sign = self.wxPayModel.sign;
    [WXApi sendReq:req];
}

-(void)addNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpayResult:) name:@"getWXPayResultNotification" object:nil];
}

-(void)wxpayResult:(NSNotification *)notification{
    BaseResp *resp = [notification.userInfo objectForKey:@"resp"];
    NSString *memo;
    if([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp *)resp;
        if(resp.errCode == WXSuccess){
            memo=@"支付成功!";
            [SVProgressHUD showSuccessWithStatus:memo];
            //发送通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MHMachineCountRefresh" object:nil];
            [self submitWXPayResult];
        }else{
            switch (response.errCode) {
                case WXErrCodeCommon:
                    memo=@"支付错误!";
                    break;
                case WXErrCodeUserCancel:
                    memo=@"用户中途取消!";
                    break;
                default:
                    memo = response.errStr;
                    break;
            }
            [SVProgressHUD showErrorWithStatus:memo];
        }
    }
}

-(void)submitWXPayResult{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userInfo.applyDeviceId forKey:@"apply_device_id"];
    [parameters setObject:self.wxPayModel.paymentdetailid forKey:@"payment_detail_id"];
    [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"pay/3.0/wxpay_notify"] parameters:parameters success:^(id responseObject) {
        //支付成功后进入下一界面
        [self depositPaid];
    } failure:nil];
}

-(void)depositPaid{
    MHApplySuccessViewController *vc = [[MHApplySuccessViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    //支付保障金成功后无法返回重新支付
    vc.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backToRoot)];
    vc.navigationItem.rightBarButtonItem=nil;
}

-(void)backToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
