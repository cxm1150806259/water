//
//  MHApplySuccessViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHApplySuccessViewController.h"
#import "MHCommonHeader.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import "MHWXPayModel.h"
#import "STPickerArea.h"
#import "WSDatePickerView.h"

#define MINDATE [NSDate dateTomorrow]
#define MAXDATE [NSDate dateWithDaysFromNow:90]

@interface MHApplySuccessViewController ()<STPickerAreaDelegate>
@property (nonatomic, strong) STPickerArea *pickerArea;
@property (weak, nonatomic) IBOutlet MHTextView *setupAddressTextView;
@property (weak, nonatomic) IBOutlet UIButton *wxpayBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (strong, nonatomic) MHWXPayModel *wxPayModel;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet MDButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

- (IBAction)areaBtnClicked;
- (IBAction)okBtnClicked;
- (IBAction)submitBtnClicked;
- (IBAction)wxpayBtnClicked;
- (IBAction)alipayBtnClicked;
- (IBAction)dateBtnClicked;
@end

@implementation MHApplySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addNoti];
    
}

-(STPickerArea *)pickerArea{
    if(!_pickerArea){
        _pickerArea = [[STPickerArea alloc]init];
        [_pickerArea setDelegate:self];
        [_pickerArea setSaveHistory:YES];
        [_pickerArea setContentMode:STPickerContentModeCenter];
    }
    return _pickerArea;
}

#pragma mark STPickerAreaDelegate
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    [self.areaBtn setTitle:text forState:UIControlStateNormal];
}

- (IBAction)areaBtnClicked {
    [self.view endEditing:YES];
    [self.pickerArea show];
}

- (IBAction)dateBtnClicked {
    [self.view endEditing:YES];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        [self.dateBtn setTitle:date forState:UIControlStateNormal];
        
    }];
    
    datepicker.minLimitDate = MINDATE;
    datepicker.maxLimitDate = MAXDATE;
    
    datepicker.dateLabelColor = [UIColor orangeColor];//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
    [datepicker show];
}

- (IBAction)okBtnClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setupUI{
    if(self.flag == 0){
        self.payView.hidden = YES;
        self.title = @"申请成功";
    }else{
        self.payView.hidden = NO;
        self.title = @"支付安装费用";
    }
}

- (IBAction)wxpayBtnClicked {
    self.flag = 0;
    self.wxpayBtn.selected = YES;
    [self.alipayBtn setBackgroundColor:[UIColor clearColor]];
    self.alipayBtn.selected=NO;
}
- (IBAction)alipayBtnClicked {
    self.flag = 1;
    self.alipayBtn.selected=YES;
    [self.wxpayBtn setBackgroundColor:[UIColor clearColor]];
    self.wxpayBtn.selected=NO;
}

- (IBAction)submitBtnClicked {
    
    if([self.dateBtn.currentTitle isEqualToString:@"请选择>"]){
        [self shake:self.dateBtn];
        return;
    }
    
    if([self.areaBtn.currentTitle isEqualToString:@"请选择>"]){
        [self shake:self.areaBtn];
        return;
    }
    
    if(self.setupAddressTextView.text.length < 5){
        [SVProgressHUD showErrorWithStatus:@"详细地址不得少于5个字"];
        return;
    }
    if(self.alipayBtn.isSelected||self.wxpayBtn.isSelected){
        MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:userInfo.applyDeviceId forKey:@"apply_device_id"];
        [parameters setObject:userInfo.personId forKey:@"person_id"];
        [parameters setObject:self.areaBtn.currentTitle forKey:@"install_area"];
        [parameters setObject:self.setupAddressTextView.text forKey:@"install_address"];
        [parameters setObject:self.dateBtn.currentTitle forKey:@"date_appointment"];
        
        if(self.flag == 0){
            //  微信支付
            [parameters setObject:@"2" forKey:@"pay_type"];
            [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"pay/2.3/door_to_door"] parameters:parameters success:^(id responseObject) {
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
            
            [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"pay/2.3/door_to_door"] parameters:parameters success:^(id responseObject) {
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
    [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"pay/2.2/alipay_notify"] parameters:parameters success:^(id responseObject) {
        //支付成功后进入下一界面
        [self setupMoneyPaid];
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
    [self.setupAddressTextView addObserver];
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
    [MHNetWorkTool POSTWITHHEADER:[WATEREVERHOST stringByAppendingString:@"pay/2.2/wxpay_notify"] parameters:parameters success:^(id responseObject) {
        //支付成功后进入下一界面
        [self setupMoneyPaid];
    } failure:nil];

}

-(void)setupMoneyPaid{
    //上门安装服务费交付之后
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark Animations

- (void)shake:(UIButton *)btn
{
    self.submitBtn.userInteractionEnabled = NO;
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @1000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.submitBtn.userInteractionEnabled = YES;

    }];
    [btn.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

@end
