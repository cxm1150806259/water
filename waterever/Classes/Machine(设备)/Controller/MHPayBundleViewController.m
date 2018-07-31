//
//  MHPayBundleViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHPayBundleViewController.h"
#import "MHPayBundleSuccessViewController.h"
#import "MHCommonHeader.h"
#import "MHPayBundleTableViewCell.h"
#import "MHWXPayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

@interface MHPayBundleViewController ()
@property(nonatomic,assign) int flag;
@property (weak, nonatomic) IBOutlet UIButton *wxpayBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (strong, nonatomic) MHWXPayModel *wxPayModel;
- (IBAction)wxpayBtnClicked;
- (IBAction)alipayBtnClicked;
- (IBAction)payBtnClicked;

@end

@implementation MHPayBundleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"套餐支付";
    [self initView];
    [self addNoti];
}

-(void)initView{
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    anim.duration = 0.5;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) { prop.readBlock = ^(id obj, CGFloat values[]) {
        values[0] = [[obj description] floatValue];};
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            [obj setText:[NSString stringWithFormat:@"%.f",values[0]]];};
        prop.threshold = 1;}];
    anim.property = prop;
    anim.fromValue = @(0.0);
    anim.toValue = @([self.saleBundleModel.salePrice intValue]);
    [self.priceLabel pop_addAnimation:anim forKey:@""];
}

- (IBAction)wxpayBtnClicked {
    self.flag = 0;
    self.wxpayBtn.selected = YES;
    self.alipayBtn.selected=NO;
}
- (IBAction)alipayBtnClicked {
    self.flag = 1;
    self.alipayBtn.selected=YES;
    self.wxpayBtn.selected=NO;

}

- (IBAction)payBtnClicked {
    if(self.alipayBtn.isSelected||self.wxpayBtn.isSelected){
        MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:userInfo.personId forKey:@"person_id"];
        [parameters setObject:userInfo.personDeviceId forKey:@"person_device_id"];
        [parameters setObject:self.saleBundleModel.salePackageTypeId forKey:@"payment_subject"];
        [parameters setObject:self.saleBundleModel.salePackageId forKey:@"sale_package_id"];
        
        if(self.flag == 0){
            //  微信支付
            [parameters setObject:@"2" forKey:@"pay_type"];
            [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"pay/2.0/sale_package"] parameters:parameters success:^(id responseObject) {
                int code = [responseObject[@"code"] intValue];
                if(code == -1){
                    [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
                }else{
                    self.wxPayModel = [MHWXPayModel mj_objectWithKeyValues:responseObject[@"data"]];
                    [self payWithWx];
                }
            } failure:nil];
        }else{
            //支付宝支付
            [parameters setObject:@"1" forKey:@"pay_type"];
            
            [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"pay/2.0/sale_package"] parameters:parameters success:^(id responseObject) {
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
    }else{
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
    }
}

- (void)checkAliPayResultDic:(NSDictionary *)resultDic
{
    NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
    NSString *memo;
    if ([resultStatus intValue] == 9000) {
        memo = @"支付成功!";
        [SVProgressHUD showSuccessWithStatus:memo];
        [self submitAliPayResultDic:resultDic];
    }else {
        switch ([resultStatus intValue]) {
            case 4000:
                memo = @"失败原因:订单支付失败!";
                break;
            case 6001:
                memo = @"失败原因:用户中途取消!";
                break;
            case 6002:
                memo = @"失败原因:网络连接出错!";
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

-(void)submitAliPayResultDic:(NSDictionary *)resultDic{
    NSString *resultkey = resultDic[@"result"];
    NSString *resultStatusKey = resultDic[@"resultStatus"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:resultkey forKey:@"pay_result_json"];
    [parameters setObject:resultStatusKey forKey:@"result_status"];
    [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"pay/alipay_salepackage_notify"] parameters:parameters success:^(id responseObject) {
        //支付成功后进入下一界面
        [self bundlePaid];
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
    [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"pay/wxpay_salepackage_notify"] parameters:parameters success:^(id responseObject) {
        //支付成功后进入下一界面
        [self bundlePaid];
    } failure:nil];
}

-(void)bundlePaid{
    MHPayBundleSuccessViewController *vc = [[MHPayBundleSuccessViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    //设置无法返回 以及取消返回按钮
    vc.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backToRoot)];
    vc.navigationItem.rightBarButtonItem=nil;
}

-(void)backToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
