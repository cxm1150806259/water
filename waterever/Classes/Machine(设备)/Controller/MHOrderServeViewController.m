//
//  MHOrderServeViewController.m
//  waterever
//
//  Created by qyyue on 2017/11/6.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHOrderServeViewController.h"
#import "MHCommonHeader.h"
#import "STPickerArea.h"
#import "WSDatePickerView.h"
#import "SCLAlertView.h"

#define MINDATE [NSDate dateTomorrow]
#define MAXDATE [NSDate dateWithDaysFromNow:90]

@interface MHOrderServeViewController ()<STPickerAreaDelegate>
- (IBAction)areaPickBtnClicked;
- (IBAction)okBtnClicked;
- (IBAction)dateBtnClicked;

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet MHTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *areaPickBtn;
@property (weak, nonatomic) IBOutlet MHTextView *detailTextView;
@property(nonatomic,strong) STPickerArea *pickerArea;

@end

@implementation MHOrderServeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if(self.orderServeModel){
        [self setupUI];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改预约信息";
    [self.detailTextView addObserver];
}

-(void)setupUI{
    [self.dateBtn setTitle:self.orderServeModel.dateAppointment forState:UIControlStateNormal];
    self.nameTextField.text = self.orderServeModel.customerName;
    self.phoneTextField.text = self.orderServeModel.customerPhone;
    [self.areaPickBtn setTitle:self.orderServeModel.area forState:UIControlStateNormal];
    self.detailTextView.text = self.orderServeModel.address;
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
    [self.areaPickBtn setTitle:text forState:UIControlStateNormal];
}

- (IBAction)areaPickBtnClicked {
    [self.view endEditing:YES];
    [self.pickerArea show];
}
- (IBAction)okBtnClicked {
    if([self.dateBtn.currentTitle isEqualToString:@"请选择预约时间"]){
        [SVProgressHUD showErrorWithStatus:@"请选择预约时间"];
        return;
    }
    
    if([self.nameTextField.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入联系人的姓名"];
        return;
    }
    
    if(self.phoneTextField.text.length != 11){
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    
    if([self.areaPickBtn.currentTitle isEqualToString:@"请选择区域"]){
        [SVProgressHUD showErrorWithStatus:@"请选择区域"];
        return;
    }
    
    if(self.detailTextView.text.length < 5){
        [SVProgressHUD showErrorWithStatus:@"请输入详细收货地址,不少于5个字"];
        return;
    }

    
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userInfo.applyDeviceId forKey:@"apply_device_id"];
    [parameters setObject:self.dateBtn.currentTitle forKey:@"date_appointment"];
    [parameters setObject:self.nameTextField.text forKey:@"customer_name"];
    [parameters setObject:self.phoneTextField.text forKey:@"customer_phone"];
    [parameters setObject:self.areaPickBtn.currentTitle forKey:@"area"];
    [parameters setObject:self.detailTextView.text forKey:@"address"];
    
    
    [MHNetWorkTool POST:[WATEREVERHOST stringByAppendingString:@"after_sale/appointment"] parameters:parameters success:^(id responseObject) {
        long code = [responseObject[@"code"] longValue];
        if(code == 0){
            SCLAlertView *alert = [[SCLAlertView alloc]init];
            [alert addButton:@"确定" actionBlock:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert showSuccess:self title:nil subTitle:@"\n修改成功\n" closeButtonTitle:nil duration:0.0f];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:nil];
}

- (IBAction)dateBtnClicked {
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        [self.dateBtn setTitle:date forState:UIControlStateNormal];
        
    }];
    
    datepicker.minLimitDate = MINDATE;
    datepicker.maxLimitDate = MAXDATE;
    
    datepicker.dateLabelColor = [UIColor orangeColor];
    datepicker.datePickerColor = [UIColor blackColor];
    datepicker.doneButtonColor = [UIColor orangeColor];
    [datepicker show];
}


@end
